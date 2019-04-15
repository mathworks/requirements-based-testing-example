function setMetricsDashCfg(varargin)
% SETMETRICSDASHCFG configures the Metrics Dashboard to use model advisor 
%   checks for Auto 

    if nargin>0
        switch varargin{1}
            case 'IEC61508'
                stdGrp = '_SYSTEM_By Task_IEC61508:Group';
                stdLabel = 'IEC 61508';
            case 'ISO26262'
                stdGrp = '_SYSTEM_By Task_ISO26262';
                stdLabel = 'ISO 26262';
            case 'IEC62304'
                stdGrp = '_SYSTEM_By Task_IEC62304:Group';
                stdLabel = 'IEC 62304';
            case 'EN50128'
                stdGrp = '_SYSTEM_By Task_EN50128';
                stdLabel = 'EN 50128';
            case 'DO178'
                stdGrp = '_SYSTEM_By Task_do178';
                stdLabel = 'DO 178';
            otherwise
                stdGrp = '_SYSTEM_By Task_ISO26262';
                stdLabel = 'ISO 26262';
        end                
    else
        stdGrp = '_SYSTEM_By Task_ISO26262';
        stdLabel = 'ISO 26262';
    end

    %
    %   metrics configuration
    %
    
    % reset to default configuration (common starting point)
    
    slmetric.dashboard.setActiveConfiguration('');
    slmetric.config.setActiveConfiguration('');

    % open the default metrics configuration
    
    metricCfg = slmetric.config.Configuration.open();
    
    % specify metric family parameter ID and the metric family parameter values
    %   --  to obtain value open the Mdl Adv Configuration Editor to see the
    %       Check Group ID parameter in the folder description pane
    %   --  config will include MAAB, ISO 26262 and MISRA-C checks
    
    famParamID = 'ModelAdvisorStandard';
    values = {stdGrp, '_SYSTEM_By Task_maab', '_SYSTEM_By Task_misra_c'};
    setMetricFamilyParameterValues(metricCfg, famParamID, values); 
    
    % save new metrics config
    
    metricCfg.save('FileName', 'MetricConfigAuto.xml');
    
    % set active Metrics Dashboard config
    
    slmetric.config.setActiveConfiguration( ...
        fullfile(pwd, 'MetricConfigAuto.xml'));
    
    %
    %   layout configuration
    %
    
    % open default cfg for Metrics Dashboard layout
    
    dashCfg = slmetric.dashboard.Configuration.open();
    
    % get layout object 
    
    layout = getDashboardLayout(dashCfg);
    
    % get widget objects from layout object
    
    layoutWidget = getWidgets(layout);
    
    % get compliance widget group (#3)
    
    compGrp = layoutWidget(3);
    compContainers = getWidgets(compGrp);
    compContWidgets = getWidgets(compContainers(1));
    
    % reassign High Integrity widget to "stdGrp"
    
    setMetricIDs(compContWidgets(1),...
        ({['mathworks.metrics.ModelAdvisorCheckCompliance.' stdGrp]}));
    compContWidgets(1).Labels={stdLabel};
    compContWidgets(1).Title=(stdLabel);
    
    % add widget for MISRA C 
    
    misraWidget = compContainers(1).addWidget('Custom', 3); 
    misraWidget.Title=('MISRA C'); 
    misraWidget.VisualizationType = 'RadialGauge'; 
    misraWidget.setMetricIDs...
        ('mathworks.metrics.ModelAdvisorCheckCompliance._SYSTEM_By Task_misra_c'); 
   % misraWidget.setWidths(slmetric.dashboard.Width.Medium);
    
    setMetricIDs(compContWidgets(2),...
        ({'mathworks.metrics.ModelAdvisorCheckCompliance._SYSTEM_By Task_maab'}));
    
    % reassign bar chart widget to "stdGrp"
    
    % compContainers(1).removeWidget(compContWidgets(3)); 
    
    setMetricIDs(compContWidgets(3),...
    ({  ['mathworks.metrics.ModelAdvisorCheckIssues.' stdGrp], ...
        'mathworks.metrics.ModelAdvisorCheckIssues._SYSTEM_By Task_maab', ...
        'mathworks.metrics.ModelAdvisorCheckIssues._SYSTEM_By Task_misra_c' ...
        }));
    compContWidgets(3).Labels = {stdLabel, 'MAAB', 'MISRA C'};
                
    % save new dashboard layout config

    dashCfg.save('Filename', 'DashboardConfigAuto.xml');
    
    % set active dashboard layout config

    slmetric.dashboard.setActiveConfiguration(...
        fullfile(pwd, 'DashboardConfigAuto.xml'));

    
end

