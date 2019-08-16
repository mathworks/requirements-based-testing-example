function shutdownProject
% Clean up the environment for the current project.

%% Reset location of slprj
Simulink.fileGenControl('reset');

%% Reset Simulation Data Inspector naming rule
Simulink.sdi.setRunNamingRule('Run <run_index>: <model_name>');
%%
clear
clc