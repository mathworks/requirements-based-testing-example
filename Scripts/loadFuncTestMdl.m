%% ========================================================================
%       Requirements Based Functional Testing
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test
p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','CruiseControl_SLT_0.slx'), ...
    fullfile(p.RootFolder,'Models','CruiseControl.slx'));
clear p;
% clear any existing coverage
%coverageMgr('clear');
% delete any SLDV harnesses
while exist('CruiseControl_harness_SLDV.slx','file')
    delete(which('CruiseControl_harness_SLDV.slx'));
end
% open the model
open_system('CruiseControl.slx');

