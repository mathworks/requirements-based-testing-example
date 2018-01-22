%% USING MPT.PARAMETERS TO SET UP MY TUNABLE VARIABLES
CruiseOnOff = mpt.Signal;
CruiseOnOff.DataType = 'boolean';
CruiseOnOff.Min = 0;
CruiseOnOff.Max = 1;

Brake = mpt.Signal;
Brake.DataType = 'boolean';
Brake.Min = 0;
Brake.Max = 1;

CoastSetSw = mpt.Signal;
CoastSetSw.DataType = 'boolean';
CoastSetSw.Min = 0;
CoastSetSw.Max = 1;

AccelResSw = mpt.Signal;
AccelResSw.DataType = 'boolean';
AccelResSw.Min = 0;
AccelResSw.Max = 1;

Speed = mpt.Signal;
Speed.DataType = 'single';
Speed.Min = 0;
Speed.Max = 160;

engaged = mpt.Signal;
engaged.DataType = 'boolean';
engaged.Min = 0;
engaged.Max = 1;

tspeed = mpt.Signal;
tspeed.DataType = 'single';
tspeed.Min = 0;
tspeed.Max = 160;

incdec = mpt.Parameter;
incdec.Value = 1;
incdec.DataType = 'single';
incdec.Min = 1;
incdec.Max = 2;

holdrate = mpt.Parameter;
holdrate.Value = 5;
holdrate.DataType = 'single';
holdrate.Min = 0;
holdrate.Max = 10;

% sampletime = mpt.Parameter;
% sampletime.Value = 0.1;
% sampletime.DataType = 'single';
% sampletime.Min = 0.001;
% sampletime.Max = 10;

maxtspeed = mpt.Parameter;
maxtspeed.Value = 90;
maxtspeed.DataType = 'single';
maxtspeed.Min = 80;
maxtspeed.Max = 90;

mintspeed = mpt.Parameter;
mintspeed.Value = 20;
mintspeed.DataType = 'single';
mintspeed.Min = 20;
mintspeed.Max = 25;