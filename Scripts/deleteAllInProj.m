function deleteAllInProj(fName)
%DELETEALLINPROJ Delete all fName files in project

    fPaths = which(fName,'-all');
    if isempty(fPaths)
        return;
    end
    
%     if ischar(fPaths)
%         fPaths = {fPaths};
%     end
    
    p = simulinkproject;
    pRootExp = regexprep(p.RootFolder,'\\','\\\\');
   
    for i=1:numel(fPaths)
        if ~isempty(regexp(fPaths{i},['^' pRootExp], 'once'))
            delete(fPaths{i});
        end
    end
            
end

