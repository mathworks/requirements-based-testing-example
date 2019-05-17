%% ========================================================================
%       Requirements Based Functional Testing
%  ========================================================================
%% close
bdclose all
clear all
%%  Copy Cruise Control version for test
if exist('CruiseControl_harness_SLDV.slx','file')
    delete(which('CruiseControl_harness_SLDV.slx'));
end
% open the model
open_system('CruiseControl_harness_w_Asserts.slx');