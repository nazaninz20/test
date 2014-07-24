% function opportunities = removeDuplicate(opportunities)
D = aruba_cvs;
D = D (2:end,:);
D = D(:,[2,5:10]);
N = containers.Map;
New = [];
for i=1:size(D,1)
    a = keys(N);
    key = strcat(D{i,1},D{i,2},D{i,3},D{i,4},D{i,5},D{i,6},D{i,7});
    if (sum(strcmp(a(2:end),key))==0)
        N(key)=1;
        New = [New; D(i,:)];
    end
end
opportunities(remove) = [];
