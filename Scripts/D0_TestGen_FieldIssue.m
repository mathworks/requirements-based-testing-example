%% ========================================================================
%       Reproducing Field Issues - Property Proving
%  ========================================================================
%  Option #1  -- Field Issue
%             -- Increase tspeed with CoastSetSw (reduce speed button)

%% close
bdclose all
clear all
definePPenums

%% 1) Open test gen model with
CruiseControl_tc_DecInputWithTSpeedInc;
%  a)  Show architecture:  input test condition, single test objective
%  b)  Show temporal library, constraints/assumptions/proofs/objectives
%
% -------------------------------------------------------------------------
%% 2) Set version to "CtrlC_ExecOrder_fix"
CtrlsVer = CtrlsVerEnum.CtrlC_ExecOrder_fix;

% save_system('CruiseControl_pp');