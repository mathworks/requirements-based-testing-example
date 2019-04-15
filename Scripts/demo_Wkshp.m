%% ========================================================================
%       M O D E L    V E R I F I C A T I O N
%  ========================================================================

%% ========================================================================
%       Ad-hoc Testing
%       -- dashboard (HMI) controls (including cals) 
%       -- debugging with breakpoints
%       -- early reqs model with a MATLAB func block
%  ========================================================================
%  0)  Change to "Work" directory
%  1)  Introduce Cruise Control module operation
%  2)  Use harness with constant inputs and boolean
%      Show tspeed value while running panel
%  3)  Find that it will occasionally create a runaway condition
A1_AdHoc_ReqCheck; 
%  4)  Set a breakpoint on the output assertion signal for the "No Speed Change" check
%  5)  When breakpoint has been triggered, continue stepping, algo has 
%       missed "hasChangedTo" condition 
%%  Open harness with "level exit" fix
%  6)  The "hasChangedTo" event is overdesigned, meaning what is relevant is the
% level of "AccelResSw" and not whether the design responds to the "edge".
%  8)   A more robust design is one that incorporates this improvement
% where the "hasChanged" logic has been replaced with the level check "!AccelResSw"
%  9)  Open the improved logic and use in the Cruise Control Ad-Hoc test harness model - 
A2_AdHoc_ReqCheckFix; 
%% close
bdclose all
clear all

%% ========================================================================
%       Requirements Authoring and Linking
%  ========================================================================
open_system('CruiseControl_Req.slx');
uiopen('MW_CruiseControl.slreqx',1);

%% close
bdclose all
clear all

%% ========================================================================
%       Model Advisor Checks
%  ========================================================================
% 0) Load model advisor / req linking example model
open_system('CruiseControl_MdlAdv_ReqLink.slx');
% 1) Show edit-time checking, focus on subsytem names
% 2) Open Mdl Adv
% 3) Simulink checks
% 3a)Stateflow checks
% 4) Focus on propagated names
% 4a)Change entry and data type comparison
% 5) Open config editor to show options
%%  Open requirements word doc
winopen('cruise_control_reqs_mdl_linked.docx');
% 1) Show highlighting
% 2) Add a link for the "Speed" input
% 3) Create webview report
%% close
bdclose all
clear all

%% ========================================================================
%       Design Error Detection
%       -- easy "dead logic" check before functional testing
%       -- debugging the issue in the command window for int calculations
%  ========================================================================
%  Open Cruise Control Algo Module
%  1)  Converted to integer cals and integer signals
%  2)  Checking for design errors before functional verification testing
B1_DED_DeadLogic;
%  3)  Open "Analysis-->Design Verifier-->Options..."
%      -- show Design Error Detection options (Dead logic, Identify active)
%% Run DED to find "dead logic" 
%  4)  Run "Dead Logic" detection, "Analysis-->Design Verfier-->Detect Design
%  Errors-->Model"  OR  double-click "Show DED Results" block
%  5)  Navigate to state chart, click on the *red transition arrow* which 
%      is where the dead logic has been found.  This means that Transition 
%      Condition 2, "after(incdec/holdrate*10,tick)" can never be false. 
%      But why can this transition not be false?  
%% Debug dead logic
%  6)  Set a breakpoint on the default transition with the setting 
% *When transition is valid*.
%  7)  In the command window, look at the value and class (data types) of
%      "incdec" and "holdrate".  Perform "incdec/holdrate", notice the 
%      result is zero.  The order of integer operations leads to dead logic
%% Load the Fix 
%  8)  Replace the transition calculation "after(incdec/holdrate*10,tick)"
%      with a change in the order of calculations to 
%      "after(10*incdec/holdrate,tick)"  OR  load the fix
bdclose all
clear all
open_system('CruiseControl_IntCalcFix');
%  4)  Run "Dead Logic" detection, "Analysis-->Design Verfier-->Detect Design
%  Errors-->Model"  OR  double-click "Show DED Results" block
%% close
bdclose all
clear all

