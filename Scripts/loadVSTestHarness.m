%% ========================================================================
%       Requirements Based Functional Testing with Coverage
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test

deleteAllInProj('CruiseControl_VS.slx');

p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
    'CruiseControl_IDE.slx'), ...
    fullfile(p.RootFolder,'Models','TestGenHarnesses','Coverage', ...
    'CruiseControl_VS.slx'));
clear p;
% open the model
open_system('CruiseControl_VS.slx');
sltest.harness.open('CruiseControl_VS','CruiseControl_VS_Adhoc_Harness');
open_system('CruiseControl_VS_Adhoc_Harness/Dashboard','window');


