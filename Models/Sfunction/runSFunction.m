function runSFunction()
    def = legacy_code('initialize');
    def.SourceFiles = { 'Lookup1D_C.c' };
    def.HeaderFiles = { 'Lookup1D_C.h' };
    def.SFunctionName = 'PedalCmdLookup_C';
    def.OutputFcnSpec = 'single y1 = Lookup1D_C(int8 u1,int8 p1[],single p2[])';
    def.IncPaths = { };
    def.SrcPaths = def.IncPaths;
    legacy_code('sfcn_cmex_generate', def);
    legacy_code('sfcn_tlc_generate', def); 
    def.Options.supportCoverageAndDesignVerifier = true;
    legacy_code('compile',def);
    legacy_code('slblock_generate', def);
end 