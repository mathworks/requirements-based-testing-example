function XLSadaptor(testCase, inputFileName)  
% XLSadaptor reads a test case spreadsheet into the Test Mgr

    testPath = makeMATdir( inputFileName );

    % find test case groups
    
    [~,tcNames] = xlsfinfo(inputFileName);
    if isempty(tcNames)
        return;
    end
    tcMax = numel(tcNames);
    
    % get model and harness info
    
    modelName = testCase.getProperty('Model');    
    harnessName = testCase.getProperty('HarnessName');  
    [~, dtTbl, mdlSampleTime] = setupModel(modelName,harnessName);

    % clear existing test case
    
    clearTestCase(testCase);
    
    for tcNum = 1:tcMax

        % get raw dat from worksheet
        
        [rawT] = getWorksheet(inputFileName,tcNames{tcNum});
        
        % create mat file and add to test iteration
        
        addIterationStd(testCase, testPath,  ...
            ['case_' num2str(tcNum,'%02d') '_' tcNames{tcNum}], ...
            rawT, dtTbl, mdlSampleTime);

    end

end


%--------------------------------------------------------------------------
function [ pathMAT ] = makeMATdir( srcFileName )
% creates directory to save mat files during test case creation 

    [path, nameMAT, ~] = fileparts(srcFileName);
    if isempty(path)
        inputFileName = which(inputFileName);
        [path, ~, ~] = fileparts(inputFileName);
    end

    if isempty(path)
       ME = MException('GenericAdaptor:noPathFoundForInputDataFile', ...
            'Path not found for input data file "%s"..', ...
            srcFileName);
       throw(ME)

    end
    pathMAT = [path '\' nameMAT];
    if exist(pathMAT,'dir')
        rmdir(pathMAT, 's')
    end
    mkdir(pathMAT);

end


%--------------------------------------------------------------------------
function [rawT] = getWorksheet(fileName,sheetName)

    % read spreadsheet sheet data into cell array
    [~, ~, rawT] = xlsread(fileName,sheetName);
    % make any NaN into blanks
    rawT(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),rawT)) = {''};
    
    %   result will have text read as chars, numeric read as doubles
end


%--------------------------------------------------------------------------
function [modelName, dtTbl, mdlSampleTime] = setupModel(modelName,harnessName)

    %bdclose('all');
    open_system(modelName);
    if ~isempty(harnessName)
        harnessInfo = sltest.harness.find(modelName,'OpenOnly','on');
        if ~isempty(harnessInfo)
            sltest.harness.close(modelName);
        end
        harnessInfo = sltest.harness.find(modelName,'Name',harnessName);
        if isempty(harnessInfo)
            return;
        end
        sltest.harness.open(harnessInfo.ownerFullPath,harnessName);
        topModelName = harnessName;
    else
        topModelName = modelName;
    end
    
    % get model sample time
    mdlSampleTime = str2double(get_param(topModelName,'FixedStep'));
    
    % create a port data type table
    inPorts =  find_system(topModelName,'SearchDepth',1,'BlockType','Inport');
    outPorts =  find_system(topModelName,'SearchDepth',1,'BlockType','Outport');
    ports = [inPorts; outPorts];
 
    dataType = get_param(ports,'OutDataTypeStr');
    portDim = get_param(ports,'PortDimensions');
    signalType = get_param(ports,'SignalType');
    
    % set streaming if not already logging
    setStreaming(inPorts,outPorts);
    
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
        eval([topModelName '([],[],[],''compile'');']);
        if ~strcmp(get_param(topModelName,'SimulationStatus'),'paused')
            disp('Error: Model compile failed');
            return;
        end
        
        dataType = get_param(ports,'CompiledPortDataTypes');
        portDim = get_param(ports,'CompiledPortDimensions');
        signalType = get_param(ports,'CompiledPortComplexSignals');
        
        eval([topModelName '(''term'');']);
        
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
                    set_param(topModelName,'HiliteAncestors','none');
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

        % restore view to top model
        open_system(topModelName);
          
    end

    dtTbl = table(ports, dataType, portDim, signalType, ...
        'RowNames', rowNames,...
        'VariableNames',{'blockPath' 'dataType' 'portDim','signalType'});
    
end


%--------------------------------------------------------------------------
function clearTestCase(testCase)

    % delete all parameter sets, inputs, baselines and iterations
    param2remove = testCase.getParameterSets;
    for k=1:numel(param2remove)
        param2remove(k).remove;
    end
    inputs2Remove = testCase.getInputs;
    for k=1:numel(inputs2Remove)
        inputs2Remove(k).remove;
    end
    baseline2remove = testCase.getBaselineCriteria;
    for k=1:numel(baseline2remove)
        baseline2remove(k).remove;
    end
    iter2remove = testCase.getIterations;
    if ~isempty(iter2remove)
        testCase.deleteIterations(iter2remove);
    end
    
    testCase.setProperty('FastRestart',true);

    if ~isempty(find(strcmp(version('-release'),{'2016b' '2017a'}),1))
        testCase.setProperty('SaveBaselineRunInTestResult',true, ...
            'SaveInputRunInTestResult',true);
    end

