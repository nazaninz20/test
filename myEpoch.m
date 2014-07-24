function t = myEpoch(s)
s = s{1,1};
yr = str2num(s(1:4));
mr = str2num(s(6:7));
dr = str2num(s(9:10));
hr = str2num(s(12:13));
mir = str2num(s(15:16));
sr = str2num(s(18:19));

t = (sr+mir*60+hr*3600+dr*24*3600+mr*30*24*3600+yr*12*30*24*3600)*1000;