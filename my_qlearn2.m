%% Train Section 

clear ; clc;

load ('rewards_p.mat');
% load ('episodes.mat');
load ('closedData.mat');
data = closedData;


% select test and train:
ind = randperm(size(data,1));
% train_ind = ind(1:427);
% test_ind = ind(428:end);
load ('train_ind');
load ('test_ind');
load ('threshold.mat');

R = Rp(2:end, 2:end);
day = 1000*3600*24;

% note::::: Forcasts Categories ...
stages = {'created';
    'Project - Early/Undefined 10%';
    '1 - Project - Early/Undefined';
    'Project - Budget & Close Date 25%';
    '2 - Project - Budget & Close Date';
    'Pilot';
    'Technical Acceptance 50%';
    '3 - Pilot - Technical Acceptance';
    'Negotiation/Review';
    'Proposal Made 75%';
    'Proposal Submitted';
    '4 - Negotiations - Proposal Submitted';
    'Procurement 90%';
    '5 - Purchasing - Procurement';
    'Closed - Dead';
    'Closed - Won';
    'Put On Hold';
    };

actions = {'Amount_inc';
    'Amount_dec';
    'CloseDate_inc';
    'CloseDate_dec';
    'Deal_Registration__c';
    'Incremental_from_Partner__YES';
    'Incremental_from_Partner__NO';
    'RecordType';
    'Scheduled_Meeting_Date__c';
    'Sold_Through__c';
    'Solution_Category__c';
    'Competition__c';
    'Project - Early/Undefined 10%';
    '1 - Project - Early/Undefined';
    'Project - Budget & Close Date 25%';
    '2 - Project - Budget & Close Date';
    'Pilot';
    'Technical Acceptance 50%';
    '3 - Pilot - Technical Acceptance';
    'Negotiation/Review';
    'Proposal Made 75%';
    'Proposal Submitted';
    '4 - Negotiations - Proposal Submitted';
    'Procurement 90%';
    '5 - Purchasing - Procurement';
    'Closed - Lost';
    'Closed - Won';
    'Put On Hold';
    };

gamma=0.9;
alpha = 0.6;
goalState = 5;
q=zeros(size(R));
q1=ones(size(R))*inf;
count=0;
key = keys(data);
state_changed = 0;

% use only train key
key = key(train_ind);

for i=1:17
    eval(['stage_' num2str(i) '=[]']);
end

