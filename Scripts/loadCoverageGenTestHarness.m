%% ========================================================================
%       Requirements Based Functional Testing with Coverage
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test

if exist('CruiseControl_Coverage_harness.slx','file')
    delete(which('CruiseControl_Coverage_harness.slx'));
end
if exist('CruiseControl_Coverage.slx','file')
    delete(which('CruiseControl_Coverage.slx'));
end

p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
    'CruiseControl_PartialCoverageValid_harness.slx'), ...
    fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
    'CruiseControl_Coverage_harness.slx'));
copyfile(fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
    'CruiseControl_TestGen.slx'), ...
    fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
    'CruiseControl_Coverage.slx'));
clear p;
% open the model
open_system('CruiseControl_Coverage_harness.slx');
set_param('CruiseControl_Coverage_harness/Test Unit','ModelName', ...
    'CruiseControl_Coverage');
set_param('CruiseControl_Coverage_harness/Evaluation/engaged_Assertion',...
    'StopWhenAssertionFail','on');
set_param('CruiseControl_Coverage_harness/Evaluation/tspeed_Assertion',...
    'StopWhenAssertionFail','on');
