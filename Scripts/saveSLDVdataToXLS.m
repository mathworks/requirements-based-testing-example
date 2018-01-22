function saveSLDVdataToXLS(fullFilePath)

load(fullFilePath);
[~, name, ~] = fileparts(fullFilePath);

numInputs = length(sldvData.AnalysisInformation.InputPortInfo);
numOutputs = length(sldvData.AnalysisInformation.OutputPortInfo);

% get the signal names
sigNames = cell(1,numInputs+numOutputs+1);
sigNames{1} = 'Time';
for ndx=2:numInputs+1
    sigNames{ndx} = sldvData.AnalysisInformation.InputPortInfo{ndx-1}.SignalName;
end
for ndx=numInputs+2:numInputs+1+numOutputs
    sigNames{ndx} = ['Exp_' sldvData.AnalysisInformation.OutputPortInfo{ndx-numInputs-1}.SignalName];
end

% scan through test cases and save each test to a worksheet
for testNdx=1:length(sldvData.TestCases)
    
    testCase = sldvData.TestCases(testNdx);
        
    dupTime = length(testCase.timeValues)-1;
    sheetData = zeros(dupTime*2+2,numInputs+numOutputs+1);
    
    sheetData(1,1) = testCase.timeValues(1);
    x = [testCase.timeValues(2:end); testCase.timeValues(2:end)];
    sheetData(2:end-1,1) = reshape(x,[dupTime*2 1]);  
    
    timeInc = testCase.timeValues(2)-testCase.timeValues(1);
    sheetData(end,1) = testCase.timeValues(end) + timeInc;  
    
    
    for ndx = 1:numInputs
        y = double(testCase.dataValues{ndx});
        z = [y; y];
        sheetData(:,1+ndx) = reshape(z,[dupTime*2+2 1]);
    end
    
    % check to see if exp outputs were created, else they'll be zeros
    if isfield(testCase,'expectedOutput')  
        for ndx = 1:numOutputs
            y = double(testCase.expectedOutput{ndx});
            z = [y; y];
            sheetData(:,1+numInputs+ndx) = reshape(z,[dupTime*2+2 1]);
        end
    end
    
    % create final cell data array for exporting to Excel
    sheetCellData = [[sigNames {'valid'}]; num2cell( ...
        [[sheetData; sheetData(end,:)] [ones(size(sheetData,1),1); 0]]) ];
    
    xlswrite(fullfile(pwd,[name '.xlsx']), ...
        sheetCellData, ...
        ['Test_' num2str(testNdx) '_SLDV']);
  
end