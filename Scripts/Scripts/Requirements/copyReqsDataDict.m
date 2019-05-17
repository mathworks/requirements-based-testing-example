function copyReqsDataDict(src,dest)
% Copies reqs data dictionary plus req links file

    d=fileparts(which([src '.sldd_']));
    copyfile(which([src '.sldd_']),[d filesep dest '.sldd']);
    copyfile(which([src '.slmx_']),[d filesep dest '.slmx']);
    
end

