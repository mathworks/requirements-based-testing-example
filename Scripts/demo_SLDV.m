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
%  9)  Run "Dead Logic" detection, "Analysis-->Design Verfier-->Detect Design
%  Errors-->Model"  OR  double-click "Show DED Results" block
%% Running Divide by Zero Detection on the Model
%
% Analyze the model for calculations that result in a divide by zero.  For 
% the dead logic detection we used the nominal calibration value of (5) for the
% "holdrate" and (1) for "incdec".  Calibrations typically have a range of values
% that are permissible within specified limits. *Simulink Design Verifier* 
% provides a means to perform the analysis over a range of values.  To 
% perform the "divide by zero" analysis, do the following:
%
%  1) Open *CruiseControl_DivByZero.slx* 
B2_DED_DivideByZero;
%
%% 2)  Specify a range of parameters to be used for the analysis. 
% Go to *Analysis*, *Design Verifier*, and *Options* to open the 
% configuration window.
%
%  3)  Go to *Parameters*, check *Enable parameter configuration*, check 
% *Use parameter table*.  Select *Find in Model* to populate the parameter
% table.  Uncheck the *Use* column for "maxtspeed" and "mintspeed". 
%
%% 4)  In the same configuration dialog, go to *Design Error Detection*, 
% check *Division by zero*, and select *OK*.
%
%% 5) Go to *Analysis*, *Design Verifier*, *Detect Design Errors*, and
% select *Model* to run the analysis.
%
%% Analyzing the Divide by Zero Detection Results
%
% Let’s take a look at the results and see what might be causing the error.
% Do the following:
%
%  1)  In the *Results Inspector* window, select *Generate detailed analysis
% results*.  We will look at the results to help us debug the divide by 
% zero issue.
%
% Since the analysis included the use of a parameter table to specify a
% range of parameter values that were part of the analysis.  Navigate in 
% the report to the "Parameter Constraints" section to verify the range 
% that was used in the analysis.  Next look at the generated test cases, 
% noting the parameter values that were used in the test cases.
%
%% 2)  From the *Results Inspector* window, select *Create harness model*.  
% Run "Test Case 1" to debug the issue.
%
%% 3)  The cause of the issue is the "holdrate" lower limit value of (0).
% Change the lower limit of "holdrate" in the workspace to (1).  
% 
%  4)  Go to *Analysis*, *Design Verifier*, and *Options* to open the 
% configuration window.  
%
%  5)  Go to *Parameters*, select all parameters and press *Clear*. 
% Next select *Find in Model* to populate the parameter table with the
% new "holdrate" limits from the workspace.  Make sure to uncheck the 
% *Use* column for "maxtspeed" and "mintspeed".  Select *OK*. 
%
%
%% 6)  Go to *Analysis*, *Design Verifier*, *Detect Design Errors*, and
% select *Model* to run the analysis.  Confirm that the issue has been
% resolved.
%
%% Automating Design Error Detection Checks (optional)
%
% What we have shown is an interactive, manual way to run the checks.  
% There is an automated method to run the *Design Error Detection* checks
% on the model with *Model Advisor*.
%
%% 1) Go to *Analysis*, *Model Advisor* and select *Model Advisor*
%
%% 2 In the popup window, choose the top model, *CruiseControl_DivByZero* to
% analyze 
%
%% 3) Navigate to *Model Advisor*, *By Product*, *Simulink Design Verifier*,
% *Design Error Detection*
%
%  4) Select (2) checks to run: *^Detect Dead Logic* and *^Detect Division By
% Zero*
%
%  5) Press *Run Selected Checks* for the *Design Error Detection* group of
% checks
%
% With the inclusion of *Design Error Checks* in *Model Advisor* you now
% have the option of adding these checks as part of your development and 
% testing workflow.  These checks may be a pre-condition to begin the more
% formalized simulation testing 
%% close
bdclose all
clear all
%
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
%sltest.testmanager.close;
sltest.harness.close('CruiseControl');

%% ========================================================================
%       Test Case Generation
%% ========================================================================
% open Cruise Control without a harness
C5_FullTestGen;
%% open external harness, until merge works with SLT harnesses
open_system('CruiseControl_Harness_SB');
%  -- "run all" in "fast restart"
%  -- save cumulative coverage
%  -- use reports explorer to save "CruiseControlCovManual.cvt"
% cvsave('CruiseControlCovManual','CruiseControl');

%%  generate test cases for "top-it-off" workflow
%  -- disable parameter table if necessary

%%  Merge and run full coverage harness
try
    if strcmp(get_param(bdroot,'FastRestart'),'on')
        set_param(bdroot,'FastRestart','off');
    end
    close_system('CruiseControl_harness_FullCov_SLDV',0);
catch
end
try
    delete(which('CruiseControl_harness_FullCov_SLDV'));
catch
end
sldvmergeharness('CruiseControl_harness_FullCov_SLDV', ...
    {'CruiseControl_Harness_SB',...
    '.\sldv_output\CruiseControl\CruiseControl_harness_SLDV'});
