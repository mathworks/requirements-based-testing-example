%% ========================================================================
%       Ad-hoc Testing with VNT
%  ========================================================================
%% close
bdclose all
clear all
%
%  0)  Change to "Work" directory
%  1)  Introduce Cruise Control module with VNT operation
%  2)  Use harness with constant inputs and boolean
%      Show tspeed value while running panel
%
CruiseControl_dd_RP;
load_system('CruiseControl_VNT_harness');
open_system('CruiseControl_RP_level_harness/Dashboard');
open_system('CruiseControl_RP_level_harness','window');
load_system('CruiseControl_RP_level');
open_system('CruiseControl_RP_level/Compute target speed','window');