%% ========================================================================
%       Requirement + No Input Constraints - Property Proving
%  ========================================================================
%  Option #2    --  Use a "requirement" property, with mintspeed
%               --  No constraint on the inputs 
%% close
bdclose all
clear all
definePPenums

%  1) Open property proving model with
CruiseControl_pp

% -------------------------------------------------------------------------
%%  2) Select version "CtrlD_ExecOrderSneak_fix"
CtrlsVer = CtrlsVerEnum.CtrlD_ExecOrderSneak_fix;

%% 3)  Select property to prove to "Prop_coast_minspeed" property
Prop2Prove = PropEnum.Prop_coast_minspeed;

save_system('CruiseControl_pp');