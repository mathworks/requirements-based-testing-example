function sl_customization(cm)
% SL_CUSTOMIZATION - Model Advisor customization demonstration.

% Copyright 2005 The MathWorks, Inc.

% register custom checks 
cm.addModelAdvisorCheckFcn(@defineModelAdvisorChecks);
% register custom factory group 
%cm.addModelAdvisorTaskFcn(@defineModelAdvisorTasks);
% register custom tasks.
%cm.addModelAdvisorTaskAdvisorFcn(@defineTaskAdvisor);
% register custom process callback
%cm.addModelAdvisorProcessFcn(@ModelAdvisorProcessFunction);

% -----------------------------
% defines Model Advisor Checks
% -----------------------------
function defineModelAdvisorChecks
mdladvRoot = ModelAdvisor.Root;

% --- sample check 1
rec = ModelAdvisor.Check('FontCheck');
rec.Title = 'Check Simulink block font';
rec.TitleTips = 'Example style three callback';
rec.setCallbackFcn(@SampleStyleThreeCallback,'None','StyleThree');
rec.setInputParametersLayoutGrid([3 2]);
% set input parameters
inputParam1 = ModelAdvisor.InputParameter;
inputParam1.Name = 'Skip font checks.';
inputParam1.Type = 'Bool';
inputParam1.Value = false;
inputParam1.Description = 'sample tooltip';
inputParam1.setRowSpan([1 1]);
inputParam1.setColSpan([1 1]);
inputParam2 = ModelAdvisor.InputParameter;
inputParam2.Name = 'Standard font size';
inputParam2.Value='16';
inputParam2.Type='String';
inputParam2.Description='sample tooltip';
inputParam2.setRowSpan([2 2]);
inputParam2.setColSpan([1 1]);
inputParam3 = ModelAdvisor.InputParameter;
inputParam3.Name='Valid font';
inputParam3.Type='Combobox';
inputParam3.Description='sample tooltip';
inputParam3.Entries={'Tahoma', 'Arial Black'};
inputParam3.setRowSpan([2 2]);
inputParam3.setColSpan([2 2]);
rec.setInputParameters({inputParam1,inputParam2,inputParam3});
% set fix operation
myAction = ModelAdvisor.Action;
myAction.setCallbackFcn(@sampleActionCB);
myAction.Name='Fix block fonts';
myAction.Description='Click the button to update all blocks with specified font';
rec.setAction(myAction);
rec.ListViewVisible = true;
mdladvRoot.publish(rec, 'Custom Workshop Checks'); % publish check into Demo group.

% --- sample check 2
rec = ModelAdvisor.Check('WindowColor');
rec.Title = 'Check Simulink window screen color';
rec.TitleTips = 'Example style one callback';
rec.setCallbackFcn(@SampleStyleOneCallback,'None','StyleOne');
% set fix operation
myAction2 = ModelAdvisor.Action;
myAction2.setCallbackFcn(@sampleActionCB2);
myAction2.Name='Fix window screen color';
myAction2.Description='Click the button to change Simulink window screen color to white';
rec.setAction(myAction2);
mdladvRoot.publish(rec, 'Custom Workshop Checks'); % publish check into Demo group.

% --- sample check 3
rec = ModelAdvisor.Check('OptSettings');
rec.Title = 'Check model optimization settings';
rec.TitleTips = 'Example style two callback';
rec.setCallbackFcn(@SampleStyleTwoCallback,'None','StyleTwo');
% set fix operation
myAction3 = ModelAdvisor.Action;
myAction3.setCallbackFcn(@sampleActionCB3);
myAction3.Name='Fix model optimization settings';
myAction3.Description='Click the button to turn on model optimization settings';
rec.setAction(myAction3);
mdladvRoot.publish(rec, 'Custom Workshop Checks'); % publish check into Demo group.

% -----------------------------
% defines Model Advisor process callback
% please refer to Model Advisor API document for more details.
% -----------------------------
function [checkCellArray taskCellArray] = ModelAdvisorProcessFunction(stage, system, checkCellArray, taskCellArray)
switch stage
    case 'configure'
        for i=1:length(checkCellArray)
            % hidden all checks that do not belong to Demo group
            if ~(strcmp(checkCellArray{i}.Group, 'Demo'))
                checkCellArray{i}.Visible = false;
                checkCellArray{i}.Value = false;
            end
        end
    case 'process_results'
        for i=1:length(checkCellArray)
            % print message if check does not pass
            if checkCellArray{i}.Selected && (strcmp(checkCellArray{i}.Title, 'Check Simulink window screen color'))
                if isempty(strfind(checkCellArray{i}.Result, 'Passed'))
                    disp('Example message from Model Advisor Process callback.');                    
                end
            end
        end        
