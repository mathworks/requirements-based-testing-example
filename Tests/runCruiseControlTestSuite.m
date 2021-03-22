% Run CruiseControl_TestSuite using M-Unit Scripting
% Collect MCDC coverage
runTestSuiteWithCoverage('CruiseControl_TestSuite','Decision',false,'Condition',false,'MCDC',true) % Should error
%runTestSuiteWithCoverage('CruiseControl_TestSuite.mldatx','Decision',false,'Condition',false,'MCDC',true) % Should error