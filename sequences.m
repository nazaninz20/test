
% load('aruba_cvs.mat');
% D = aruba_cvs(2:end,:);

load ('redundant_removed.mat');
D = data;

id = unique (D(:,1));

% cdfepoch object:
% 11-Mar-2009 15:09:25
data = containers.Map;
j = 1; h = 0;

for i=1:size(id,1)
    lines = [];
    ind = find(strcmp(D(:,1),id(i)));
    lines = D(ind,:);
    % Remove it from analysis
    if (size(ind,1)>5)  
        h = h+1;
        time = zeros(size(lines,1),1);
        for j=1:size(lines,1)
            date = lines(j,3);
            date = myEpoch(date);
            lines{j,3} = date;
            time(j) = date;
        end
        [a b] = sort(time);
        
        % Put into the structure in temporal manner
        opportunities = [];
        for j=1:size(lines,1)
            opportunities(j).id = lines(b(j),1);
            %         opportunities(j).optName = lines(b(j),3);
            opportunities(j).field = lines(b(j),2);
            opportunities(j).createdBy = lines(b(j),7);
            opportunities(j).createdDate = lines{b(j),3};
            opportunities(j).oldVal = lines(b(j),4);
            opportunities(j).newVal = lines(b(j),5);
        end
%         remove = [];
%         for i=1:size(opportunities,2)-1
%             for j=i+1:size(opportunities,2)
%                 if (strcmpi(opportunities(i).field , opportunities(j).field) ...
%                         && strcmpi(opportunities(i).createdBy , opportunities(j).createdBy) ...
%                         && (opportunities(i).createdDate == opportunities(j).createdDate) ...
%                         && strcmpi(opportunities(i).oldVal , opportunities(j).oldVal) ...
%                         && strcmpi(opportunities(i).newVal , opportunities(j).newVal))
%                     remove = [remove j];
%                 end
%             end
%         end
%         opportunities(remove) = [];
        data(lines{b(j),1}) = opportunities ;
    end
end

