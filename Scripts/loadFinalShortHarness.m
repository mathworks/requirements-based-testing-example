%% ========================================================================
%       Requirements Based Functional Testing
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test
while exist('CruiseControl_harness_SLDV.slx','file')
    delete(which('CruiseControl_harness_SLDV.slx'));
end
p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','ReqTestHarnesses', ...
    'CruiseControl_harness_SLDV_final.slx'), ...
    fullfile(p.RootFolder,'Models','ReqTestHarnesses', ...
    'CruiseControl_harness_SLDV.slx'));
clear p;
% open the model
open_system('CruiseControl_harness_SLDV.slx');