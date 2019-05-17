%% ========================================================================
%       Open "More" Test File in Test Manager - Short Test Plan
%  ========================================================================
%%  Register test adapters to support "more" test file
%sltest.testmanager.registerTestAdapter('XLSadaptor',true);
%sltest.testmanager.registerTestAdapter('sigEditorBlkAdapter',true);
%sltest.testmanager.registerTestAdapter('testSeqAdapter',true);
%%  Open test file with "more" extensions
sltest.testmanager.load('CruiseControlTests_More.mldatx');
sltest.testmanager.view;