% sldvmergeharness('CruiseControl_harness_FullCov_SLDV', ...
%     {'CruiseControl_Harness_SB',...
%     '.\sldv_output\CruiseControl\CruiseControl_harness_SLDV'}); 
%  -- disable assertions, no expected outputs for SLDV test cases
%  -- "Run all" to show 100% coverage results

%% Run merged harness to show 100% model coverage

%% Equivalence Test
%  -- Put harness model ref in SIL mode
%  -- Open code coverage report

%% close
bdclose all
clear all

%% ========================================================================
%       SIL Testing
%       -- use the Test Mgr to automate code testing
%       -- reuses harness from functional testing
%       -- relies on 100% model coverage test vectors
%  ========================================================================
%% open Cruise Control model and harness for SIL testing
bdclose all
clear all
open_system('CruiseControl_SIL.slx');
sltest.harness.open('CruiseControl_SIL','CruiseControl_Harness_SB_SLDV_SIL');
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
%      "CoastSetSw" and "AccelResSw" (top to bottom) run to show Tspeed increase
%  6)  Notice that (0.4) the "tspeed" increases with a "CoastSetSw" input
%  7)  Single step to show path through "sneak path" at (0.4) in the state
%      chart
%% Using the sneak path fix
CtrlsVer = CtrlsVerEnum.CtrlD_ExecOrderSneak_fix;
%%  8)  Run the model again to show the "tspeed" no longer increases
%%  Re-run property proving on the model with the sneak fix (optional)
%  9)  Go back to CruiseControl_pp. Check that the Controls block is using 
%      "CtrlD_ExecOrderSneak_fix" version (it should be if it was set in
%      the harness)
%  10) Re-run "Analysis/Design Verifier/Prove Properties/Model" ==> Valid!!
%%  Show eml version of field issue behavior (optional)
%  11)  Show eml version: "CoastSet pulse (eml) with tspeed decrease"
Prop2Prove = PropEnum.Prop_coast_pulse_eml;
%  12) Run again to show eml version of property (field issue behavior) model
%
%%  Option #2 -  With fix, check a "requirement" property
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
%  5)  Notice that (0.3) the "tspeed" increases with a "CoastSetSw" input,
%      but this time, the "AccelResSw" is also high.  So this is a double
%      press input that our design (and req) is not handling.
%% Using the "Double Press Reject" fix
%  6)  Select fix in pp harness
CtrlsVer = CtrlsVerEnum.CtrlE_ExecOrderSneakDblReject_fix;  
%  7)  Run the model again to show the "tspeed" no longer increases
%%  Re-run property proving on the model with the "Double reject sneak fix" 
%  8)  Go back to CruiseControl_pp. Check that the Controls block is using 
%      "CtrlE_ExecOrderSneakDblReject_fix" version (it should be if it was set in
%      the harness)
%  9)  Re-run "Analysis/Design Verifier/Prove Properties/Model" ==> Valid!!
%      Highlight iterative workflow with each behvioral model indentifty an
%      issue, fixed with generated test case and then proven valid
%
%%  Option #3 -  With fix, check all parameter ranges on the "requirement" 
%                property (optional)
% -------------------------------------------------------------------------
%  1) Select "CoastSet pulse with tspeed decrease" property
%     --  Use a "requirement" property
%     --  Let all inputs "float"
%  2) For the Controls block, select version "CtrlE_ExecOrderSneakDblReject_fix"
D3_PP_ReqWithParsProve;
%% Configure parameter table
%  3) Open SLDV Options, navigate to parameter table: Use "Find in Model",
%     Enable only the "holdrate" and "incdec", use full range
%  4) Run "Design Verifier-->Prove Properties-->Model"
%% Debugging the requirements propety issue with parameter range
%  5)  Double-click "Open Harness" to open a partially configured harness
%      to begin debugging.  SDI should be pre-configured from before.
%  6)  Notice that the "tspeed" decreases below the min speed limit.
%      The analysis selected an "incdec" value of (2).  The tspeed decrement
%      function has no limit check.
%% Using the "All" fix, that includes the 
%  7)  Select fix in pp harness == will not work harness does not support
%      model reference when parameters are modified!!
%      Manually add the limit check:  
%      a) tspeed = min(tspeed + incdec,maxtspeed) for Accel state
%      b) tspeed = max(tspeed - incdec,mintspeed) for Coast state
%CtrlsVer = CtrlsVerEnum.CtrlH_All_fix;  
%  8)  Run the model again to show the "tspeed" no longer increases
%%  Re-run property proving on the model with the CtrlH_All_fix" 
%  9)  Go back to CruiseControl_pp. Configure the Controls block to use 
%      "CtrlH_All_fix" version 
%  10) Re-run "Analysis/Design Verifier/Prove Properties/Model" ==> Valid!!
%      Highlight iterative workflow with each behvioral model indentifty an
%      issue, fixed with generated test case and then proven valid
%
%% open SL Test - re-run verification to show all pass after pp changes
bdclose all;
p = slproject.getCurrentProject;
copyfile(fullfile(p.RootFolder,'Models','CruiseControl_SLT_2.slx'), ...
    fullfile(p.RootFolder,'Models','CruiseControl.slx'));
sltest.testmanager.load('CruiseControlTests_SLT_MC.mldatx');
sltest.testmanager.view;
%% close
bdclose all
%