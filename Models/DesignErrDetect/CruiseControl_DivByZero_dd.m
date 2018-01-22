%% USING MPT.PARAMETERS TO SET UP MY TUNABLE VARIABLES
CruiseOnOff = mpt.Signal;
CruiseOnOff.DataType = 'boolean';
CruiseOnOff.Min = 0;
CruiseOnOff.Max = 1;
CruiseOnOff.Dimensions = 1;
CruiseOnOff.DimensionsMode = 'fixed';

Brake = mpt.Signal;
Brake.DataType = 'boolean';
Brake.Min = 0;
Brake.Max = 1;
Brake.Dimensions = 1;
Brake.DimensionsMode = 'fixed';

CoastSetSw = mpt.Signal;
CoastSetSw.DataType = 'boolean';
CoastSetSw.Min = 0;
CoastSetSw.Max = 1;
CoastSetSw.Dimensions = 1;
CoastSetSw.DimensionsMode = 'fixed';

AccelResSw = mpt.Signal;
AccelResSw.DataType = 'boolean';
AccelResSw.Min = 0;
AccelResSw.Max = 1;
AccelResSw.Dimensions = 1;
AccelResSw.DimensionsMode = 'fixed';

Speed = mpt.Signal;
Speed.DataType = 'uint8';
Speed.Min = 0;
Speed.Max = 160;
Speed.Dimensions = 1;
Speed.DimensionsMode = 'fixed';

engaged = mpt.Signal;
engaged.DataType = 'boolean';
engaged.Min = 0;
engaged.Max = 1;
engaged.Dimensions = 1;
engaged.DimensionsMode = 'fixed';

tspeed = mpt.Signal;
tspeed.DataType = 'uint8';
tspeed.Min = 0;
tspeed.Max = 160;
tspeed.Dimensions = 1;
tspeed.DimensionsMode = 'fixed';

incdec = mpt.Parameter;
incdec.Value = 1;
incdec.DataType = 'uint8';
incdec.Min = 1;
incdec.Max = 2;

holdrate = mpt.Parameter;
holdrate.Value = 5;
holdrate.DataType = 'uint8';
holdrate.Min = 0;
holdrate.Max = 10;

maxtspeed = mpt.Parameter;
maxtspeed.Value = 90;
maxtspeed.DataType = 'uint8';
maxtspeed.Min = 80;
maxtspeed.Max = 90;

mintspeed = mpt.Parameter;
mintspeed.Value = 20;
mintspeed.DataType = 'uint8';
mintspeed.Min = 20;
mintspeed.Max = 25;