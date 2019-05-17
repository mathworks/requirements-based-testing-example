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

p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','AdHocHarnesses','CruiseControl_RP_.slx'), ...
    fullfile(p.RootFolder,'Work','CruiseControl.slx'));
clear p;
open_system('CruiseControl.slx');
%sltest.harness.open('CruiseControl','CruiseControl_RP_Adhoc_Harness');