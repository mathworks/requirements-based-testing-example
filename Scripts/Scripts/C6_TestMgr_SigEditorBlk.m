%% ========================================================================
%    Signal Editor Block Functional Testing - Short Test Plan - Test Mgr
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test
p = slproject.getCurrentProject;
% delete any CruiseControl models
deleteAllInProj('CruiseControl.slx');

copyfile(fullfile(p.RootFolder,'Models','CruiseControl_SLT_3.slx'), ...
     fullfile(p.RootFolder,'Models','CruiseControl.slx'));
clear p;
% open the model
open_system('CruiseControl.slx');
%%  Show the auto script
edit sigEditorBlkAdapter.m
%%  Open signal editor test cases 
signalEditor('DataSource','CruiseControl_Short_SigEditor.mat');
%%  Create test case in SL Test Mgr
%sltest.testmanager.registerTestAdapter('sigEditorBlkAdapter',true);
sltest.testmanager.load('CruiseControlTests_More.mldatx');
sltest.testmanager.view
% select "use current model" for "CruiseControl"