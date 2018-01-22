function assertFailCB()
% assertFail CB - displays assert fail message to command window

    % get test # (ndx) and test name (groupName)
    [ndx, groupName] = signalbuilder([bdroot '/Harness Inputs'], ...
        'activegroup');

    % get simulation time
    simTime = get_param(bdroot,'SimulationTime');

    % get assert name
    assertName = get_param(gcb,'Name');

    % display assert fail to command window
    disp(['Test #' num2str(ndx) ':  ' groupName ' -- ' assertName ...
        ' failed at ' num2str(simTime,'%f')]);

end