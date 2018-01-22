%% ========================================================================
%       Requirements Based Functional Testing with Coverage
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test

if exist('CruiseControl_SIL_harness.slx','file')
    delete(which('CruiseControl_SIL_harness.slx'));
end
if exist('CruiseControl_SIL.slx','file')
    delete(which('CruiseControl_SIL.slx'));
end

p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
    'CruiseControl_FullCoverageValid_harness.slx'), ...
    fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
    'CruiseControl_SIL_harness.slx'));
copyfile(fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
    'CruiseControl_Eq.slx'), ...
    fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
    'CruiseControl_SIL.slx'));
clear p;
% open the model
open_system('CruiseControl_SIL_harness.slx');
set_param('CruiseControl_SIL_harness/Test Unit','ModelName', ...
    'CruiseControl_SIL');
set_param('CruiseControl_SIL_harness/Test Unit','SimulationMode','Normal');
set_param('CruiseControl_SIL_harness/Evaluation/engaged_Assertion',...
    'StopWhenAssertionFail','on');
set_param('CruiseControl_SIL_harness/Evaluation/tspeed_Assertion',...
    'StopWhenAssertionFail','on');
