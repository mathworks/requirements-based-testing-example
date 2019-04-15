%% ========================================================================
%       Requirements Based Test Gen - Disengage With Brake - Test Mgr
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test

% copyReqsMdl('CruiseControl_Req','CruiseControl_Req');
% open_system('CruiseControl_Req.slx');
B3_Req_LinkAndTest;

p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models',filesep,'TestGenHarnesses', ...
    filesep,'TestCases',filesep,'CruiseControl_TestGen_DisengageWithBrake_Seq_.slx'), ...
    fullfile(p.RootFolder,'Work','CruiseControl_TestGen_DisengageWithBrake_Seq.slx'));
clear p;
% open the model
open_system('CruiseControl_TestGen_DisengageWithBrake_Seq.slx');
