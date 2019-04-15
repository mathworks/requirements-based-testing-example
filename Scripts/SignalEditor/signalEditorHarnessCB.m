function signalEditorHarnessCB(harnessInfo)
% Harness creation callback for signal editor block
    debug = 1;
    inportBlks = find_system(harnessInfo.HarnessModel,'SearchDepth',1, ...
        'BlockType','Inport');
    pos1 = get_param(inportBlks{1},'Position');
    pos2 = get_param(inportBlks{end},'Position');
    ph = get_param(inportBlks,'PortHandles');
    ln = cellfun(@(x) get(x.Outport(1),'Line'), ph);
    delete_line(ln);
    delete_block(inportBlks);
    blkSigEditor = [get_param(harnessInfo.HarnessModel,'Name') '/TestCases']; 
    add_block('simulink/Sources/Signal Editor', blkSigEditor);
    posBlk = get_param(blkSigEditor,'Position');
    set_param(blkSigEditor,'Position',[pos1(1) pos1(2) ...
        pos1(1)+(posBlk(3)-posBlk(1)) pos2(4)]);
    set_param(blkSigEditor,'FileName','CruiseControl_Short_SigEditor.mat')
    for i=1:numel(inportBlks)
        add_line(get_param(harnessInfo.HarnessModel,'Name'), ...
            ['TestCases/' num2str(i)], ... 
            ['Input Conversion Subsystem/' num2str(i)]); 
    end

end

