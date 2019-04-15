function copyExtReqs(src,dest,all)
% Copies external reqs spreadsheet plus req set and links file

    d=fileparts(which([src '.xlsx']));
    
    copyfile(which([src '.xlsx']),[d filesep dest '.xlsx']);
    if all
        copyfile(which([src '.slreqx_']),[d filesep dest '.slreqx']);
        copyfile(which([src '.slmx_']),[d filesep dest '.slmx']);
    end
    
end

