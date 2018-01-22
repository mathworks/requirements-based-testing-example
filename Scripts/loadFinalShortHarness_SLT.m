%% ========================================================================
%       Requirements Based Functional Testing - SL Test Short Final
%  ========================================================================
%% close Short and open ShortFinal system harness 
try
sltest.harness.close('CruiseControl','CruiseControl_Harness_Short');
end
sltest.harness.open('CruiseControl','CruiseControl_Harness_ShortFinal');
