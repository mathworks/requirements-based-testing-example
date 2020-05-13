function startupProject
    clear
    % clear command window
    clc
    % turn off all warnings
    warning('off','all')
    
    %% Open instructions
    edit Instructions.mlx

    %% Open GIF to show user how to widen Instructions.mlx
    file_name = 'Widen_Instructions_Window.gif';
    if ispc
        winopen(file_name);
    else
        system(['open ', file_name]); 
    end
    clear file_name
end