end


%--------------------------------------------------------------------------
function [time] = makeTimeUniform(time, sampleTime)
% creates uniform time pool to align with simulation clock

    ts = timeseries;
    ts.Time = 0:sampleTime:(time(end) + sampleTime/2);
    ts = ts.setuniformtime('Interval', sampleTime);
    time = ts.Time;

end


%--------------------------------------------------------------------------
function [testCase, iteration] = addIterationStd(testCase, testPath, ...
    iterName, rawT, dtTbl, mdlSampleTime)

    % read, process and import each sheet

    row1 = rawT(1,:);
    row2 = rawT(2,:);
    lastCol = length(row2);

    % extract table without header
    dataT = rawT(3:end,:);

    % find column groups

    timeCol     = 1;
    inputCol    = findColumnGroups(row1,'Inputs',lastCol);
    outputCol   = findColumnGroups(row1,'Outputs',lastCol);
    calCol      = findColumnGroups(row1,'Calibrations',lastCol);

    % extract time and resample
    
    timeValues = cell2mat(dataT(:,timeCol));
    timeValues = makeTimeUniform(timeValues, mdlSampleTime);
  
    iteration = sltest.testmanager.TestIteration();
    iteration.Name = iterName;

    if ~isempty(calCol)

        % extract cal table & cal names
        calValues = dataT(1,calCol);
        calNames = row2(calCol);
        calNames = regexprep(calNames,'<|>','');

        % -- overrides from individual parameter values

        % create parameter sets for non-empty entries
        calValCol = find(cellfun(@(x) ~isempty(x),calValues(1,:)));
        if ~isempty(calValCol)

            calSetName = [iterName '_CALS.mat'];
            createCalFile(fullfile(testPath,calSetName),...
                calNames(calValCol),calValues(calValCol));

            testCase.addParameterSet('FilePath',fullfile(testPath,calSetName),'SimulationIndex',1);
            iteration.setTestParam('ParameterSet',calSetName);

        else

            parSets = testCase.getParameterSets;
            if isempty(parSets) || isempty(find(strcmp({parSets.Name},'noneSet'),1))
                testCase.addParameterSet('Name','noneSet','SimulationIndex',1);
            end
            iteration.setTestParam('ParameterSet','noneSet');

        end

    end

    if ~isempty(inputCol)

        % extract input table & input signal names
        inputT = dataT(:,inputCol);
        inputNames = row2(inputCol);
        inputNames = regexprep(inputNames,'<|>','');

        % import input signal values
        testData = Simulink.SimulationData.Dataset;

        %   -- input times
        timeInput = timeValues;

        % check that time interval matches model sample time
        inputSampleTime = timeInput(2) - timeInput(1);
        if inputSampleTime ~= mdlSampleTime
            disp('Warning:  Possible time misalignment for inputs');
        end

        %   -- input values
        inputValues = inputT;

        %  for each signal fill in blanks and add to testcase
        for k=1:size(inputValues,2)

            % check and fill in blank values
            sigValues = fillInBlanks(inputValues(:,k),0,char(dtTbl{inputNames{k},'portDim'}));
            sigValues = cell2mat(sigValues);

            %   -- create timeseries signals
            testData = addTimeSeries(testData,inputNames{k},sigValues, ...
                inputSampleTime,dtTbl,timeInput,1);

        end

        %   -- save to input mat file
        inputMatFileName = [iterName '_INPUTS.mat'];
        save(fullfile(testPath,inputMatFileName),'testData');

        %   -- map in testMgr
        testInput = testCase.addInput( ...
            fullfile(testPath,inputMatFileName), 1, false);

        % Mapping Mode
        % 0 — Block name
        % 1 — Block path
        % 2 — Signal name
        % 3 — Port order (index)
        % 4 — Custom
        testInput.map(0);  % Block name
        iteration.setTestParam('ExternalInput',inputMatFileName);

    end

    if ~isempty(outputCol)

        % extract output table & output signal names
        outputT = dataT(:,outputCol);
        outputRow = row2(outputCol);
        outputSignalCol = find(cellfun(@(x) ~strcmpi(x,'tolerance'),outputRow));
        outputNames = outputRow(outputSignalCol);
        outputNames = regexprep(outputNames,'<|>','');
        outputTolCol = find(cellfun(@(x) strcmpi(x,'tolerance'),outputRow));
        
        if numel(outputNames) ~= numel(outputTolCol)
            
            % pad with blank tolerances if necessary

            emptyTolVals = cell(size(outputT,1),1);
            emptyTolVals(1:end) = {''};
            
            for i=1:length(outputSignalCol)
                k = 2 * (i-1);
                if isempty(outputTolCol) || ~ismember(outputSignalCol(i)+1,outputTolCol)
                    if i<length(outputSignalCol)
                        outputT = [outputT(:,1:k+1) emptyTolVals outputT(:,k+2:end)];
                    else
                        outputT = [outputT(:,1:k+1) emptyTolVals];
                    end 
                end
            end
            
            % reset output column (should now be padded)
            outputSignalCol = [1:2:size(outputT,2)];
            outputTolCol = [2:2:size(outputT,2)];
            
        end

        % import output signal values
        testData = Simulink.SimulationData.Dataset;

        %   -- output times
        timeOutput = timeValues;

        % check that time interval matches model sample time
        outputSampleTime = timeOutput(2) - timeOutput(1);
        if outputSampleTime ~= mdlSampleTime
            disp('Warning:  Possible time misalignment for outputs');
        end

        %   -- expected outputs
        outputValues = outputT;
        
        %  add output to testcase
        for k=outputSignalCol
            
            % check and fill in blank values
            sigValues = fillInBlanks(outputValues(:,k),0, ...
                char(dtTbl{outputNames{(k-1)/2 + 1},'portDim'}));
            sigValues = cell2mat(sigValues);

            %   -- create timeseries signals
            testData = addTimeSeries(testData,outputNames{(k-1)/2 + 1}, ...
                sigValues,outputSampleTime,dtTbl,timeOutput,1);
            
        end

        %   -- save to an expected output mat file
        outputMatFileName = [iterName '_BASELINE.mat'];
        save(fullfile(testPath,outputMatFileName),'testData');

        testBaseline = testCase.addBaselineCriteria(...
            fullfile(testPath,outputMatFileName),true);

        % set absolute tolerances
        %tolValues = regexprep(outputT(tcRows(i),outputTolCol),'','0');
        tolValues = outputT(1,outputTolCol);
        tolValues(cellfun(@(x) isempty(x),tolValues)) = {0};
        sigCriteria = getSignalCriteria(testBaseline);
        for k=1:numel(sigCriteria)
            sigCriteria(k).AbsTol = tolValues{k};
        end

        iteration.setTestParam('Baseline',outputMatFileName);

    end

    iteration = testCase.addIteration(iteration, iterName);
    iteration.update();

 end

