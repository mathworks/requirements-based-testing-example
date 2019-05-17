%% ========================================================================
%       Design Error Detection
%  ========================================================================
%% close
bdclose all
clear all
%
%  Open Cruise Control Algo Module
%  1)  Changes based on "dead logic" analysis
%  2)  Checking for design errors before functional verification testing
%  3)  Open "Design Verifier-->Options..."
%      -- show Design Error Detection options (Divide by zero)
%      -- enable parameter table

p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','DesignErrDetect','CruiseControl_DED3_Final_.slx'), ...
    fullfile(p.RootFolder,'Work','CruiseControl.slx'));
clear p;
open_system('CruiseControl.slx');
