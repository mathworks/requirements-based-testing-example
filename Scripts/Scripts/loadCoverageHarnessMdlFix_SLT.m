%% ========================================================================
%       Requirements Based Functional Testing
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test
p = slproject.getCurrentProject;
% delete any CruiseControl models
deleteAllInProj('CruiseControl.slx');

copyfile(fullfile(p.RootFolder,'Models','CruiseControl_SLT_3.slx'), ...
    fullfile(p.RootFolder,'Models','CruiseControl.slx'));
clear p;
% open the model
open_system('CruiseControl.slx');

