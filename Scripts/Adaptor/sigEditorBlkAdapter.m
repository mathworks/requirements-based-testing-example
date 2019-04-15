function  sigEditorBlkAdapter( testCase, ~ )
% SIGEDITORBLKADAPTER imports a signal editor block into the Test Mgr

    % get model and harness info
    
    modelName = testCase.getProperty('Model');    
    harnessName = testCase.getProperty('HarnessName');  

    % open model
       
    closeModel = false;
    if ~bdIsLoaded(modelName)
        open_system(modelName);
        closeModel = true;
    end

    % get signal editor block and associated .mat file name
    
    [sigEditorBlk] = getSigEditorBlk(modelName,harnessName);
    inputFileName = which(get_param(sigEditorBlk,'FileName'));
    if isempty(inputFileName)
        return;
    end
    
    % get test case names

    [tcNames] = who('-file',inputFileName);
    if isempty(tcNames)
        return;
    end
  
    % clear existing test case
    
    clearTestCase(testCase);
        
    % create test iterations
    
    for tcNum = 1:numel(tcNames)

        iteration = sltest.testmanager.TestIteration;
        iteration = addIteration(testCase, iteration, ...
            ['case_' num2str(tcNum,'%02d') '_' tcNames{tcNum}]);
        iteration.update();

    end

    % set active scenario in postload callback
    
    testCase.setProperty('PostloadCallback',...
        ['set_param(''' sigEditorBlk ...
        ''',''ActiveScenario'',sltest_iterationName);']); 

    % cleanup
    
    if closeModel
        close_system(modelName,0);
    end
    
end

    
%%-------------------------------------------------------------------------
function [sigEditorBlk] = getSigEditorBlk(modelName,harnessName)

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

    sigEditorBlk = char(find_system(topModelName,'SearchDepth',1, ...
        'MaskType','SignalEditor'));

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
