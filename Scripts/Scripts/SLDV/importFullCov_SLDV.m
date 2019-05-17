function importFullCov_SLDV(testCase)

    % get sldv data file (full path)
    sldvDataFileName = evalin('base','sldvDataFileName');
    [path,fName] = fileparts(sldvDataFileName);
      
    % find all test case .mat files
    testCaseFiles = dir([path filesep fName '_test_*.mat']);
    testCaseFiles = {testCaseFiles.name}; 
    
    numSteps = length(testCaseFiles);
 
    % add test inputs to testCase
    for k = 1 : numSteps
        
        for simNdx=1:2
            testInput = testCase.addInput(fullfile(path,testCaseFiles{k}), simNdx); 
            testInput.map(0);
        end
         
    end


end
