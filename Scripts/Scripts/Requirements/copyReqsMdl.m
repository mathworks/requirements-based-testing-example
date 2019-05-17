function copyReqsMdl(src,dest)
% Copies reqs model plus req links file

    d=fileparts(which([src '.slx_']));
    copyfile(which([src '.slx_']),[d filesep dest '.slx']);
    copyfile(which([src '.slmx_']),[d filesep dest '.slmx']);
    
end

