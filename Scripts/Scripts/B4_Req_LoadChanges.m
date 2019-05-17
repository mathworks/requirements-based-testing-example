%% ========================================================================
%       SL Req Link and Test 
%  ========================================================================
%% close
bdclose all
clear all
%
%%  Open SL test file
% copyReqsTestCase('CruiseControl_TestCase','CruiseControl_TestCase');
% sltest.testmanager.load('CruiseControl_TestCase.mldatx');
%sltest.testmanager.view;

%%  Open Cruise Control version for linking
copyReqsMdl('CruiseControl_Req_ReqChange','CruiseControl_Req');
open_system('CruiseControl_Req.slx');

%%  Open Requirements 
rs = slreq.find('Type','ReqSet','Name','MW_CruiseControl');
close(rs);
copyReqSet('MW_CruiseControl_ReqChange','MW_CruiseControl');
slreq.open('MW_CruiseControl'); 
