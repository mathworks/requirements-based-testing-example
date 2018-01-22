function load_PP_harness( mdl )


    %% load field issue harness

    open_system(mdl);
    open_system([mdl '/Inputs']);

    ctrlUUTBlk = [mdl '/Test Unit (copied from CruiseControl_pp)/Controls'];
    ctrlMdl = get_param(ctrlUUTBlk,'ModelName');
    ctrlMdlBlk = [ctrlMdl '/CruiseControl/Compute target speed'];
    load_system(ctrlMdl);
    open_system(ctrlMdlBlk);

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
    set_param(mdl,'ZoomFactor','175');
    drawnow;

    % signal builder
    hWF.setWinPosByName(['Signal Builder (' mdl '/Inputs)'],0,500,720,700);
    drawnow;

    % controls under test
    hWF.setWinPosByName(['Stateflow (chart) ' ctrlMdlBlk ' - Simulink'],720,0,1200,1080);
    set_param(ctrlMdlBlk,'ZoomFactor','FitSystem');
    drawnow;

    clear hWF;

end