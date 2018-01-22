%% ========================================================================
%       Requirements Based Functional Testing
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test
p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','CruiseControl_SLT_3.slx'), ...
    fullfile(p.RootFolder,'Models','CruiseControl.slx'));
clear p;
% open the model
%open_system('CruiseControl.slx');
%sltest.harness.open('CruiseControl','CruiseControl_Harness_SB');
%%  Open test file preconfigured for "top-it-off" workflow
sltest.testmanager.clear;
sltest.testmanager.load('topItOff');
sltest.testmanager.view;

