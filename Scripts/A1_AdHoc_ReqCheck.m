%% ========================================================================
%       Ad-hoc Testing with Dashboard
%  ========================================================================
%% close
bdclose all
clear all
%
%  0)  Change to "Work" directory
%  1)  Introduce Cruise Control module operation
%  2)  Use harness with constant inputs and boolean
%      Show tspeed value while running panel
%
CruiseControl_dd_RP;
%open_system('CruiseControl_RP_reqCheck_harness','window');

open_system('CruiseControl_RP');
open_system('CruiseControl_RP/Compute target speed');
sltest.harness.open('CruiseControl_RP','CruiseControl_RP_Adhoc_Harness');