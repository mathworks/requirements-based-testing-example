function gensddwv( modelName )
%SDD Summary of this function goes here
%   Detailed explanation goes here

if nargin == 0
    modelName = 'f14';
end

load_system(modelName);
sdd = EmbeddedWebViewSDD(modelName);
sdd.ExportOptions.IncludeMaskedSubsystems = false;
fill(sdd);
close_system(modelName);
rptview(sdd.OutputPath);

end