for episode = 1:size(key,2);
    
    % I am going to read episodes from here
    sequences = data(key{episode});
    
    % put the start state always 1 for now ('created' stage)
    current = 1;
    time_prev=0;
    
    for seq = 1:size(sequences,2)
        
        % read the next action considering the current state
        action = sequences(seq).field
        if (strcmp(action,'CloseDate'))
            t1 = myEpoch2(sequences(seq).oldVal);
            t2 = myEpoch2(sequences(seq).newVal);
            if (t1<t2)
                action = 'CloseDate_inc';
            else
                action = 'CloseDate_dec';
            end
        elseif (strcmp(action,'StageName') && isState(sequences(seq).oldVal{1}, stages))
            t1 = isState(sequences(seq).oldVal{1}, stages);
            t2 = isState(sequences(seq).newVal{1}, stages);
            if (time_prev==0)
                time_prev = sequences(seq).createdDate;
                prev_stage = t2; 
            else
                if (prev_stage~=t1)
                    display ('ERROR in stages');
                    prev_stage = t2;
                    time_prev = sequences(seq).createdDate;
                else
                    time_new = sequences(seq).createdDate;
                    t_gap = (time_new - time_prev)/day;
                    % penalize the long duration of stay in a stage
                    if (t_gap>threshold(t1))
                        % should be penalaize here
                        % go from t1 to hold and from hold to t1
                        qMax = max(q(t1,:));
                        samp = ceil(t_gap/threshold(t1))*R{t1,t1} + gamma*qMax;
                        q(t1,t1) = (1-alpha)*q(t1,t1) + alpha*samp;
                    end
                    %
                    eval(['stage_' num2str(prev_stage) '= [stage_' num2str(prev_stage) ';[' num2str(t_gap) ',' num2str(episode) ']]' ]);
                    prev_stage = t2;
                    time_prev = time_new;
                end
            end
            action = sequences(seq).newVal{1};
            state_changed = 1;
        elseif (strcmp(action,'Amount'))
            d1 = sequences(seq).oldVal{1};
            d2 = sequences(seq).newVal{1};
            if (str2double(d1)<str2double(d2))
                action = 'Amount_inc';
            else
                action = 'Amount_dec';
            end
        elseif (strcmp(action,'Incremental_from_Partner__c'))
            d1 = strcmp(sequences(seq).newVal{1}, 'Yes');
            d2 = strcmp(sequences(seq).newVal{1}, 'NO');
            if (d1)
                action = 'Incremental_from_Partner__YES';
            else
                action = 'Incremental_from_Partner__NO';
            end
        end
        action_num = getNum(action, actions);
        if (action_num>0)
            if (state_changed)
                if (current~=t1)
                    t1 = getNum(sequences(seq).oldVal{1}, actions);
                    st = isState(sequences(seq).oldVal{1}, stages)
                    qMax = max(q(st,:));
                    samp = R{current,t1} + gamma*qMax;
                    q(current,t1) = (1-alpha)*q(current,t1)+alpha*samp;
                    current = isState(sequences(seq).oldVal{1}, stages);
                end
                t2 = getNum(sequences(seq).newVal{1}, actions);
                st = isState(sequences(seq).newVal{1}, stages)
                qMax = max(q(st,:));
                samp = R{current,t2} + gamma*qMax;
                q(current,t2) = (1-alpha)*q(current,t2)+alpha*samp;
                sequences(seq).newVal
                current=isState(sequences(seq).newVal, stages);
                state_changed = 0;
            else
                qMax = max(q(current,:));
                samp = R{current,action_num} + gamma*qMax;
                q(current,action_num) = (1-alpha)*q(current,action_num)+alpha*samp;
            end
            
            %     % we want to fix the start state: always start from 1
            %     state = 1;
            %     while state~=goalState,
            %         x=find(R(state,:)>=-1);
            %         if size(x,1)>0,
            %             x1=RandomPermutation(x);
            %             x1=x1(1);
            %         end
            %         qMax=max(q,[],2);
            %         q(state,x1)=R(state,x1)+ gamma*qMax(x1);
            %         state=x1;
            %     end
            
        end
    end
end


% g=max(max(q));
% if g>0
%     q=100*q/g;
% end
% q

% day = 1000*3600*24;
% for i=1:17
%     if eval(['(size(stage_' num2str(i) ',1)>0)'])
%     eval(['stage_' num2str(i) '(:,1)=stage_' num2str(i) '(:,1)/day;']);
%     end
% end
% 
% save('stage_1' , 'stage_1');
% save('stage_2' , 'stage_2');
% save('stage_3' , 'stage_3');
% save('stage_4' , 'stage_4');
% save('stage_5' , 'stage_5');
% save('stage_6' , 'stage_6');
% save('stage_7' , 'stage_7');
% save('stage_8' , 'stage_8');
% save('stage_9' , 'stage_9');
% save('stage_10' , 'stage_10');
% save('stage_11' , 'stage_11');
% save('stage_12' , 'stage_12');
% save('stage_13' , 'stage_13');
% save('stage_14' , 'stage_14');
% save('stage_15' , 'stage_15');
% save('stage_16' , 'stage_16');


% % Find the delay threshold
% threshold = zeros(size(stages,1), 1);
% for i=1:17
%     if eval(['(size(stage_' num2str(i) ',1)>0)'])
%         eval(['threshold(i) = findHistThreshold(stage_' num2str(i) ', hist(stage_' num2str(i) '(:,1)));']);
%     end
% end
% save ('threshold.mat' , 'threshold' );

%% Test section: 
%%%%%%%%%%%%%%%%

key = keys(data);
key = key(test_ind);
accumulative_reward = size(key,2);

