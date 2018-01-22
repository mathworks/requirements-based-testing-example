mdl = 'CruiseControl_pp_harness_ReqProve';

%% load field issue harness


load_system(mdl);
ctrlSub = '/Test Unit (copied from CruiseControl_pp)/Controls';
open_system([mdl ctrlSub]);
open_system([mdl '/Inputs']);
open_system(mdl,'window');

%% position windows

% create win functions object
if exist('hWF','var')
    if ~hWF.extLibLoaded
        clear hWF;
        hWF = WindowFcns;
    end
else
    hWF = WindowFcns;
end

% top model
hWF.setWinPosByName([mdl ' - Simulink'],0,0,720,600);
set_param(mdl,'ZoomFactor','250');
drawnow;

% signal builder
hWF.setWinPosByName(['Signal Builder (' mdl '/Inputs)'],0,500,720,700);
drawnow;

% chart
%ctrlChart = '/Test Unit (copied from CruiseControl_pp)/CtrlC_ExecOrder_fix (Controls) /Compute target speed';
ctrlChart = '/Test Unit (copied from CruiseControl_pp)/CtrlD_ExecOrderSneak_fix (Controls)';
hWF.setWinPosByName(['Link: ' mdl ctrlChart ' - Simulink'],720,0,1200,1080);
drawnow;

clear hWF;
clear mdl;