%% ========================================================================
%       Subsystem Testing
%  ========================================================================
C0_FuncTest_Sub;
%% ========================================================================
%       System Testing
%  ========================================================================
C0_FuncTest;
% 1) Highlight natural language test authoring
% 2) Usage of test sequences
% 3) Show evaluation in SDI

%% ========================================================================
%       Requirements Based Functional Testing
%       -- manually create req based test vectors
%       -- use SL Test to automate testing
%       -- show model coverage for test completeness
%  ========================================================================
%%  Open requirements word doc and test cases based on reqs
%  1)  Show reqs and the manually created test cases
winopen('cruise_control_reqs.docx');
winopen('CruiseControlTestsPartCov.xlsx');
%%  Open Cruise Control model and harness
%  2)  Highlight that this is a SLT harness, launched from the main model
%  3)  Show SB block with contents imported from test case spreadsheet 
loadCoverageHarnessMdl_SLT;
%%  Open SL Test Manager to run tests on model
sltest.testmanager.load('CruiseControlTests_Coverage.mldatx');
sltest.testmanager.view;
%%  Open harness with partial coverage test vectors
%  4)  Navigate to "SB_Initial_Coverage".  Highlight configuration including
%      harness selection, inputs from SB, iterations based on SB, coverage
%      settings in the test case
%  5)  With "SB_Initial_Coverage" highlighted, select "Run"
%  6)  In "Results and Artifacts" tab, show all (14) test cases pass, 
%      highlight the coverage results, use link to open model and show
%      coverage
%% close

%% ========================================================================
%       Test Case Generation
%% ========================================================================
% -- Navigate to results from "initial coverage"
% -- Select "Cruise Control", then "Add Tests for Missing Coverage"
% -- From UI, select new harness, new test case
% -- Once completed select "initial coverage" and new test case
% -- Run to show 100% coverage

%% ========================================================================
%       Equivalence Testing
%       -- use the Test Mgr to automate model vs code equiv testing
%       -- reuses harness from functional testing
%       -- relies on 100% model coverage test vectors
%  ========================================================================
%% open Cruise Control model and harness for equivalence testing
loadEquivalenceHarnessMdl_SLT;
%%  Open SL Test Manager to run tests on model
sltest.testmanager.load('CruiseControlTests_Coverage.mldatx');
sltest.testmanager.view;
%  0)  Use the baseline SIL test case!!
%  1)  In the Test Mgr, navigate to "Equivalence_Test/SB_Equiv_Full_Cov_SLDV".
%      Show that this is an equivalence type test with the (2) simulations.
%      In the test case, the first simulation uses a harness to run the 
%      model in "normal" mode and the second model uses a harness run the
%      simulation in "SIL" mode. NOTE:  Two models are used to enable the
%      code coverage feature to operate properly. Next show the evaluation 
%      criteria.  Lastly stress this is the same harness we used for the 
%      previous functional tests.
%  2)  With the test case "Equivalence_Test/SB_Equiv_Full_Cov_SLDV" 
%      highlighted, select "Run".  This will take some time, you may want
%      to select the first (6) tests to run to show the general idea.
%  3)  In the results, show the 100% coverage for the model and open the
%      code generation report to show the 97% coverage with Bullseye.
%% close
bdclose all
clear all
sltest.testmanager.close;


%% ========================================================================
%       SIL Testing -- SKIP
%       -- use the Test Mgr to automate code testing
%       -- reuses harness from functional testing
%       -- relies on 100% model coverage test vectors
%  ========================================================================
%% open Cruise Control model and harness for SIL testing
bdclose all
clear all
open_system('CruiseControl_SIL.slx');
sltest.harness.open('CruiseControl_SIL','CruiseControl_Harness_SB_Full_SIL');
%%  Open SL Test Manager to run tests on model
sltest.testmanager.load('CruiseControlTests_Coverage.mldatx');
sltest.testmanager.view;
%  1)  In the Test Mgr, navigate to "SIL_Test/SB_Full_Coverage_SLDV".
%      Show that this is a baseline test using a SIL test harness.
%  2)  Select "Run".  (This will take some time)
%  3)  In the results, show the near 100% coverage for the code
%% close
bdclose all
clear all
sltest.testmanager.close;

