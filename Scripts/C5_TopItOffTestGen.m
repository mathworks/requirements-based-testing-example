%% ========================================================================
%       Requirements Based Functional Testing
%  ========================================================================
%%  Load model with exit condition fix and SB harnesses
loadCoverageHarnessMdlFix_SLT;
%%  Open test file preconfigured for "top-it-off" workflow
sltest.testmanager.clear;
sltest.testmanager.load('topItOff');
sltest.testmanager.view;