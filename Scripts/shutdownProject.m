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

%% Remove data type specific paths for this project
S = load('fuelsys_datatypeID.mat', 'fuelsys_datatypeID');
if (S.fuelsys_datatypeID == 1)
    rmpath(fullfile(pRoot, 'Models', 'Step_05', 'artifacts', 'fxp16'));
    rmpath(fullfile(pRoot, 'Models', 'Step_07', 'fxp16'));
else
    rmpath(fullfile(pRoot, 'Models', 'Step_05', 'artifacts', 'single'));
    rmpath(fullfile(pRoot, 'Models', 'Step_07', 'single'));
end
clear S

%% Remove common paths for this project
rmpath(fullfile(pRoot, 'Models'));
rmpath(fullfile(pRoot, 'Tests'));
rmpath(fullfile(pRoot, 'Scripts'));
rmpath(fullfile(pRoot, 'Work'));

%%