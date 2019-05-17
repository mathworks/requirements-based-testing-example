classdef EmbeddedWebViewSDD < slreportgen.webview.EmbeddedWebViewDocument
    %EMBEDDEDWEBVIEWSDD Create a Web View-based system design description
    %   An instance of this class generates an HTML description of a model
    %   containing a Web View of the model being described. The resulting
    %   SDD contains three panes from right to left: a table of content
    %   (TOC) pane in the left pane, the system design description in the
    %   center pane, and the Web View in the right pane. The Web View
    %   initially displays the model's root diagram. You can navigate to
    %   subsystems and charts in the Web View as you would in the Simulink
    %   Editor. Two-way hyperlinks connect headings in the description to
    %   corresponding objects in the Web View. Clicking on a heading for an
    %   object in the SDD opens the containing subsystem in the Web View
    %   and highlights the object. Clicking on an object in the Web View
    %   scrolls the SDD to the object's description.
    %
    %   Example:
    %
    %   modelName = 'sf_boiler';
    %   load_system(modelName);
    %   sdd = EmbeddedWebViewSDD(modelName);
    %   fill(sdd);
    %   close(sdd);
    %   close_system(modelName);
    %   rptview(sdd.OutputPath);
    
    % Copyright 2016 The MathWorks
    
    
    methods
        
        function sdd = EmbeddedWebViewSDD( modelName )
            % EMBEDDEDWEBVIEWSDD Constructs a WebView-based SDD
            %   sdd = EmbeddedWebViewSDD('MODELNAME') constructs a 
            %   Web View-based system design description of the model
            %   named MODELNAME, for example, f14.
            sdd@slreportgen.webview.EmbeddedWebViewDocument([modelName 'sdd'], modelName);
        end
        
        
    end
    
    methods (Hidden)
        
        function fillContent(sdd)
            % This method fills a hole named Content in the default
            % Embedded Web View template. The Content hole is located in
            % the template's center pane. This method is invoked by
            % the EmbeddedWebViewSDD's fill method,which it inherits from
            % EmbeddedWebViewDocument. This method uses standard DOM
            % API objects to fill the Content hole. See the MATLAB
            % Report Generator documentation for information on the
            % DOM API or invoke
            %
            % >> help mlreportgen.dom
            %
            % at the MATLAB command line.
            
            %% This line allows use of unqualified DOM object class names
            % in this method.
            import mlreportgen.dom.* % This line
            
            %% Generate the SDD title            
            % Get the name of the model being described. 
            modelName = sdd.ExportOptions.Diagrams;
            % Create a Heading1 object containing the title. We use the
            % Heading1 objects to take advantage of the fact that the
            % template's automatic TOC generator generates the TOC from
            % Heading objects in the Content hole.
            h1 = Heading1(sprintf('%s System Design Description', ...
                modelName));
            h1.Style = {Color('white'), BackgroundColor('#16768E'), ...
                FontFamily('Arial')};
            append(sdd, h1);
            
            %% Generate a description for each system and chart in
            % the model.
            
            % getExportDiagrams has two output arguments. The first is by
            % default a cell array paths of subsystem and chart blocks in
            % the model. The second is a cell array of objects that
            % reference diagrams in the model. We use only the second
            % output. By default the getExportDiagrams methods returns all
            % diagrams in or referenced by the model. You can use the
            % EmbeddedWebViewSDD's ExportOptions property, inherited from
            % EmbeddedWebViewDocument class to filter the systems and
            % charts exported from the model to this report.
            [~, diagramReferences] = getExportDiagrams(sdd);
            
            % Loop through the diagram objects, creating a section of 
            % the SDD for each subsystem and chart in the model.
            for ref = diagramReferences'
                diagRef = ref{1};
                switch class(diagRef)
                    case 'double'
                        genSystemDescription(sdd, diagRef)
                    case 'Stateflow.Chart'
                        genChartDescription(sdd, diagRef)
                    case 'Statefow.State'
                        % handle states
                    otherwise
                        % handle other Stateflow types
                end
                
            end
        end
        
        function fillTOC(h)
            %% This method fills a hole named TOC in the template used
            % to generate this report, which it inherits from 
            % EmbeddedWebViewDocument class. The hole is located in
            % the left (i.e., TOC) pane of the EmbeddedWebViewSDD
            % report.
            
            %% Append a DOM TOC object to the hole. The DOM TOC object
            % generates a TOC based on the section headings (DOM objects of
            % type Heading1, Heading2, etc., in the SDD Content pane.
            append(h, mlreportgen.dom.TOC());
        end
    end
        
    methods (Access=private)

        
        function genSystemDescription(sdd, diagHandle)
            %% This method generates a section for each subsystem specified
            % by diagHandle. The section title is the name of the
            % subsystem. It has a two-way link to the subsystem's diagram
            % in the embedded Web View. Subsections for each block in the
            % subsystem follow the section title. Each block subsection
            % consists of the block's name as title followed by a table of
            % the block's properties. The block title is two-way linked to
            % the block in the embedded Web View.
            
            import mlreportgen.dom.*
            
            %% Create a section heading with a two-way link to the 
            % embedded Web View.
            
            % Create a section heading containing the subsystem's name and
            % a link to the subsystem's diagram in the embedded Web View.
            diagLink = createDiagramLink(sdd, diagHandle, ...
                get_param(diagHandle, 'Name'));
            h2 = Heading2(diagLink);
                    
            % Create an anchor in the section head for a hyperlink from
            % the subsystem block in the embedded Web View to this
            % section.
            diagAnchor = createDiagramAnchor(sdd, ...
                diagHandle, h2);
            
            % Draw a rule under the heading
            border = Border;
            border.BottomStyle = 'solid';
            border.BottomColor = 'LightGray';
            h2.Style = {border};
            
            % Append two-way-linked heading to the SDD
            append(sdd, diagAnchor);
            
            %% Create a subsection for each block in the subsystem.
            blockPaths = find_system(diagHandle, 'SearchDepth', 1, ...
                'type', 'block');
            for path = blockPaths'
                
                %% Create a two-way-linked block section heading
                blockHandle = get_param(path, 'Handle');
                % Create block link heading (doc -> webview)
                blockLink = createElementLink(sdd, blockHandle, ...
                    get_param(blockHandle, 'Name'));
                h3 = Heading3(blockLink);
                % Create block anchor in heading
                blockAnchor = createElementAnchor(sdd, ...
                    blockHandle, h3);
                % Append two-way-linked heading to document
                append(sdd, blockAnchor);
                
                %% Create a parameter table for the current block.
                % The parameter table has two columns. The first column
                % lists the block's parameter names. The second column
                % the corresponding parameter values.
                blockParams = {};
                params = get_param(blockHandle, 'DialogParameters');
                paramNames = fields(params);
                if ~isempty(paramNames)
                    for name = paramNames'
                        paramName = name{1};
                        paramValue = get_param(blockHandle, paramName);
                        blockParams = [blockParams; {paramName, paramValue}]; %#ok<AGROW>
                    end
                    
                    table = FormalTable({'Parameter', 'Value'}, blockParams);
                    table.Border = 'solid';
                    table.BorderWidth = '1pt';
                    table.Header.TableEntriesStyle = {HAlign('left'), ...
                        OuterMargin('0pt', '0pt', '0pt', '0pt')};
                    table.Body.TableEntriesStyle = {HAlign('left'), ...
                        OuterMargin('0pt', '0pt', '0pt', '0pt')};
                    append(sdd, table);
                end
                
            end
        end
        
        function genChartDescription(sdd, chartObject)
            %% This method generates a section in the SDD report for
            % a Stateflow chart. The section consists of a heading
            % containing the chart's name and a two-way link to the
            % chart diagram in the embedded Web View.
            import mlreportgen.dom.*
            
            % Create the two-way-linked heading
            chartLink = createDiagramLink(sdd, chartObject, ...
                chartObject.Name);
            h2 = Heading2(chartLink);                
            chartAnchor = createDiagramAnchor(sdd, ...
                chartObject, h2);
            
            % Draw a rule under section heading
            border = Border;
            border.BottomStyle = 'solid';
            border.BottomColor = 'LightGray';
            h2.Style = {border};
            
            % Append anchored linked heading to document
            append(sdd, chartAnchor);
        end
        
    end
    
end

    

