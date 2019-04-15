%% ========================================================================
%       Requirements Based Test Gen - Disengage With Brake - Test Mgr
%  ========================================================================
%% close
bdclose all
clear all
% open the model
open_system('CruiseControl_TestGenSeq.slx');
sltest.harness.open('CruiseControl_TestGenSeq','CruiseControl_TestGenSLT1_Harness');
