% % clear, clc;
% % 
% % % read form cvs
% % % aruba_cvs = [ID, OpportunityID, OpportunityName, AccountName, Field, CreatedDate, OldValue, NewValue, isDeleted, CreatedBy];
% load ('aruba_cvs.mat');
% 
% % a = [];
% % for i=1:228056
% %     line = aruba_cvs(i,:);
% %     if (strcmp(line(11),''))
% %         a(i,1:10) = line(i, 1:10);
% %     elseif (strcmp(line(12),''))
% %         
% %     end
% %     
% % end
% % % 
% % a(l,1:7) = aruba_cvs(l,1:7);
% % a(l,8) = strcat(aruba_cvs(l,8),aruba_cvs(l,9));
% % a(l,9:10) = aruba_cvs(l,10:11);
% % % 
% % a(s:e,1:10) = aruba_cvs(s:e,1:10);
% % 
% % % 
% % a(s:e,1:4) = aruba_cvs(s:e,1:4);
% % a(s:e,5:10) = aruba_cvs(s:e,6:11);
% % 
% % %
% % a(l,1:4) = aruba_cvs(l,1:4);
% % a(l,5:11) = aruba_cvs(l,7:13);
% % a(l,8) = strcat(a(l,8),a(l,9));
% % a(l,9:10) = a(l,10:11);
% % a(l,11) = '';
% 
% 
% a = aruba_cvs(:,[5,7,8]);
% a = a(2:end,:);
% b = zeros(size(a));
% names = unique(a(:,1));
% freq = []; 
% dic_ind = 1;
% % load ('dic.mat');
% 
% for i=6:size(names,1)
% 
%     name = names(i,1)
%     ind  = strcmp(a(:,1),name);
%     ind = find(ind==1);
%     freq{i,1} = name;
%     freq{i,2} = ind;
% %     val1 = unique(a(ind,2));
% %     val2 = unique(a(ind,3));
% %     dic{1,1} = name;
% %     dic{2,1} = name;
% %     dic{1,3} = 0;
% %     dic{2,3} = 0;
% %     dic{1,2} = 'increase';
% %     dic{2,2} = 'decrease';
%     dic(i+1,1) = name;
%     dic{i+1,3} = size(ind,1);
%     unique(a(ind,2))
% %     for j=1:size(ind,1)
% %         val1 = a{ind(j),2};
% %         if size(find(val1 == '-'),1)>0
% %             d = find(val1 == '-');
% %             val1(d)='';
% %         end
% %         val1 = str2num(val1);
% %         
% %         val2 = a{ind(j),3};
% %         if size(find(val2 == '-'),1)>0
% %             d = find(val2 == '-');
% %             val2(d)='';
% %         end
% %         val2 = str2num(val2);
% %         
% %         if (val1<val2)
% %             
% %             dic{1,3} = dic{1,3}+1;
% % %             dic_ind = dic_ind+1;
% % %             b{ind(j),2} = 1;
% %             
% %         else
% %            
% %             dic{2,3} = dic{2,3}+1;
% % %             dic_ind = dic_ind+1;
% % %             b{ind(j),2} = 2;
% %         end
% %     end
%     
% end
% a = aruba_cvs(:,[5,7,8]);
% a = a(2:end,:);


Name = 'StageName';
ind = find(strcmp(New(:,2),Name)==1);
c = unique(New(ind,4));
for ii = 1:size(c,1)
    name = c(ii);
    cnt1 = size(find(strcmp(New(ind,4) , name)==1),1);
    cnt2 = size(find(strcmp(New(ind,5) , name)==1),1);
    stageNameDic{ii,1} = name;
    stageNameDic{ii,2} = cnt1;
    stageNameDic{ii,3} = cnt2;
end


% save('stageNameDic.mat' , 'stageNameDic');

Name = 'Who_Won_the_Deal__c';
ind = find(strcmp(a,Name));
c = unique(a(ind,2));
for ii = 1:size(c,1)
    name = c(ii);
    cnt = size(find(strcmp(a(ind,3) , name)==1),1);
    
end