end

% -----------------------------
% Sample StyleThree callback function,
% please refer to Model Advisor API document for more details.
% -----------------------------
function [ResultDescription, ResultDetails] = SampleStyleThreeCallback(system)
ResultDescription ={};
ResultDetails ={};

mdladvObj = Simulink.ModelAdvisor.getModelAdvisor(system);
mdladvObj.setCheckResultStatus(true); 
needEnableAction = false;
% get input parameters
inputParams = mdladvObj.getInputParameters;
skipFontCheck = inputParams{1}.Value;
regularFontSize = inputParams{2}.Value;
regularFontName = inputParams{3}.Value;
if skipFontCheck
    ResultDescription{end+1} = ModelAdvisor.Paragraph('Skipped.');
    ResultDetails{end+1}     = {};        
    return
end
regularFontSize = str2double(regularFontSize);
if regularFontSize<1 || regularFontSize>=99
    mdladvObj.setCheckResultStatus(false); 
    ResultDescription{end+1} = ModelAdvisor.Paragraph('Invalid font size. Please enter a value between 1 and 99');
    ResultDetails{end+1}     = {};            
end

% find all blocks inside current system
allBlks = find_system(system);

% block diagram doesn't have font property
% get blocks inside current system that have font property
allBlks = setdiff(allBlks, {system});

% find regular font name blocks 
regularBlks = find_system(allBlks,'FontName',regularFontName);

% look for different font blocks in the system
searchResult = setdiff(allBlks, regularBlks);
if ~isempty(searchResult)
    ResultDescription{end+1} = ModelAdvisor.Paragraph(['It is recommended to use same font for blocks to ensure uniform appearance of model. '...
        'The following blocks use a font other than ' regularFontName ': ']);
    ResultDetails{end+1}     = searchResult;
    mdladvObj.setCheckResultStatus(false);         
    myLVParam = ModelAdvisor.ListViewParameter;    
    myLVParam.Name = 'Invalid font blocks'; % the name appeared at pull down filter
    myLVParam.Data = get_param(searchResult,'object')';
    myLVParam.Attributes = {'FontName'}; % name is default property
    mdladvObj.setListViewParameters({myLVParam});    
    needEnableAction = true;
else
    ResultDescription{end+1} = ModelAdvisor.Paragraph('All block font names are identical.');
    ResultDetails{end+1}     = {};    
end

% find regular font size blocks 
regularBlks = find_system(allBlks,'FontSize',regularFontSize);
% look for different font size blocks in the system
searchResult = setdiff(allBlks, regularBlks);
if ~isempty(searchResult)
    ResultDescription{end+1} = ModelAdvisor.Paragraph(['It is recommended to use same font size for blocks to ensure uniform appearance of model. '...
        'The following blocks use a font size other than ' num2str(regularFontSize) ': ']);
    ResultDetails{end+1}     = searchResult;
    mdladvObj.setCheckResultStatus(false); 
    myLVParam = ModelAdvisor.ListViewParameter;    
    myLVParam.Name = 'Invalid font size blocks'; % the name appeared at pull down filter
    myLVParam.Data = get_param(searchResult,'object')';
    myLVParam.Attributes = {'FontSize'}; % name is default property    
    mdladvObj.setListViewParameters({mdladvObj.getListViewParameters{:}, myLVParam});    
    needEnableAction = true;
else
    ResultDescription{end+1} = ModelAdvisor.Paragraph('All block font sizes are identical.');
    ResultDetails{end+1}     = {};    
end

mdladvObj.setActionEnable(needEnableAction);
mdladvObj.setCheckErrorSeverity(1);

% -----------------------------
% Sample StyleOne callback function, 
% please refer to Model Advisor API document for more details.
% -----------------------------
function result = SampleStyleOneCallback(system)
mdladvObj = Simulink.ModelAdvisor.getModelAdvisor(system); % get object

if strcmp(get_param(bdroot(system),'ScreenColor'),'white')
    result = ModelAdvisor.Text('Passed',{'pass'});
    mdladvObj.setCheckResultStatus(true); % set to pass
    mdladvObj.setActionEnable(false);
else
    result = ModelAdvisor.Text('It is recommended to select a Simulink window screen color of white to ensure a readable and printable model. ');
    mdladvObj.setCheckResultStatus(false); % set to fail
    mdladvObj.setActionEnable(true);
end

% -----------------------------
% Sample StyleTwo callback function,
% please refer to Model Advisor API document for more details.
% -----------------------------
function [ResultDescription, ResultDetails] = SampleStyleTwoCallback(system)
ResultDescription ={};
ResultDetails ={};

