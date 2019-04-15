%% ========================================================================
%       Equivalence Testing - Full Cov Test Plan - Test Mgr
%  ========================================================================

%%  Load model with exit condition fix and SB harnesses
loadCoverageHarnessMdlFix_SLT;
%%  Open test file preconfigured for "top-it-off" workflow
sltest.testmanager.clear;
sltest.testmanager.load('topItOff_final');
sltest.testmanager.view;

% manually select "SIL" mode and run tests