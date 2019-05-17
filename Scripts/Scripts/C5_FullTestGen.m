%% ========================================================================
%       Test Generation for Equivalence Testing
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for equivalence test
p = slproject.getCurrentProject;
% delete any CruiseControl models
deleteAllInProj('CruiseControl.slx');

copyfile(fullfile(p.RootFolder,'Models','CruiseControl_SLT_4.slx'), ...
    fullfile(p.RootFolder,'Models','CruiseControl.slx'));
clear p;
open_system('CruiseControl');