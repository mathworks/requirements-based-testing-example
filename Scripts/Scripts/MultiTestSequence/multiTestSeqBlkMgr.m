function varargout = multiTestSeqBlkMgr(testSeqBlk,action,varargin)

    switch action
        
        case 'create'
            
            % copies selected block into variant subsystem

            if nargin<3
                return;
            end
            
            srcBlk = varargin{1};
            if strcmp(srcBlk,testSeqBlk)
                return;
            end
            
            srcBlk = char(varargin{2});
            dstName = get_param(srcBlk,'Name');
            dstBlk = [testSeqBlk '/' dstName];
            try
                add_block(srcBlk,dstBlk);
            catch
                errordlg(['Unable to copy selected block "' dstName ...
                    '" into the Multi Test Sequence subsystem']) 
            end
            
            % create initial exec order       
            multiTestSeqBlkMgr(testSeqBlk,'updateExecOrder', ...
                {dstName}, dstBlk);
            
        
        case 'load'
            
%             % load fcn for the testSeqBlk
%             multiTestSeqBlks = find_system(bdroot,'SearchDepth',1, ...
%                 'Tag','multiTestSeqBlk');
%             
%             for i=1:numel(multiTestSeqBlks)
%                 
%                 testSeqBlk = char(multiTestSeqBlks(i));
                
                testSeqIterName = multiTestSeqBlkMgr(testSeqBlk, ...
                    'getTestSeqIterWSName');
            
                % set current iteration to last selected test case
                testSeqIterNum = get_param(testSeqBlk,'testSeqIter');
                if ~isempty(testSeqIterNum)
                    evalin('base',[testSeqIterName ' = ' testSeqIterNum ';']);
                else
                    evalin('base',[testSeqIterName ' = 1;']);
                    set_param(testSeqBlk,'testSeqIter','1');
                end
                