model = bdroot(system);
mdladvObj = Simulink.ModelAdvisor.getModelAdvisor(system); % get object
mdladvObj.setCheckResultStatus(true);  % init result status to pass

% Check Simulation optimization setting
ResultDescription{end+1} = ModelAdvisor.Paragraph('Check Simulation optimization settings:');
if strcmp(get_param(model,'BlockReduction'),'off');
    ResultDetails{end+1}     = {ModelAdvisor.Text('It is recommended to turn on Block reduction optimization option.',{'italic'})};
    mdladvObj.setCheckResultStatus(false); % set to fail
    mdladvObj.setActionEnable(true);
else
    ResultDetails{end+1}     = {ModelAdvisor.Text('Passed',{'pass'})};
end

% Check code generation optimization setting
ResultDescription{end+1} = ModelAdvisor.Paragraph('Check code generation optimization settings:');
ResultDetails{end+1}  = {};
if strcmp(get_param(model,'LocalBlockOutputs'),'off');
    ResultDetails{end}{end+1}     = ModelAdvisor.Text('It is recommended to turn on Enable local block outputs option.',{'italic'});
    ResultDetails{end}{end+1}     = ModelAdvisor.LineBreak;
    mdladvObj.setCheckResultStatus(false); % set to fail
    mdladvObj.setActionEnable(true);
end
if strcmp(get_param(model,'BufferReuse'),'off');
    ResultDetails{end}{end+1}     = ModelAdvisor.Text('It is recommended to turn on Reuse block outputs option.',{'italic'});
    mdladvObj.setCheckResultStatus(false); % set to fail
    mdladvObj.setActionEnable(true);
end
if isempty(ResultDetails{end})
    ResultDetails{end}{end+1}     = ModelAdvisor.Text('Passed',{'pass'});
end

% -----------------------------
% Sample action callback function,
% please refer to Model Advisor API document for more details.
% -----------------------------
function result = sampleActionCB(taskobj)
mdladvObj = taskobj.MAObj;
system = getfullname(mdladvObj.System);

% get input parameters
inputParams = mdladvObj.getInputParameters;
regularFontSize = inputParams{2}.Value;
regularFontName = inputParams{3}.Value;

% find all blocks inside current system
allBlks = find_system(system);
% block diagram itself doesn't have font property
% get blocks inside current system that have font property
allBlks = setdiff(allBlks, {system});

% find regular font name blocks 
regularBlks = find_system(allBlks,'FontName',regularFontName);
% look for different font blocks in the system
fixBlks = setdiff(allBlks, regularBlks);
% fix them one by one
for i=1:length(fixBlks)
    set_param(fixBlks{i},'FontName',regularFontName);
end
% save result
resultText1 = ModelAdvisor.Text([num2str(length(fixBlks)), ' blocks has been updated with specified font ', regularFontName]);

% find regular font size blocks 
regularBlks = find_system(allBlks,'FontSize',str2double(regularFontSize));
% look for different font size blocks in the system
fixBlks = setdiff(allBlks, regularBlks);
% fix them one by one
for i=1:length(fixBlks)
    set_param(fixBlks{i},'FontSize',regularFontSize);
end
% save result
resultText2 = ModelAdvisor.Text([num2str(length(fixBlks)), ' blocks has been updated with specified font size ', regularFontSize]);
result = ModelAdvisor.Paragraph;
result.addItem([resultText1 ModelAdvisor.LineBreak resultText2]);
mdladvObj.setActionEnable(false);

% -----------------------------
% Sample action callback function for Check Simulink window screen color
% please refer to Model Advisor API document for more details.
% -----------------------------
function result = sampleActionCB2(taskobj)
mdladvObj = taskobj.MAObj;
system = mdladvObj.System;
set_param(bdroot(system),'ScreenColor','white');
result = ModelAdvisor.Text('Simulink window screen color has been updated to white color.');
mdladvObj.setActionEnable(false);

% -----------------------------
% Sample action callback function for model optimization settings
% please refer to Model Advisor API document for more details.
% -----------------------------
function result = sampleActionCB3(taskobj)
mdladvObj = taskobj.MAObj;
model = bdroot(mdladvObj.System);
set_param(model,'BlockReduction','on');
set_param(model,'LocalBlockOutputs','on');
set_param(model,'BufferReuse','on');
result = ModelAdvisor.Text('Model optimization options "Block reduction", "Enable local block outputs", and "Reuse block outputs" have been turned on');
mdladvObj.setActionEnable(false);
