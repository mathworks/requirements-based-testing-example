function shutdownProject
<<<<<<< HEAD
% Clean up the environment for the current project.

%% Reset location of slprj
Simulink.fileGenControl('reset');

%% Reset Simulation Data Inspector naming rule
Simulink.sdi.setRunNamingRule('Run <run_index>: <model_name>');
%% Clean things up
clear
clc
%% Re-enable warnings
warning('on','all')
=======

% Reset Simulation Data Inspector naming rule
Simulink.sdi.setRunNamingRule('Run <run_index>: <model_name>');
>>>>>>> 32add79a5a4a41abc9152e32cd20c964f4604706
