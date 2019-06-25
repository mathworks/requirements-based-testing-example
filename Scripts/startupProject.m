function startupProject
% Setup the environment for this project.

    %% Get current project folder
    p = simulinkproject;
    pRoot = p.RootFolder;

    %% Add workshop paths
    addpath(genpath(fullfile(pRoot, 'Models')));
    addpath(fullfile(pRoot, 'Tests'));
    addpath(fullfile(pRoot, 'Scripts'));

     % clear workspace
    clear
    
    % clear command window
    clc

    %% open instructions
    edit Instructions.mlx

end