function xls2sigEdMat(fileName, modelName)
% import data from spreadsheet to signal editor scenario mat file

    % get test case sheets (names)
    
    [~,tcNames] = xlsfinfo(fileName);
    
    % get model data types
    
    [~, dtTbl, mdlSampleTime] = getModelInfo(modelName);
    
    % use only inports
    
    %dtTbl = dtTbl(dtTbl.inport,:);
    
    for i=1:numel(tcNames)
       
        opts = detectImportOptions(fileName,'Sheet',tcNames{i});
        
        varNames = opts.VariableNames;
        
        % check for time column
        
        timeNdx = ismember(varNames,'Time');
        if isempty(timeNdx)
            ME = MException('xls2sigEdMat:unableToResampleToUniformTime', ...
                'Test "%s":  No "Time" column specified in spreadsheet.', ...
                tcNames{i});
            throw(ME)
        end

        % filter spreadsheet to only import model signals
        
        varNames(~ismember(varNames,dtTbl.Row)) = '';
        
        for j=1:numel(varNames)
        
            % set data type to match model
            
            dataType = char(dtTbl{varNames{j},'dataType'});
            if strcmp(dataType,'boolean')
                dataType = 'logical';
            end
            opts = setvartype(opts,varNames{j},dataType);
            
        end

        opts.SelectedVariableNames = [{'Time'} varNames];
        
        % import the data

        tvTbl = readtable(fileName, opts, "UseExcel", false);
    
        % extract time and resample to sim time
        
        [timeValues] = checkTime(tcNames{i}, tvTbl{:,'Time'}, mdlSampleTime);
        
        % build data set
    
        testData = Simulink.SimulationData.Dataset;
        
        for j=1:numel(varNames)
            
           %   -- create timeseries signals
           
            testData = addTimeSeries(testData, ...
                varNames{j}, tvTbl{:,varNames{j}}, timeValues);
          
        end

        eval([tcNames{i} ' = testData;']);
        
    end    
    
    eval(['save(''tempSigEd.mat'',' '''' char(join(tcNames,''',''')) '''' ')']);

end


%=========================================================================
function [time] = checkTime(tcName, time, sampleTime)       
%check time vector against uniform time vector

    % create uniform time pool (vector)
    
    ts = timeseries;
    ts.Time = 0:sampleTime:(time(end) + sampleTime/2);
    ts = ts.setuniformtime('Interval', sampleTime);
    timePool = ts.Time;

    % resample time from uniform time pool
    
    [found, ndx] = ismembertol(time,timePool,1e-12);
    timeOutputUniform = timePool(ndx(found));

    if numel(timeOutputUniform) ~= numel(time)
        ME = MException('xls2sigEdMat:unableToResampleToUniformTime', ...
            'Test "%s":  Times are not a multiple of the base time step.', tcName);
        throw(ME)
    else
        time = timeOutputUniform';
    end

end


%==========================================================================
function testData = addTimeSeries(testData, name, values, times) %, sampleTime)
    
    %   -- create timeseries signals

    element = timeseries(values, times);

    % set interpolation
    
    if islogical(values) || isinteger(values) || isenum(values)
        element = element.setinterpmethod('zoh');
    end

    testData = testData.addElement(element,name);

end


%==========================================================================
function [modelName, dtTbl, sampleTime] = getModelInfo(modelName)

    % get model sample time
    sampleTime = str2double(get_param(modelName,'FixedStep'));
    
    % create a port data type table
    inPorts =  find_system(modelName,'SearchDepth',1,'BlockType','Inport');
    outPorts =  find_system(modelName,'SearchDepth',1,'BlockType','Outport');
    ports = [inPorts; outPorts];
 
    dataType = get_param(ports,'OutDataTypeStr');
    portDim = get_param(ports,'PortDimensions');
    signalType = get_param(ports,'SignalType');
    
    % check for implicit specification
    explicit = isempty(find(strcmp('Inherit: auto',dataType), 1)) && ...
        isempty(find(strcmp('-1',portDim), 1)) && ...
        isempty(find(strcmp('auto',signalType), 1));
    
    if explicit
    
        rowNames = get_param(ports,'Name');
        for i=1:numel(dataType)
            enumType = regexp(dataType{i},'^Enum: (\w+)','tokens');
            if ~isempty(enumType)
                dataType(i) = enumType{1};
            end
        end
        
    else    % implicit port specification
        
        % create a port data type table
        eval([modelName '([],[],[],''compile'');']);
        if ~strcmp(get_param(modelName,'SimulationStatus'),'paused')
            disp('Error: Model compile failed');
            return;
        end
        
        dataType = get_param(ports,'CompiledPortDataTypes');
        portDim = get_param(ports,'CompiledPortDimensions');
        signalType = get_param(ports,'CompiledPortComplexSignals');
        
        eval([modelName '(''term'');']);
        
        rowNames = cell(length(ports),1);
    
        for i=1:length(ports)

            if i <= length(inPorts)
                dataType{i} = dataType{i}.Outport{1};
                signalType{i} = signalType{i}.Outport;
                portDim{i} = portDim{i}.Outport;

                ph = get_param(ports{i},'PortHandles');
                rowNames{i} = get_param(ph.Outport,'Name');
            else
                dataType{i} = dataType{i}.Inport{1};
                signalType{i} = signalType{i}.Inport;
                portDim{i} = portDim{i}.Inport;

                ph = get_param(ports{i},'PortHandles');
                sigName =  get_param(ph.Inport,'Name');
                if ~isempty(sigName)
                    rowNames{i} = sigName;
                else
                    lh = get_param(ph.Inport(1),'line');
                    hSrcPrts = get_param(lh,'TraceSourceOutputPorts');
                    set_param(modelName,'HiliteAncestors','none');
                    sigName = '';
                    for k=1:length(hSrcPrts)
                        if ~isempty(get_param(hSrcPrts(k),'Name'))
                            sigName =  get_param(hSrcPrts(k),'Name');
                        end
                    end
                    rowNames{i} = sigName;
                    if isempty(sigName)
                        disp(['Error:  Unable to resolve signal name for port "' ...
                            get_param(ports{i},'Name') '"']);
                    end
                end
            end

            if signalType{i}
                signalType{i} = 'complex';
            else
                signalType{i} = 'real';
            end

            if  max(portDim{i}) == 1
                portDim{i} = '1';
            elseif min(portDim{i}) == 1
                portDim{i} = num2str(max(portDim{i}));
            else
                portDim{i} = ['[' num2str(portDim{i}) ']'];
            end

            % check for enumeration
            if ~isempty(enumeration(dataType{i}))
                set_param(ports{i},'OutDataTypeStr',['Enum: ' dataType{i}]);
                if i <= length(inPorts)
                    set_param(ports{i},'Interpolate','off');
                end
            else
                set_param(ports{i},'OutDataTypeStr',dataType{i});
            end
            set_param(ports{i},'PortDimensions', portDim{i});
            set_param(ports{i},'SignalType', signalType{i});

        end

    end
    
    isInport = [(1:length(ports))<=length(inPorts)]';

    dtTbl = table(ports, isInport, dataType, portDim, signalType, ...
        'RowNames', rowNames,...
        'VariableNames',{'blockPath' 'inport' 'dataType' 'portDim','signalType'});
    
end
