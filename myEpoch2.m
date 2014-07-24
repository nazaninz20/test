function t = myEpoch2(s)
s = s{1,1};
yr = str2num(s(1:4));
mr = str2num(s(6:7));
dr = str2num(s(9:10));


t = (dr*24*3600+mr*30*24*3600+yr*12*30*24*3600)*1000;