function openInstructions

if ~batchStartupOptionUsed
    %% Open instructions
    edit Instructions.mlx
    
    %% Open GIF to show user how to widen Instructions.mlx
    file_name = 'Widen_Instructions_Window.gif';
    if ispc
        winopen(file_name);
    else
        system(['open ', file_name]);
    end
end

end