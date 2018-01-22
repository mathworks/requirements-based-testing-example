%% ========================================================================
%       Requirements Based Test Gen - Short Test Plan - Test Mgr
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test
p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','CruiseControl_SLT_2.slx'), ...
    fullfile(p.RootFolder,'Models','CruiseControl.slx'));
clear p;
% open the model
open_system('CruiseControl.slx');
sltest.harness.open('CruiseControl','CruiseControl_TestGen_Harness1');
