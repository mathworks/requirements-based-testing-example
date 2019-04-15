function copyReqsTestCase(src,dest)
% Copies reqs test case plus req links file

    d=fileparts(which([src '.mldatx_']));
    copyfile(which([src '.mldatx_']),[d filesep dest '.mldatx']);
    copyfile(which([src '.slmx_']),[d filesep dest '.slmx']);
    
end

