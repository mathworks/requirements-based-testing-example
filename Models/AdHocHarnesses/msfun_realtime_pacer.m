function msfun_realtime_pacer(block)
% Realtime pacer MATLAB S-Function Block

% Copyright 2009, The MathWorks, Inc.

% instance variables 
mySimTimePerRealTime = 1;
myRealTimeBaseline = 0;
mySimulationTimeBaseline = 0;
myResetBaseline = true;
myTotalBurnedTime = 0;
myNumUpdates = 0;

setup(block);

%% ---------------------------------------------------
    function setup(block)
        % Register the parameters.
        block.NumDialogPrms     = 2; % scale factor, over-run output
        block.DialogPrmsTunable = {'Nontunable' 'Nontunable'};
        
       % Register the number of ports.
        block.NumInputPorts  = 0;
       % setOutputPorts(block);
        
        % Set up the states
        block.NumContStates = 0;
        block.NumDworks = 0;
               
        % Block is fixed in minor time step, i.e., it is only executed on major
        % time steps. With a fixed-step solver, the block runs at the fastest
        % discrete rate.
        block.SampleTimes = [0 1];
        
        block.SetAccelRunOnTLC(false); % run block in interpreted mode even w/ Acceleration
        
        % methods called during update diagram/compilation.
        block.RegBlockMethod('CheckParameters', @CheckPrms);
                
        % methods called at run-time
        block.RegBlockMethod('Start', @Start);
        block.RegBlockMethod('Update', @Update);
        block.RegBlockMethod('SimStatusChange', @SimStatusChange);
        block.RegBlockMethod('Terminate', @Terminate);
    end

%%
    function CheckPrms(block)
        try
            validateattributes(block.DialogPrm(1).Data, {'double'},{'real', 'scalar', '>', 0});

        catch %#ok<CTCH>
            throw(MSLException(block.BlockHandle, ...
                'Simulink:Parameters:BlkParamUndefined', ...
                'Enter a "Scale Factor" greater than 0'));
            return; %#ok<UNRCH>
            
        end        
        
        try
            validateattributes(block.DialogPrm(2).Data, {'double'},{'real', 'scalar', '>=', 0, '<=', 1});

        catch %#ok<CTCH>
            throw(MSLException(block.BlockHandle, ...
                'Simulink:Parameters:BlkParamUndefined', ...
                'Enter a "Output Over-run" greater than or equal to 0'));
            return; %#ok<UNRCH>
        end        
        
        setOutputPorts(block);
        
    end

%%
    function setOutputPorts(block)
        
        overRunOutput = (block.DialogPrm(2).Data > 0);
        % Register the number of ports.
        if ~overRunOutput
            block.NumOutputPorts = 0;
        else
            block.NumOutputPorts = 1;
            block.OutputPort(1).DatatypeID = 8; % boolean
            block.OutputPort(1).Dimensions = 1;
            block.OutputPort(1).SamplingMode = 'Sample';
        end

    end
        
%%        
    function Start(block) 
        mySimTimePerRealTime = block.DialogPrm(1).Data;
        myTotalBurnedTime = 0;
        myNumUpdates = 0;
        myResetBaseline = true;
        if strcmp(pause('query'),'off')
            fprintf('%s: Enabling MATLAB PAUSE command\n', getfullname(block.BlockHandle));            
            pause('on');            
        end            
    end
        
%%        
    function Update(block)        
        if  myResetBaseline 
            myRealTimeBaseline = tic;  
            mySimulationTimeBaseline = block.CurrentTime;  
            myResetBaseline = false; 
        else
            if isinf(mySimTimePerRealTime)
                return;
            end            
            elapsedRealTime = toc(myRealTimeBaseline);
            differenceInSeconds = ((block.CurrentTime - mySimulationTimeBaseline) / mySimTimePerRealTime) - elapsedRealTime;
            overRun = (differenceInSeconds < 0);
            if ~overRun
                pause(differenceInSeconds);
                myTotalBurnedTime = myTotalBurnedTime + differenceInSeconds;
                myNumUpdates = myNumUpdates + 1;
            end
            if block.NumOutputPorts>0
                block.OutputPort(1).Data = overRun;
            end
        end            
    end
        
%%        
    function SimStatusChange(block, status)        
        if status == 0, 
            % simulation paused
            fprintf('%s: Pausing real time execution of the model (simulation time = %g sec)\n', ...
                getfullname(block.BlockHandle), block.CurrentTime);
        elseif status == 1
            % Simulation resumed
            fprintf('%s: Continuing real time execution of the model\n', ...
                getfullname(block.BlockHandle));
            myResetBaseline = true; 
        end        
    end
        
%%
    function Terminate(block) 
        if myNumUpdates > 0
            fprintf('%s: Average idle real time per major time step = %g sec\n', ...
                getfullname(block.BlockHandle),  myTotalBurnedTime / myNumUpdates);
        end
    end

end
