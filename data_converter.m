%% convert from text to matlab format
% function data_converter(fileName) 

filename = 'norm-features_increased.txt';
delimiter = '","';

%  If you want ot select the number of lines to read:
% headerlinesIn = 2;
% A = importdata(filename,delimiterIn,headerlinesIn);

data = importdata(filename);
D = [];
for i=2: size(data,1) 
    line = data (i, 1);
    l = strsplit(delimiter,line{1});
    
    % 11 remove 'amount' since it is very random value
    % 27:28 remove 'ForecastCategoryName' & 'ForecastCategoryName-count'
    % 55:58 remove 'who won the deal & 'who won the deal count' 
%     rind = [11,15,27,35,49,51,55,56,57,58];
%     l(rind) = [];
    l{1} = l{1}(2:end);
    l{end} = l{end}(1:end-1);
    D = [D; l];
end

line = data (1, 1);
header = strsplit(delimiter,line{1});
save ('feature_names' , 'header');

clear data line l;
features = D(:,1:end-1);
labels = D(:, end);
clear D;

% % Save the current version of features 
% save ('norm-features_increased.mat' , 'features');
% save ('labels_increased.mat' , 'labels');

% Save the value indicator for the labels 
% 2 = Active, 3 = Won, 4 = Lost
label_names = {'WON','LOST','NO_DECISION'};
save ('label_names' , 'label_names');


% % Remove blanks and put -1 instead
% D = features;
% for i=1:10
%     index = strfind(features(:,i) , '""');
%     for j=1:size(D,1)
%         if (index{j}==1)
%             D{j,i} = '"-1"';
%         end
%     end
% end


% % Relabel and change some feature values: I did offlien from the cmd
% % correct the values: remove the strings, and change the matrix to double from cell
% DD = D;
% for i=15:22
%     for j=2:size(eval(['values.feature_' num2str(i)]),1) % j=1 is ""
%         val = eval(['values.feature_' num2str(i) '(' num2str(j) ')']);
%         index = strfind(features(:,i) , val{1});
%         for k=1:size(D,1)
%             if (index{k}==1)
%                 DD{k,i} = ['"' num2str(j) '"'];
%             end
%         end        
%     end
% end
% % save ('norm-features2.mat' , 'D');


% change the data to double from cell
D = features;
DDD = zeros(size(D));
for i=1:size(D,1)
    for j=1:size(D,2)
        if (~isnan(str2double(D{i,j})))
            DDD(i,j) = str2double(D{i,j});
        else
            DDD(i,j) = sum(D{i,j});
        end
    end
end
D = DDD;

save ('matlab_norm-features_increased.mat' , 'D');
% save ('matlab_labels_increased' , 'labels');





