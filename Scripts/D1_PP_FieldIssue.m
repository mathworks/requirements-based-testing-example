%% ========================================================================
%       Reproducing Field Issues - Property Proving
%  ========================================================================
%  Option #1  -- Field Issue
%             -- Increase tspeed with CoastSetSw (reduce speed button)

%% close
bdclose all
clear all
definePPenums

%% 1) Open property proving model with
CruiseControl_pp;
%  a)  Show architecture:  input assumptions, property models
%  b)  Show temporal library, constraints/assumptions/proofs/objectives
%  c)  Reset holdrate to (5) in Parameters, and incdec to (1)
%
% -------------------------------------------------------------------------
%% 2) Set version to "CtrlC_ExecOrder_fix"
CtrlsVer = CtrlsVerEnum.CtrlC_ExecOrder_fix;

%% 3)  Select property to prove to "Prop_coast_pulse" property
Prop2Prove = PropEnum.Prop_coast_pulse;

save_system('CruiseControl_pp');