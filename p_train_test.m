 
load ('episodes.mat');
D = data; 

closed_group = {'Closed - Dead';
                'Closed/Dead';
                'Closed - Lost';
                'Closed - Internal';
                'Closed - Duplicate';
                'Closed Duplicate';
                'Submitted for Deletion';
                'Closed - Won';
                'Closed Won';
                };

key = keys(data);
closed = [];
active = [];
removed = [];


for k=1:size(key,2)
    seq = data(key{k});
   if size(seq ,2)< 11
       data (key{k}) = [];
%        key(k) = [];
       removed = [removed ; k];
   elseif (seq(1).createdDate == seq(end).createdDate)
       if (data (key{k}))
           data (key{k}) = [];
%            key(k) = [];
           removed = [removed ; k];
       end
   end
end
key(removed) = [];
    
save('episode_removedSmallBadData_key' , 'key');
save('index_of_removed_episodes' , 'removed');


for k=1:size(key,2)
    seq = data(key{k});
    check = 0;
    for i=1:size(seq,2)
        if find(strcmp(closed_group , seq(i).newVal))>0
            closed = [closed; k];
            check = 1;
            break;
        end
    end
    if (~check)
        active = [active; k];
    end
end