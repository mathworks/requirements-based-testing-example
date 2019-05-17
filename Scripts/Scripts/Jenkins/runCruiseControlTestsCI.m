% Executing a test in MATLAB unit test framework

testFileName = 'CruiseControlTestsCI.mldatx';
pdfRptFile = 'CruiseControlTestReport.pdf';
tapFile = 'CruiseControlOutput.tap';

% Open the Simulink® Test™ test file.

testfile = which(testFileName);
sltest.testmanager.view;
sltest.testmanager.load(testfile);

% Create a test suite from the Simulink® Test™ test file.

import matlab.unittest.TestSuite
suite = testsuite(testFileName);

% Create a test runner.

import matlab.unittest.TestRunner
CruiseControlRunner = TestRunner.withNoPlugins;

% Add the TestReportPlugin to the test runner.
%   -- The plugin produces a MATLAB Test Report CruiseControlTestReport.pdf.

import matlab.unittest.plugins.TestReportPlugin

trp = TestReportPlugin.producingPDF(pdfRptFile);
addPlugin(CruiseControlRunner,trp);

% Add the TestManagerResultsPlugin to the test runner.
%   -- Plugin adds Test Manager results to the MATLAB Test Report.

import sltest.plugins.TestManagerResultsPlugin
tmr = TestManagerResultsPlugin; 
addPlugin(CruiseControlRunner,tmr);

% Add the TAPPlugin to the test runner.
%   -- Plugin outputs to the CruiseControlOutput.tap file.

import matlab.unittest.plugins.TAPPlugin
import matlab.unittest.plugins.ToFile

tap = TAPPlugin.producingVersion13(ToFile(tapFile));
addPlugin(CruiseControlRunner,tap);

% Run the test.

result = run(CruiseControlRunner,suite);

% Cleanup

% sltest.testmanager.clearResults
% sltest.testmanager.clear
% sltest.testmanager.close




