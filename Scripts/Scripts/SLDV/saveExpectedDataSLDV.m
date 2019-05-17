clear sheetData sldvData

load('.\sldv_output\CruiseControl_Coverage\CruiseControl_Coverage_sldvdata.mat');
sldv_harness = sldvmakeharness('CruiseControl_Coverage', sldvData);
[path, harnessName, ext] = fileparts(sldv_harness);

sheetText = {'Time', 'CruiseOnOff', 'Brake', 'Speed', 'CoastSetSw', 'AccelResSw', ...
    'Exp_engaged', 'Exp_tspeed'};

CruiseControl_dd;

for i = 1 : length(sldvData.TestCases)
    
    inData = sldvlogsignals(harnessName, i);
    outData = slvnvruntest('CruiseControl_Coverage', inData);
    
    sheetData(:,1) = inData.TestCases.timeValues';
    for j = 1 : length(inData.TestCases.dataValues)
        sheetData(:,1+j) = double(inData.TestCases.dataValues{j})';
    end
    
    [Exp_engaged, Exp_tspeed] = outData.get('yout_slvnvruntest').signals.values;
    sheetData = [sheetData double(Exp_engaged) double(Exp_tspeed)];
        
    A = [sheetText; num2cell(sheetData)];
    
    xlswrite('CruiseControl_Coverage_SLDV_NEW.xlsx', A, ['Test_' num2str(i) '_SLDV']);
    clear sheetData
    
end
