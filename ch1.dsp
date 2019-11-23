import("stdfaust.lib");

envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;
vmeter(x) = attach(x, envelop(x) : vbargraph("[10][unit:dB]", -70, +5));

mastergroup(x) = vgroup("[01]", x);

maingroup(x) = mastergroup(hgroup("[02]", x));

ctrlgroup(x)  = chgroup(vgroup("[01] CTRL", x));
chgroup(x) = hgroup("[01] CH", x);

pan = ctrlgroup(vslider("[02] pan [style:knob]", 0.5,0,1,0.01)); 
 vol = ctrlgroup(vslider("[03] vol", 0.0,0.0,1.0,0.01));

lpan = *(1-pan), *(sqrt(1-pan));
rpan = *(pan), *(sqrt(pan));
pmode = ctrlgroup(nentry("PAN MODE [style:menu{'linear':0;'exponential':1}]", 0,0,1,1)) : int;
pansel = lpan,rpan:ba.selectn(2,pmode), ba.selectn(2,pmode);
volmet = *(vol), *(vol) : chgroup(vmeter), chgroup(vmeter);
channel = _ <: pansel : volmet;
process = channel, channel;