%--------------------------------------------------------------------------
function testData = addTimeSeries(testData,sigName,sigValues, ...
    sigSampleTime,dtTbl,times,uniformTime)

    
    %   -- create timeseries signals
    dataType = char(dtTbl{sigName,'dataType'});
    [values, error] = castData(dataType,sigValues);

    if (error)
        disp(['Error:  Unable to resolve data type "' ...
            dataType ' for "' sigName '"']);
    end

    element = timeseries(values, times);

    % set uniform time for time alignment
    if uniformTime
        element = setuniformtime(element,'Interval',sigSampleTime);
    end

    % set plot characteristic and port interpolation
    if islogical(values) || isinteger(values) || isenum(values)
        element = element.setinterpmethod('zoh');
        blockPath = char(dtTbl{sigName,'blockPath'});
        if strcmp(get_param(blockPath,'BlockType'),'Inport')
            set_param(blockPath,'Interpolate','off');
        end
    end

    testData = testData.addElement(element,sigName);

end


%--------------------------------------------------------------------------
function [fillMode] = getFillMode(dataType)

    % check for built-in data types
    
    intBuiltInTypes = {'single','double','int8','uint8','int16','uint16',...
                    'int32','uint32','int64','uint64','boolean'};
    if ~isempty(find(strcmp(dataType,intBuiltInTypes), 1))
        fillMode = 'previous';
        return;
    end
    
    floatBuiltInTypes = {'single','double'};
    if ~isempty(find(strcmp(dataType,floatBuiltInTypes), 1))
        fillMode = 'linear';
        return;
    end
   
    % check for enumeration
    if ~isempty(enumeration(dataType))
        fillMode = 'previous';
        return;
    end

    % check for additional user defined data types
    isDefinedDataType = evalin('base',['exist(''' dataType ''',''var'')']);
    if isDefinedDataType

        % check for alias type
        if isa(evalin('base',dataType),'Simulink.AliasType')

            dataType = evalin('base', [dataType '.BaseType']);
            [fillMode] = getFillMode(dataType);
            return;

        end

        % check for numeric type
        if isa(evalin('base',dataType),'Simulink.NumericType')

            dataTypeMode = evalin('base',[dataType '.DataTypeMode']);

            switch dataTypeMode

                case 'Fixed-point: binary point scaling'
                    fillMode = 'linear';
                    return;

                case  {'Double','Single'}
                    fillMode = 'linear';
                    return;
                    
                case 'Boolean'
                    fillMode = 'previous';
                    return;
                    
            end

        end

    end

    fillMode = 'linear';
    
end


%--------------------------------------------------------------------------
function [values, error] = castData(dataType, values)

    error = false;

    % check for built-in data type
    builtInTypes = {'single','double','int8','uint8','int16','uint16',...
                    'int32','uint32','int64','uint64','boolean'};
    if ~isempty(find(strcmp(dataType,builtInTypes), 1))
        values = eval([dataType '(values)']);
        return;
    end

    % check for enumeration
    if ~isempty(enumeration(dataType))
        values = eval([dataType '(values)']);
        return;
    end

    % check for additional user defined data types
    isDefinedDataType = evalin('base',['exist(''' dataType ''',''var'')']);
    if isDefinedDataType

        % check for alias type
        if isa(evalin('base',dataType),'Simulink.AliasType')

            dataType = evalin('base', [dataType '.BaseType']);
            values = eval([dataType '(values)']);
            return;

        end

        % check for numeric type
        if isa(evalin('base',dataType),'Simulink.NumericType')

            dataTypeMode = evalin('base',[dataType '.DataTypeMode']);

            switch dataTypeMode

                case 'Fixed-point: binary point scaling'

                    values = eval(['fi(values,' dataType ')']);
                    return;

                case  {'Double','Single','Boolean'}

                    values = eval([lower(dataTypeMode) '(values)']);
                    return;

            end

        end

    end

    error = true;

end


%--------------------------------------------------------------------------
function colMatch = findColumnGroups(headerRow,strPatt,lastCol)

    % find column groups
    colMatch = find(cellfun(@(x) strcmpi(x,strPatt),headerRow),1);
    if ~isempty(colMatch) && colMatch~=lastCol

        newCol = find(cellfun(@(x) ~strcmpi(x,strPatt) && ~isempty(x), ...
            headerRow(colMatch:end)),1);
        if ~isempty(newCol)
            colMatch = colMatch : colMatch - 2 + newCol;
        else
            colMatch = colMatch : lastCol;
        end

    end

end


%--------------------------------------------------------------------------
function filled = fillInBlanks(partial,dfltVal,portDim)

    % initialize the return series to the input series
    filled = partial;
    
    portDim = str2num(portDim);
    
    % check for blank values
    emptyRows = find(cellfun(@(x) isempty(x),partial));

    % fill in the blank values
    for j=1:size(emptyRows)
        if emptyRows(j)==1
            if isscalar(portDim) && portDim == 1 
                filled(emptyRows(j)) = {dfltVal};
            else
                filled(emptyRows(j)) = {dfltVal*ones(portDim)};
            end
        else
            filled(emptyRows(j)) = filled(emptyRows(j)-1) ;
        end
    end

end


%--------------------------------------------------------------------------
function createCalFile(calSetName,calNames,calValues) %#ok<INUSL>

    saveStr = '';

    for i=1:numel(calNames)

        %value = str2num(calValues{i}); %#ok<ST2NM>
        value = calValues{i};

        % get param into function workspace
        calParam = evalin('base',calNames{i});

        % cast cal value for the workspace data type
        
        % check for parameter object
        if isobject(calParam) && ~isenum(calParam)
            
            calDataType = calParam.DataType;
            % check for enum
            enum = regexp(calDataType,'^Enum: (\w+)','tokens');
            if ~isempty(enum)
                [value, ~] = castData(char(enum{1}),value); %#ok<ASGLU>
            else
                [value, ~] = castData(calDataType, value); %#ok<ASGLU>
            end
            eval([calNames{i} ' = calParam;'])
            eval([calNames{i} '.Value = value;']);
            eval([calNames{i} '.DataType = calDataType;']);

        else  % not a parameter object 
            
            calDataType = class(calParam);
            [value, ~] = castData(calDataType, value); %#ok<ASGLU>
            eval([calNames{i} ' = value;']);
            
        end

        saveStr = [saveStr '''' calNames{i} ''',']; %#ok<AGROW>

    end

    eval(['save(calSetName,' saveStr(1:end-1) ');']);

end


%--------------------------------------------------------------------------
function setStreaming(inports,outports)
% set streaming if not already logging

    for i=1:length(inports)
        
        ph = get_param(inports{i},'PortHandles');
        ln = get_param(ph.Outport,'Line');
        if ~get(ln,'DataLogging')
            Simulink.sdi.markSignalForStreaming(ln,'on');
        end
        
    end
        
    for i=1:length(outports)
        
        ph = get_param(outports{i},'PortHandles');
        ln = get_param(ph.Inport,'Line');
        if ~get(ln,'DataLogging')
            Simulink.sdi.markSignalForStreaming(ln,'on');
        end
        
    end
    
end
