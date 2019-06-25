function shutdownProject
% Clean up the environment for the current project.

%% Change into project root directory
p = simulinkproject;
pRoot = p.RootFolder;
cd(pRoot)

%% Reset location of slprj
Simulink.fileGenControl('reset');

%% Reset Simulation Data Inspector naming rule
Simulink.sdi.setRunNamingRule('Run <run_index>: <model_name>');

%% Remove common paths for this project
rmpath(fullfile(pRoot, 'Models'));
rmpath(fullfile(pRoot, 'Tests'));
rmpath(fullfile(pRoot, 'Scripts'));

%%