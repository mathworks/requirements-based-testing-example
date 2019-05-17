%% ========================================================================
%       "Component Testing" subystem fixes version of Cruise Control
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test
p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','Subsystem','CruiseControl_SubFix.slx'), ...
    fullfile(p.RootFolder,'Work','CruiseControl.slx'));
clear p;
open_system('CruiseControl');