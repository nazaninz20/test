function rx = RandomPermutation(x)

ind = size(x,2);
rind = randperm(ind);
rx = x(rind);
