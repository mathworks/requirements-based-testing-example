%% ========================================================================
%       Requirements Based Functional Testing - Short Test Plan
%  ========================================================================
%%  Open requirements word doc
winopen('cruise_control_testplan_short.docx');
%%  Open test cases based on reqs
winopen('CruiseControlTests_short.xlsx');
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test
p = slproject.getCurrentProject;
% delete any CruiseControl models
deleteAllInProj('CruiseControl.slx');

copyfile(fullfile(p.RootFolder,'Models','CruiseControl_SLT_0.slx'), ...
    fullfile(p.RootFolder,'Models','CruiseControl.slx'));
clear p;
% open the model
open_system('CruiseControl.slx');
sltest.harness.open('CruiseControl','CruiseControl_Harness_ShortTestSeq');

