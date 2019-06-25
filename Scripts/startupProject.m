function startupProject
% Setup the environment for this project.

    %% Get current project folder
    p = simulinkproject;
    pRoot = p.RootFolder;

    %% Add workshop paths
    addpath(genpath(fullfile(pRoot, 'Models')));
    addpath(fullfile(pRoot, 'Tests'));
    addpath(fullfile(pRoot, 'Scripts'));
    addpath(fullfile(pRoot, 'Scripts', 'WindowFcns'));
    addpath(fullfile(pRoot, 'Scripts', 'SLDV'));


    %% Set location of slprj to be "Work" folder of current project:
    workFolder = fullfile(pRoot, 'Work');
    if ~exist(workFolder, 'dir')
        mkdir(workFolder);
    end

    % Add work folder to path
    addpath(workFolder);

    % Change into work folder 
    cd(workFolder);

    % clear workspace
    clear
    
    % clear command window
    clc

    %% open instructions
    %openInstructions
    edit Instructions.mlx

end