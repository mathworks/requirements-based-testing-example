%% ========================================================================
%       Design Error Detection
%  ========================================================================
%% close
bdclose all
clear all
%
%  Open Cruise Control Algo Module with the Ad-hoc design changes
%  -- Checking for design errors before functional verification testing
p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','DesignErrDetect','CruiseControl_DED3_.slx'), ...
    fullfile(p.RootFolder,'Work','CruiseControl.slx'));
clear p;
open_system('CruiseControl.slx');

%  1)  Open "Design Verifier-->Options..."
%      -- show Design Error Detection options (Dead logic, Identify active)
