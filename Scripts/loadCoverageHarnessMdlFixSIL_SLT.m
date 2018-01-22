%% ========================================================================
%       Requirements Based Functional Testing
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test
p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','CruiseControl_SLT_6.slx'), ...
    fullfile(p.RootFolder,'Models','CruiseControl.slx'));
clear p;
%%  Open test file preconfigured for "top-it-off" workflow
sltest.testmanager.clear;
sltest.testmanager.load('topItOff_SIL');
sltest.testmanager.view;

