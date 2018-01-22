%% ========================================================================
%       SL Req Link and Test 
%  ========================================================================
%% close
bdclose all
clear all
%
%%  Open SL test file
sltest.testmanager.load('CruiseControlTests_Coverage.mldatx');
sltest.testmanager.view;

%%  Open Cruise Control version for linking
open_system('CruiseControl_Req2.slx');