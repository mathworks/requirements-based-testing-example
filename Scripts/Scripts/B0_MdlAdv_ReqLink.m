%% ========================================================================
%       Model Advisor Checks
%  ========================================================================
%% close
bdclose all
clear all
%
%%  Copy Cruise Control version for model advisor check
copyReqsMdl('CruiseControl_Req','CruiseControl_Req');
copyReqsDataDict('CruiseControl_Req_dd','CruiseControl_Req_dd');
copyReqSet('MW_CruiseControl','MW_CruiseControl');
copyExtReqs('SystemReqs_1','SystemReqs',1);
copyReqsTestCase('CruiseControl_TestCase','CruiseControl_TestCase');
open_system('CruiseControl_Req.slx');
