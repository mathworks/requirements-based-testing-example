%% ========================================================================
%       "Component Testing" subystem fixes version of Cruise Control
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test
p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','CruiseControl_SLT_AdhocSubFix.slx'), ...
    fullfile(p.RootFolder,'Models','CruiseControl_SLT.slx'));
clear p;
open_system('CruiseControl_SLT');