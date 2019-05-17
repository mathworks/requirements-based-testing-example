function sl_customization(cm)
% SL_CUSTOMIZATION - Model Advisor customization demonstration.

% Copyright 2005 The MathWorks, Inc.

% register custom process callback
cm.addModelAdvisorProcessFcn(@ModelAdvisorProcessFunction);

function [checkCellArray taskCellArray] = ModelAdvisorProcessFunction ...
 (stage, system, checkCellArray, taskCellArray) 

    switch stage 
        case 'configure' 
            ModelAdvisor.setConfiguration('defaultMdlAdvChecks.mat'); 
    end
    
end
