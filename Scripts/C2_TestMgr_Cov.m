%% ========================================================================
%       Requirements Based Functional Testing - Test Plan - Test Mgr
%  ========================================================================
%%  Open requirements word doc and test cases based on reqs
%  1)  Show reqs and the manually created test cases
winopen('cruise_control_reqs.docx');
winopen('CruiseControlTestsPartCov.xlsx');
%% open full coverage func test model - for importing into Test Mgr
loadCoverageHarnessMdl_SLT
sltestmgr



