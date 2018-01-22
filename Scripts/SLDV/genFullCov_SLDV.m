function genFullCov_SLDV(mdl)


    % run SLDV to get full coverage test vectors
    opts = sldvoptions;
    opts.ModelCoverageObjectives = 'MCDC';
    [status, fileNames] = sldvrun(mdl,opts,true);

    % convert SLDV test cases to .mat for use by SL Test
    convertSLDV2mat( fileNames.DataFile );
    evalin('base',['sldvDataFileName=''' fileNames.DataFile ''';']);

end
