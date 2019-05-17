%% Create datasets and parameter arrays and write them to spreadsheets
% create an input dataset
dsInp = Simulink.SimulationData.Dataset;
dsInp = dsInp.addElement(timeseries((1:10)'), 'ts1');

% create output dataset
dsOut = Simulink.SimulationData.Dataset;
dsOut = dsOut.addElement(timeseries((1:10)'), 'ts2');

simIndex = 1; %optional argument
% write those to spreadsheet
% For Inputs:
stm.internal.util.writeDatasetToSheet(dsInp, 'myExcelFileName.xlsx', 'mySheetName',...
    '',xls.internal.SourceTypes.Input, simIndex);

% For Baseline
stm.internal.util.writeDatasetToSheet(dsOut, 'myExcelFileName.xlsx', 'mySheetName',...
    '',xls.internal.SourceTypes.Output, simIndex);

% For Parameters
prm_vr1 =  Simulink.Simulation.Variable('var1', 0.5);
prm_vr2 =  Simulink.Simulation.Variable('var2', 2);
prms = [prm_vr1 prm_vr2];
wt = xls.internal.WriteTable('Parameters', prms, 'File', 'myExcelFileName.xlsx','sheet', 'mySheetName');
wt.write();


% I am just copying over the data to create more sheets. You can use the
% above APIs to create more sheets
sheetNames = ["mySheetName", "mySheetName1", "mySheetName2"];
stm.internal.quickstart.generateExcelScenarios('myExcelFileName.xlsx', sheetNames);


%% create a test case and set it up
tc = sltest.testmanager.TestFile('tf').getTestSuites.getTestCases;
tc.setProperty('Model','mSimpleExcel');

% Now add this file to the testcase
inp = tc.addInput('myExcelFileName.xlsx', 'CreateIterations', false);
bsln  = tc.addBaselineCriteria('myExcelFileName.xlsx');
pSets = tc.addParameterSet('FilePath', 'myExcelFileName.xlsx');

%setup iterations
iterationList(length(sheetNames)) = sltest.testmanager.TestIteration();
for indx = 1:length(iterationList)
    inp(indx).map('Mode',3);
    setTestParam(iterationList(indx), 'ExternalInput', inp(indx).Name);
    setTestParam(iterationList(indx), 'ParameterSet', pSets(indx).Name);
    setTestParam(iterationList(indx), 'Baseline', bsln(indx).Name);
end
tc.addIteration(iterationList, sheetNames);

