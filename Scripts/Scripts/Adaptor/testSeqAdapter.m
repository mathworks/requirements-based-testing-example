function  testSeqAdapter( testCase, ~ )
% TESTSEQADAPTER imports a variant test sequence block into the Test Mgr

    % get model and harness info
    
    modelName = testCase.getProperty('Model');    
    harnessName = testCase.getProperty('HarnessName');  

    % open model
       
    closeModel = false;
    if ~bdIsLoaded(modelName)
        open_system(modelName);
        closeModel = true;
    end

    % get variant test sequence block
    
    [testSeqBlk] = getTestSeqBlk(modelName, harnessName);
    
    % get variant workspace parameter
    
    testSeqIterName = multiTestSeqBlkMgr(testSeqBlk,'getTestSeqIterWSName');
    
    % get test case names
    
    testCaseBlks = multiTestSeqBlkMgr(testSeqBlk,'getTestCaseBlocks');
    tcNames = get_param(testCaseBlks,'Name');
  
    % clear existing test case
    
    clearTestCase(testCase);
        
    % create test iterations
    
    for tcNum = 1:numel(tcNames)

        iteration = sltest.testmanager.TestIteration;
        
        % set value of test iteration in model workspace
        
        setVariable(iteration, 'Name', testSeqIterName, ...
            'Source', 'base workspace',...
            'Value', tcNum);
        
        iteration = addIteration(testCase, iteration, ...
            ['case_' num2str(tcNum,'%02d') '_' tcNames{tcNum}]);
        iteration.update();

    end

    % cleanup
    
    if closeModel
        close_system(modelName,0);
    end
    
end

    
%%-------------------------------------------------------------------------
function [testSeqBlk] = getTestSeqBlk(modelName, harnessName)

    if ~isempty(harnessName)
        harnessInfo = sltest.harness.find(modelName,'OpenOnly','on');
        if ~isempty(harnessInfo)
            sltest.harness.close(modelName);
        end
        harnessInfo = sltest.harness.find(modelName,'Name',harnessName);
        if isempty(harnessInfo)
            return;
        end
        sltest.harness.open(harnessInfo.ownerFullPath,harnessName);
        topModelName = harnessName;
    else
        topModelName = modelName;
    end
    
    testSeqBlk = char(find_system(topModelName,'SearchDepth',1, ...
        'Tag','multiTestSeqBlk'));

    % restore view to top model
    
    open_system(topModelName);
    
end


%%-------------------------------------------------------------------------
function clearTestCase(testCase)

    % delete all iterations
    iter2remove = testCase.getIterations;
    if ~isempty(iter2remove)
        testCase.deleteIterations(iter2remove);
    end
    
    testCase.setProperty('FastRestart',false);

end
