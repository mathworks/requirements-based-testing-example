%% ========================================================================
%       Requirements Based Functional Testing
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test
deleteAllInProj('CruiseControl_harness_SLDV.slx');

p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','ReqTestHarnesses', ...
    'CruiseControl_harness_SLDV_final.slx'), ...
    fullfile(p.RootFolder,'Models','ReqTestHarnesses', ...
    'CruiseControl_harness_SLDV.slx'));
clear p;
% open the model
open_system('CruiseControl_harness_SLDV.slx');