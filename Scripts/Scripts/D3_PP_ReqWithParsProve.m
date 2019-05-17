%% ========================================================================
%       Requirement + No Input Constraints - Property Proving
%  ========================================================================
%  Option #3    -- a "requirement" propery 
%               -- with double input fix
%               -- now check parameters across ranges

% -------------------------------------------------------------------------
%% close
bdclose all
clear all
definePPenums

%  1) Open property proving model with
CruiseControl_pp

% -------------------------------------------------------------------------
%%  2) Select version "CtrlE_ExecOrderSneakDblReject_fix"
CtrlsVer = CtrlsVerEnum.CtrlE_ExecOrderSneakDblReject_fix;

%% 3)  Select property to prove to "Prop_coast_minspeed" property
Prop2Prove = PropEnum.Prop_coast_minspeed;

%% 4) Open "Design Verifier-->Options...", show Parameter table
%     -- "Clear", "Find in Model", use range for holdrate and incdec
%     -- Use the parameter ranges to open up the proof

save_system('CruiseControl_pp');
