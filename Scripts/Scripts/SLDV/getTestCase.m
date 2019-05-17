function [ testCase ] = getTestCase( testFileName, testSuiteName, ...
    testCaseName )
% getTestCase:  gets the TestCase object based on testFileName, 
%               testSuiteName and testCaseName

    testCase = [];
    
    if exist([testFileName '.mldatx'],'file') ~= 2
        return;
    end
    
    testFile = sltest.testmanager.TestFile(testFileName);
    if isempty(testFile)
        return;
    end
    
    testSuite = testFile.getTestSuiteByName(testSuiteName);
    if isempty(testSuite)
        return;
    end
    
    testCase = testSuite.getTestCaseByName(testCaseName);
        
end

