%% ========================================================================
%       SL Req Link and Test 
%  ========================================================================
%% close
bdclose all
clear all

%% Load Prop Proving test harness
% open_system('CruiseControl_Req_pp.slx');

%%  Open Cruise Control version for linking
copyReqsMdl('CruiseControl_Req','CruiseControl_Req');
copyReqsDataDict('CruiseControl_Req_dd','CruiseControl_Req_dd');
open_system('CruiseControl_Req.slx');

%%  Open Requirements 
copyReqSet('MW_CruiseControl','MW_CruiseControl');
slreq.open('MW_CruiseControl'); 
copyExtReqs('SystemReqs_1','SystemReqs',1);
slreq.open('SystemReqs'); 

%%  Open SL test file
copyReqsTestCase('CruiseControl_TestCase','CruiseControl_TestCase');
sltest.testmanager.load('CruiseControl_TestCase.mldatx');
%sltest.testmanager.view;
