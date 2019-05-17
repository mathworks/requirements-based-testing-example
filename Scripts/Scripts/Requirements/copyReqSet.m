function copyReqSet(src,dest)
% Copies req set and links file

    d=fileparts(which([src '.slreqx_']));
    copyfile(which([src '.slreqx_']),[d filesep dest '.slreqx']);
    copyfile(which([src '.slmx_']),[d filesep dest '.slmx']);
    
end

