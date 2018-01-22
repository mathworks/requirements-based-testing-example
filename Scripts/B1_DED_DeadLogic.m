%% ========================================================================
%       Design Error Detection
%  ========================================================================
%% close
bdclose all
clear all
%
%  Open Cruise Control Algo Module
%  1)  Converted to integer cals and integer signals
%  2)  Checking for design errors before functional verification testing
CruiseControl_IntCalc
%  1)  Open "Design Verifier-->Options..."
%      -- show Design Error Detection options (Dead logic, Identify active)