% Test on the test data:
for episode = 1:size(key,2);
    
    % I am going to read episodes from here
    sequences = data(key{episode});
    reward = 0;
    n_actions = 0;
    won_loss = 0;
    % put the start state always 1 for now ('created' stage)
    current = 1;
    state_changed = 0;
    time_prev=0;
    
    for seq = 1:size(sequences,2)
        
        % read the next action considering the current state
        action = sequences(seq).field
        if (strcmp(action,'CloseDate'))
            t1 = myEpoch2(sequences(seq).oldVal);
            t2 = myEpoch2(sequences(seq).newVal);
            if (t1<t2)
                action = 'CloseDate_inc';
            else
                action = 'CloseDate_dec';
            end
        elseif (strcmp(action,'StageName'))
            t1 = isState(sequences(seq).oldVal{1}, stages);
            t2 = isState(sequences(seq).newVal{1}, stages);
            if (time_prev==0)
                time_prev = sequences(seq).createdDate;
                prev_stage = t2; 
            else
                if (prev_stage~=t1)
                    display ('ERROR in stages');
                    prev_stage = t2;
                    time_prev = sequences(seq).createdDate;
                else
                    time_new = sequences(seq).createdDate;
                    t_gap = (time_new - time_prev)/day;
                    % penalize the long duration of stay in a stage
                    if (t_gap>threshold(t1))
                        % should be penalaize here
                        % go from t1 to hold and from hold to t1
                        r = q(t1,t1);
                        reward = reward + ceil(t_gap/threshold(t1))*r;
                    end
                    %
                    eval(['stage_' num2str(prev_stage) '= [stage_' num2str(prev_stage) ';[' num2str(t_gap) ',' num2str(episode) ']]' ]);
                    prev_stage = t2;
                    time_prev = time_new;
                end
            end
            action = sequences(seq).newVal{1};
            state_changed = 1;
        elseif (strcmp(action,'Amount'))
            d1 = sequences(seq).oldVal{1};
            d2 = sequences(seq).newVal{1};
            if (str2double(d1)<str2double(d2))
                action = 'Amount_inc';
            else
                action = 'Amount_dec';
            end
        elseif (strcmp(action,'Incremental_from_Partner__c'))
            d1 = strcmp(sequences(seq).newVal{1}, 'Yes');
            d2 = strcmp(sequences(seq).newVal{1}, 'NO');
            if (d1)
                action = 'Incremental_from_Partner__YES';
            else
                action = 'Incremental_from_Partner__NO';
            end
        end
        action_num = getNum(action, actions);
        if (action_num>0)
            if (state_changed)
                if (current~=t1)
                    t1 = getNum(sequences(seq).oldVal, actions);
                    r = q(current,t1);
                    reward = reward + r;
                    n_actions = n_actions + 1;
                    current = isState(sequences(seq).oldVal{1}, stages);
                end
%                 r = q(current,action_num);
%                 reward = reward + r;
%                 n_actions = n_actions + 1;
                t2 = getNum(sequences(seq).newVal{1}, actions);
                if (t2~=27 && t2~=26)
                    r = q(current,t2);
                    reward = reward + r;
                    n_actions = n_actions + 1;
                end
                if (t2==27)
                    won_loss = 1;
                end
                if (t2==27 || t2==26)
%                     Remove the last stage reward
%                     r = q(current,t2);
%                     reward = reward + r;
%                     n_actions = n_actions + 1;
                    break;
                end
                current = isState(sequences(seq).newVal{1}, stages);
                state_changed = 0;
            else
                r = q(current,action_num);
                reward = reward + r;
                n_actions = n_actions + 1;
            end
            
            %     % we want to fix the start state: always start from 1
            %     state = 1;
            %     while state~=goalState,
            %         x=find(R(state,:)>=-1);
            %         if size(x,1)>0,
            %             x1=RandomPermutation(x);
            %             x1=x1(1);
            %         end
            %         qMax=max(q,[],2);
            %         q(state,x1)=R(state,x1)+ gamma*qMax(x1);
            %         state=x1;
            %     end
         
        end
    end
    
    accumulative_reward(episode,1) = reward;
    accumulative_reward(episode,2) = n_actions;
    accumulative_reward(episode,3) = won_loss;
end

l = accumulative_reward(:,3);
accumulative_reward(:,4:5) = 0;
ROC = zeros(50,1);

% This is not ROC...just the best thr for the Accuracy
for i=1:size(accumulative_reward,1)
    accumulative_reward(i,4) = accumulative_reward(i,1)/accumulative_reward(i,2);
end

min_Thr = max(1, min(accumulative_reward(:,4)));
max_Thr = floor(max(accumulative_reward(:,4)));

for Thr=min_Thr:max_Thr
    p = zeros(size(accumulative_reward,1),1);
    for i=1:size(accumulative_reward,1)
        if (accumulative_reward(i,4)>=Thr)
            p(i) = 1;
            c = confusionmat(l,p);
            ROC(Thr) = trace(c)/sum(sum(c));
        end
    end
end  
[a b] = max(ROC)
% 34 for 87%

% got 69% for 48 remove the last stage 