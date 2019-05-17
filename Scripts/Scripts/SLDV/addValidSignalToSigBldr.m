function [ output_args ] = addValidSignalToSigBldr( varargin )
% Adds a "valid" signal to know when to check outputs

    if nargin >= 1
        block = varargin{1};
    else
        block = gcb;
    end
    
    [time, ~, ~, groupnames] = signalbuilder(block);
    if numel(groupnames) == 0
        return;
    end
    
    signalbuilder(block, 'activegroup', 1);
    sigTime = time{end,1};
    signalbuilder(block,'appendsignal', [sigTime(1) sigTime(end)], [1 1], 'valid');
    
    for i=2:numel(groupnames)
        
        % set active group
        %signalbuilder(block, 'activegroup', i);
        
        sigTime = time{end,i};
        timeValid = [sigTime(1) sigTime(end)];
        
        signalbuilder(block, 'set', 'valid', i, timeValid, [1 1]); 
        signalbuilder(block, 'showsignal', 'valid', i);
        
    end

end

