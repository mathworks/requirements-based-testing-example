testFileLoc = fullfile(pwd,'CruiseControl_TestSuiteTEST.mldatx');
testFile = sltest.testmanager.TestFile(testFileLoc);
testSuite = getTestSuiteByName(testFile,'CruiseControl_TestSuite');
testCases = getTestCases(testSuite);
numTestCases = numel(testCases);
for i=1:numTestCases
    convertTestType(testCases(i),sltest.testmanager.TestCaseTypes.Simulation);
end