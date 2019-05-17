%% ========================================================================
%       SL Req Link and Test 
%  ========================================================================
%% close
bdclose all
clear all

%%  Copy Cruise Control hand code for test
p = slproject.getCurrentProject;
% delete any CruiseControl models
%deleteAllInProj('CruiseControl_C_main.slx');

copyfile(fullfile(p.RootFolder,'Models','C_Caller','CruiseControl_C_main.slx_'), ...
    fullfile(p.RootFolder,'Work','CruiseControl_C_main.slx'));
% open the model
open_system('CruiseControl_C_main.slx');
sltest.harness.open('CruiseControl_C_main','CruiseControl_C_main_SB_Full_Harness');

%%  Open Cruise Control hand code SL test file
copyReqsTestCase('CruiseControl_TestCase','CruiseControl_TestCase');
sltest.testmanager.load('CruiseControl_C_Tests.mldatx');
sltest.testmanager.view;

clear p;
