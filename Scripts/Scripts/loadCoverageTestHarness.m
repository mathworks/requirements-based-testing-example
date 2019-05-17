%% ========================================================================
%       Requirements Based Functional Testing with Coverage
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test
deleteAllInProj('CruiseControl_Coverage_harness.slx');
deleteAllInProj('CruiseControl_Coverage.slx');

p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
    'CruiseControl_PartialCoverage_harness.slx'), ...
    fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
    'CruiseControl_Coverage_harness.slx'));
copyfile(fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
    'CruiseControl_LogicIssue.slx'), ...
    fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
    'CruiseControl_Coverage.slx'));
clear p;
% open the model
open_system('CruiseControl_Coverage_harness.slx');
set_param('CruiseControl_Coverage_harness/Test Unit','ModelName', ...
    'CruiseControl_Coverage');