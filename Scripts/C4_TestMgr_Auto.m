%% ========================================================================
%       Requirements Based Functional Testing - Short Test Plan - Test Mgr
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test
p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','CruiseControl_SLT_4.slx'), ...
     fullfile(p.RootFolder,'Models','CruiseControl.slx'));
clear p;
% open the model
open_system('CruiseControl.slx');
% show the auto script
edit importXLS2SLT.m
%%  Open test cases based on reqs
winopen('CruiseControlTests_SLT_Import.xlsx');
%%  Create test case in SL Test Mgr
sltest.testmanager.registerTestAdapter('XLSadaptor',true);
sltest.testmanager.view
% select "use current model" for "CruiseControl"