%
%% ========================================================================
%       Reproducing Field Issues - Property Proving
%       -- start with a field issue (reactive)
%       -- then move to a requirements property (proactive)
%  ========================================================================
%
%  Option #1  -- Field Issue
%             -- Increase tspeed with CoastSetSw (reduce speed button)
%  Open property proving model 
D1_PP_FieldIssue;
%  1)  Show architecture:  input assumptions, property models
%  2)  Show temporal library, constraints/assumptions/proofs/objectives
%  3)  Run "Design Verifier-->Prove Properties-->Model"
%% Debugging the field issue
%  4)  Double-click "Open Harness" to open a partially configured harness
%      to begin debugging
%  5)  Run the model, open SDI and configure to "overwrite runs", load a 
%      saved view "propProveView" to provide a 3x1 subplot, with "tspeed", 
%      "CoastSetSw" and "AccelResSw" (top to bottom)
%      run to show Tspeed increase
%  6)  Notice that (0.4) the "tspeed" increases with a "CoastSetSw" input
%  7)  Single step to show path through "sneak path" at (0.4) in the state
%      chart
%% Using the sneak path fix
CtrlsVer = CtrlsVerEnum.CtrlD_ExecOrderSneak_fix;
%  8)  Run the model again to show the "tspeed" no longer increases
%%  Re-run property proving on the model with the sneak fix (optional)
%  9)  Go back to  pp harness. For the Controls block, use 
%      "CtrlD_ExecOrderSneak_fix" version (should be set from above step)
%  10) Re-run "Analysis/Design Verifier/Prove Properties/Model" ==> Valid!!
%%  Show eml version of field issue behavior (optional)
%  11)  Show eml version: "CoastSet pulse (eml) with tspeed decrease"
Prop2Prove = PropEnum.Prop_coast_pulse_eml;
%  12) Run again to show eml version of property (field issue behavior) model
%
%%  Option #2 -  With fix, check will all parameters, a "requirement" property
% -------------------------------------------------------------------------
%  1) Select "CoastSet pulse with tspeed decrease" property
%     --  Use a "requirement" property
%     --  Let all inputs "float"
%  2) For the Controls block, select version "CtrlD_ExecOrderSneak_fix"
D2_PP_ReqProve;
%  3)  Run "Design Verifier-->Prove Properties-->Model"
%% Debugging the requirements propety issue
%  4)  Double-click "Open Harness" to open a partially configured harness
%      to begin debugging.  SDI should be pre-configured from before.
%  6)  Notice that (0.3) the "tspeed" increases with a "CoastSetSw" input,
%      but this time, the "AccelResSw" is also high.  So this is a double
%      press input that our design (and req) is not handling.
%% Using the "Double Press Reject" fix
%  7)  Select fix in pp harness
CtrlsVer = CtrlsVerEnum.CtrlE_ExecOrderSneakDblReject_fix;
%  8)  Run the model again to show the "tspeed" no longer increases
%%  Re-run property proving on the model with the "Double reject sneak fix" 
%  9)  Go back to  pp harness. For the Controls block, use 
%      "CtrlE_ExecOrderSneakDblReject_fix" version (should be set from above step)
%  10) Re-run "Analysis/Design Verifier/Prove Properties/Model" ==> Valid!!
%      Highlight iterative workflow with each behvioral model indentifty an
%      issue, fixed with generated test case and then proven valid
%
%% open SL Test - re-run verification to show all pass after pp changes
bdclose all;
p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','CruiseControl_SLT_2.slx'), ...
    fullfile(p.RootFolder,'Models','CruiseControl.slx'));
if exist('cumcov_SLT.cvt','file')==2
    delete(which('cumcov_SLT.cvt'));
end
sltest.testmanager.load('CruiseControlTests_SLT_MC.mldatx');
sltest.testmanager.view;
%% close
bdclose all
%