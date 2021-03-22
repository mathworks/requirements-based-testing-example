function runTestSuiteWithCoverage(testName,varargin)
runner = matlab.unittest.TestRunner.withTextOutput();
suite = testsuite(testName);
%Add plugin to get results into Test Manager        
runner.addPlugin(sltest.plugins.MATLABTestCaseIntegrationPlugin());

%Stream output to Logs in Test Manager Result Set
streamOutput = sltest.plugins.ToTestManagerLog();
diagnosticsOutputPlugin = matlab.unittest.plugins.DiagnosticsOutputPlugin(streamOutput,'IncludingPassingDiagnostics',true);
runner.addPlugin(diagnosticsOutputPlugin);

%Add plugin to enable Model Coverage on any models passed to the
%"simulate" method in sltest.TestCase
import sltest.plugins.coverage.CoverageMetrics
covMetrics = CoverageMetrics(varargin{:});
runner.addPlugin(sltest.plugins.ModelCoveragePlugin('Collecting',covMetrics));
runner.run(suite);
end