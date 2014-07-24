%% Use HMM discrete

clear;
clc;

load ('matlab_norm-features');
load ('matlab_labels');

% Perfrom K-means on DD cols
for i=1:10
    k = unique (D(:,i));
    IDX(:,i) = kmeans(D(:,i), floor(size(k,1)/22));
end
% 

% DD = (DD - min(min(DD)))/(max(max(DD)) - min(min(DD)));
DD = IDX;

N_fold = 6;
Y = []; acc = []; Prob = [];

ind = [1 301 601 901 1201 1501 1857];
all = 1:1856;

for i=1:N_fold
    
    test = ind(i):ind(i+1)-1;
    train = all;
    train(test) = [];
    
    trainD = DD(train, :);
    testD = DD (test , :);
    
    trainL = labels(train);
    testL = labels(test);
    
    ind2 = find(trainL==2);
    ind3 = find(trainL==3);
    ind4 = find(trainL==4);
    
    train2 = trainD(ind2,:);
    train3 = trainD(ind3,:); train3 = repmat(train3, [25 1]);
    train4 = trainD(ind4,:); train4 = repmat(train4, [4 1]);
    
    % Train
    [modela, loglikHista1] = hmmFit(reshape(train2 , size(train2,1)*size(train2,2) , 1), 2, 'discrete');
    [modelb, loglikHista1] = hmmFit(reshape(train3 , size(train3,1)*size(train3,2) , 1), 2, 'discrete');
    [modelc, loglikHista1] = hmmFit(reshape(train4 , size(train4,1)*size(train4,2) , 1), 2, 'discrete');
    
    % Test
    for j=1:size(testD,1)
        seq = testD(j,:);
        
        ll_a = dhmm_logprob(seq, modela.pi, modela.A, modela.emission.T);
        ll_b = dhmm_logprob(seq, modelb.pi, modelb.A, modelb.emission.T);
        ll_c = dhmm_logprob(seq, modelc.pi, modelc.A, modelc.emission.T);
        
        Y = [Y; [ll_a ll_b ll_c]];
    end
   
end

% claculate F1 Score

Yc = double(int8(Y));
c = confusionmat(Yc , labels)'
[confus,numcorrect,precision,recall,F] = getcm (labels,Yc,[2,3,4])
c(1,1)/sum(c(1,:))
c(2,2)/sum(c(2,:))
c(3,3)/sum(c(3,:))
