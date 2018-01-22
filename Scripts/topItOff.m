function [ status, filenames ] = topItOff( varargin )
% Top-it-off SLDV Test Gen Workflow

    if nargin==0
        mdl = bdroot;
    else
        mdl = varargin{1};
    end
    
    cvgDataFile = [mdl '_Cov'];
    cvsave(cvgDataFile,mdl);
    
    opts = sldvoptions(mdl);
    opts.CoverageDataFile = cvgDataFile;
    opts.IgnoreCovSatisfied = 'on';
    opts.Mode = 'TestGeneration';
    opts.ModelCoverageObjectives = 'MCDC';
    opts.ModelReferenceHarness = 'on';
    opts.SaveExpectedOutput = 'on';
    opts.Parameters = 'off';
    opts.SaveDataFile = 'on';
    opts.SaveHarnessModel = 'on';
    
    [status, filenames] = sldvrun(mdl, opts, true);
    
end

