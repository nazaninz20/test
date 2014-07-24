
% get the histogram of number of times we go from create to state(j)
load ('stageNameDic.mat');
load ('all_IDs');

stageMaps = containers.Map;
for i=1:23
    stageMaps(stageNameDic{i,1}) = stageNameDic{i,4};
end

histVal_old = zeros(size(id,1),8);
histVal_new = zeros(size(id,1),8);

for i=1:size(id,1)
    idName = id{i}
    opt = data(idName);
    for j=1:size(opt,1)
        ind_stageName = find(strcmp(opt(j).field,'StageName'));
        if (size(ind_stageName,1)>0)
            stage_id_old = stageMaps(opt(ind_stageName).oldVal{1});
            stage_id_new = stageMaps(opt(ind_stageName).newVal{1});
            if (stage_id_old>0)
                histVal_old(i,stage_id_old) = histVal(i,stage_id_old)+1;
            end
            if (stage_id_new>0)
                histVal_new(i,stage_id_new) = histVal(i,stage_id_new)+1;
            end
        end
    end
end

