%% ========================================================================
%       Requirements Based Functional Testing with Coverage
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test
% p = slproject.getCurrentProject;
% copyfile(fullfile(p.RootFolder,'Models','CruiseControl_SLT_2.slx'), ...
%     fullfile(p.RootFolder,'Models','CruiseControl_SIL.slx'));
% clear p;
% open the model
open_system('CruiseControl_SIL.slx');
sltest.harness.open('CruiseControl_SIL','CruiseControl_SIL_Harness_SB_Full');

% deleteAllInProj('CruiseControl_SIL_harness.slx');
% deleteAllInProj('CruiseControl_SIL.slx');
% 
% p = slproject.getCurrentProject;
% copyfile(fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
%     'CruiseControl_FullCoverageValid_harness.slx'), ...
%     fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
%     'CruiseControl_SIL_harness.slx'));
% copyfile(fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
%     'CruiseControl_Eq.slx'), ...
%     fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
%     'CruiseControl_SIL.slx'));
% clear p;
% % open the model
% open_system('CruiseControl_SIL_harness.slx');
% set_param('CruiseControl_SIL_harness/Test Unit','ModelName', ...
%     'CruiseControl_SIL');
% set_param('CruiseControl_SIL_harness/Test Unit','SimulationMode','Normal');
% set_param('CruiseControl_SIL_harness/Evaluation/engaged_Assertion',...
%     'StopWhenAssertionFail','on');
% set_param('CruiseControl_SIL_harness/Evaluation/tspeed_Assertion',...
%     'StopWhenAssertionFail','on');