%             end
 
            
        case 'updatePorts'

            % updates the variant subsystem ports to match the test
            % sequence block port I/O
            
            testCaseBlks = multiTestSeqBlkMgr(testSeqBlk,'getTestCaseBlocks');
            testCaseBlkNames = get_param(testCaseBlks,'Name');

            % check all test sequences have the same port I/O
            
            port = struct('blkName', testCaseBlkNames, 'blkPath', [], ...
                'inputNames', [], 'outputNames', []);
            [port.blkPath] = testCaseBlks{:};
            
            blks = cellfun(@(x) find_system(x, ...
                    'LookUnderMasks','all','Variants','all', ...
                    'BlockType','Inport'), {port.blkPath}, ...
                    'UniformOutput',false);
            names = cellfun(@(x) get_param(x,'Name'), blks, ...
                'UniformOutput', false);
            [port.inputNames] = names{:};
                
            blks = cellfun(@(x) find_system(x, ...
                    'LookUnderMasks','all','Variants','all', ...
                    'BlockType','Outport'), {port.blkPath}, ...
                    'UniformOutput',false);
            names = cellfun(@(x) get_param(x,'Name'), blks, ...
                'UniformOutput', false);
            [port.outputNames] = names{:};
            
            % find bins where port name lists are the same
            
            availSets = true(numel(port),1);
            i = 1;
            while ~isempty(find(availSets,1))
                diffs = arrayfun(@(x) setdiff(port(1).inputNames,port(x).inputNames), ...
                    availSets,'UniformOutput',false);
                bin(i) = {cellfun(@(x) isempty(x), diffs)}; %#ok<AGROW>
                availSets = (~bin(i)) & availSets;
                i = i + 1;
            end
            
            
        case 'copyTest'    
            
            % called by multTestCaseSeq UI app:
            %   add the block not found in existing block list
            
            if nargin<4
                return;
            end
            
            % get current active variant
            activeVariantBlock = multiTestSeqBlkMgr(testSeqBlk, ...
                'getActiveVariantBlock');
                        
            % create/get UI list and existing block list
            
            testCaseListNames = varargin{1};
            testCaseBlks = multiTestSeqBlkMgr(testSeqBlk,'getTestCaseBlocks');
            testCaseBlkNames = get_param(testCaseBlks,'Name');

            % add blocks not found in existing block list

            ndxAdd = find(~ismember(testCaseListNames,testCaseBlkNames));
            if numel(ndxAdd) == 1       % only allow (1) at most
                srcBlk = [testSeqBlk '/' char(varargin{2})];
                dstBlk = [testSeqBlk '/' char(testCaseListNames(ndxAdd))];
                add_block(srcBlk,dstBlk);
            elseif numel(ndxAdd) > 1
                errordlg(['Copy Test:  More than one block from UI list not '...
                    'found in the Multi Test Sequence subsystem. ' newline ...
                    'Reload UI from block.']); 
                return;
            end
            
            % update test execution order
            multiTestSeqBlkMgr(testSeqBlk,'updateExecOrder', ...
                testCaseListNames, activeVariantBlock);
            
        case 'renameTest'
            
            % called by multTestCaseSeq UI app:
            %   rename test sequence block 
            
            if nargin<4
                return;
            end
            
            oldTestName = varargin{1};
            newTestName = varargin{2};
            
            % check test sequence block exists
            
            testCaseBlks = multiTestSeqBlkMgr(testSeqBlk,'getTestCaseBlocks');
            testCaseBlkNames = get_param(testCaseBlks,'Name');

            if isempty(find(strcmp(oldTestName,testCaseBlkNames),1))
                errordlg(['Rename Test:  Block "' oldTestName ...
                    '" was not found in the Multi Test Sequence subsystem']); 
                return;
            end

            % rename block
            
            srcBlk = [testSeqBlk '/' oldTestName];
            set_param(srcBlk,'Name',newTestName);
            

        case 'deleteTest'
            
            % called by multTestCaseSeq UI app:
            %       deletes blocks not in UI test case list
            
            if nargin<3
                return;
            end
            
            % get current active variant
            activeVariantBlock = multiTestSeqBlkMgr(testSeqBlk, ...
                'getActiveVariantBlock');

            % create/get UI list and existing block list
            testCaseListNames = varargin{1};
            testCaseBlks = multiTestSeqBlkMgr(testSeqBlk,'getTestCaseBlocks');
            testCaseBlkNames = get_param(testCaseBlks,'Name');
            
            % delete blocks not found in UI list
            ndxDelete = find(~ismember(testCaseBlkNames,testCaseListNames));
            if numel(ndxDelete) == 1    % only allow (1) at most
                delete_block(testCaseBlks{ndxDelete});
            elseif numel(ndxDelete) > 1
                errordlg(['Delete Test:  More than one block in the Multi Test Sequence subsystem ' ...
                    'not found in UI list.' newline ...
                    'Reload UI from block.']); 
                return;

            end
            
            % update test execution order
            multiTestSeqBlkMgr(testSeqBlk,'updateExecOrder', ...
                testCaseListNames, activeVariantBlock);
            
            
        case 'getTestSeqIterWSName'
            
            % get workspace iter var name based on test seq name
            
            testSeqIter = regexprep(get_param(testSeqBlk,'Name'),' ','_');
            varargout{1} = [testSeqIter '_Iter';];

            
        case 'updateExecOrder'
            
            % called by multTestCaseSeq UI app:
            %       updates "tag" order of variant test seq blocks to 
            %       match UI test case list
            
            if nargin<3
                return;
            end

            testSeqIterName = multiTestSeqBlkMgr(testSeqBlk, ...
                'getTestSeqIterWSName');
            
            testCaseListNames = varargin{1};
            if isempty(testCaseListNames)
                evalin('base',[testSeqIterName ' = 1;']);
                set_param(testSeqBlk,'testSeqIter','1');
                return;
            end

            if nargin==4
                activeVariantBlock = varargin{2};
            else
                % get current active variant
                activeVariantBlock = char(multiTestSeqBlkMgr(testSeqBlk, ...
                    'getActiveVariantBlock'));
            end
            
            % update variant control order
            testCaseBlks = cellfun(@(x) [testSeqBlk '/' x], testCaseListNames,...
                'UniformOutput',false)';
            arrayfun(@(x,y) set_param(char(x),'Tag',num2str(y), ...
                'VariantControl',[testSeqIterName ' == ' num2str(y)]), ...
                testCaseBlks, [1:numel(testCaseBlks)]');   

            % update variant signal in workspace to select active variant
            multiTestSeqBlkMgr(testSeqBlk,'setActiveVariantBlock', ...
                activeVariantBlock);
 
            
        case 'setActiveVariantBlock'
            
            if nargin<3
                return;
            end
                
            activeVariantBlock = varargin{1};
            testCaseBlks = multiTestSeqBlkMgr(testSeqBlk,'getTestCaseBlocks');
            
            % update variant signal in workspace to select active variant
            
            testSeqIterName = multiTestSeqBlkMgr(testSeqBlk, ...
                'getTestSeqIterWSName');

            if isempty(find(strcmp(activeVariantBlock,testCaseBlks),1))
                evalin('base',[testSeqIterName ' = 1;']);
                set_param(testSeqBlk,'testSeqIter','1');
            else
                testSeqIterNum = get_param(activeVariantBlock,'Tag');
                testSeqIterNum = char(testSeqIterNum);
                if ~isempty(testSeqIterNum)
                    evalin('base',[testSeqIterName ' = ' testSeqIterNum ';']);
                    set_param(testSeqBlk,'testSeqIter',testSeqIterNum);
                else
                    evalin('base',[testSeqIterName ' = 1;']);
                    set_param(testSeqBlk,'testSeqIter','1');
                end
            end
            

        case 'getActiveVariantBlock'
            
            testSeqIterName = multiTestSeqBlkMgr(testSeqBlk, ...
                'getTestSeqIterWSName');

            activeVariantBlock = find_system(testSeqBlk,...
                'LookUnderMasks','All','RegExp','on',...
                'VariantControl',['^' testSeqIterName]);
            
            varargout{1} = activeVariantBlock;
            
            
        case 'getTestCaseBlocks'
            
            % returns a "tag" ordered set of test case seq blocks
            
            testSeqIterName = multiTestSeqBlkMgr(testSeqBlk, ...
                'getTestSeqIterWSName');
            
            testCaseBlks = find_system(testSeqBlk, ...
                'LookUnderMasks','All','Variants','AllVariants', ...
                'RegExp','on','VariantControl',['^' testSeqIterName]);
            
            if ~isempty(testCaseBlks)
                
                % sort test case blocks based on "Tag" number
                testNum = get_param(testCaseBlks,'Tag');
                [~, ndx] = sort(testNum);
                testCaseBlks = testCaseBlks(ndx);
                
            end        
            
            varargout{1} = testCaseBlks;

            
    end
    
end