function [ success ] = convertSLDV2mat( datFileSLDV )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    [path, fName] = fileparts(datFileSLDV);
    load(datFileSLDV);
    
    % get signal names
    port = [sldvData.AnalysisInformation.InputPortInfo{:}];
    sigNames = {port.SignalName};
        
    tc = sldvData.TestCases;

    for i=1:numel(tc)

        SLDVtestcase = Simulink.SimulationData.Dataset;
        SLDVtestcase.Name = ['SLDV_' num2str(i)];
        
        time = tc(i).timeValues;
        
        for j=1:numel(sigNames)
            
            element = timeseries;
            element.Name = sigNames{j};
            element.Time = time;
            element.Data = tc(i).dataValues{j}';
 
            SLDVtestcase = SLDVtestcase.addElement(element);

        end
        
        save(fullfile(path,[fName '_test_' num2str(i,'%02d')]),'SLDVtestcase');

    end

end