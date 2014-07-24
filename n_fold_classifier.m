%% N fold cross validation + SVM
clear;
clc;

load ('matlab_norm-features_increased');
load ('matlab_labels');

DD= D;

% % remove no decision section:
% ind = find(labels==4);
% labels(ind) = [];
% DD(ind,:) = [];

% combine no decision and loss:
ind = find(labels==4);
labels(ind) = 3;

N_fold = 6; 
Y = []; acc = []; Prob = [];

ind = [1 301 601 901 1201 1501 1857];
% ind = [1 301 601 901 1201 1524];
all = 1:1856;

for i=1:N_fold
    
    test = ind(i):ind(i+1)-1;
    train = all;
    train(test) = [];
    
    trainD = DD(train, :);
    testD = DD (test , :);
    
    trainL = labels(train);
    testL = labels(test);
    
    % Try to balance data:
    l = unique(trainL);
    for ii=1:size(l,1)
        s = size(find(trainL==l(ii)),1);
        ratio = s/size(trainL,1);
        if (ratio < 0.3)
           index = find(trainL==l(ii));
           m = floor(0.4/ratio);
           addD = trainD(index,:);
           addL = trainL(index);
           A = repmat(addD, [m,1]);
           B = repmat(addL, [m,1]);
           trainD = [trainD ; A];
           trainL = [trainL ; B];
        end
    end
    
% %     SVM:
%     model = svmtrain(trainL, trainD, '-s 0 -t 0 -c 50000');
%     [Yout, Acc, Yext]=svmpredict(testL, testD, model);

% %     Decision Tree
    ctree = fitrtree(trainD, trainL,'minleaf',10);
    Yout = predict(ctree,testD);

% %     KNN
%     mdl = fitcknn(trainD, trainL , 'NumNeighbors', 1, 'Distance', 'mahalanobis'); 
%     Yout = predict(mdl,testD);


%     Ramdom Forest
%     BaggedEnsemble = TreeBagger(70,trainD, trainL, 'OOBPred', 'On' , 'Method' , 'classification' , 'MinLeaf' , 5);
%     plot(oobError(BaggedEnsemble));
%     xlabel('Number of grown trees');
%     ylabel('Out-of-bag classification error');
%     [Yout score] = predict(BaggedEnsemble, testD);
%     Yout = cell2mat(Yout);
%     Yout = str2num(Yout); 
    
%     Random_Forest = Stochastic_Bosque(trainD,trainL,'ntrees', 50,'method','g','MinLeaf',5);
%     [Yout f_votes]= eval_Stochastic_Bosque(testD,Random_Forest);
    
    Y = [Y; Yout];
%     acc = [acc; Acc];
%     Prob = [Prob; score];
end

% claculate F1 Score

Yc = double(int8(Y));
c = confusionmat(Yc , labels)';
[confus,numcorrect,precision,recall,F] = getcm (labels,Yc,[2,3])
c(1,1)/sum(c(1,:))
c(2,2)/sum(c(2,:))
c(3,3)/sum(c(3,:))

tp = c(1,1);
tn = c(2,2);
fp = c(1,2);
fn = c(2,1);

% precision or positive redictive
ppv = tp/(tp+fp);

% true positive rate (recall)
tpr = tp/(tp+fn);

% false positive rate
fp = fp/(fp+tp);

% F1 socre
F1 = 2*ppv*tpr/(ppv+tpr);


%% Optimize the Decission Tree:
% 
% leafs = logspace(1,2,10);
% rng('default')
% N = numel(leafs);
% err = zeros(N,1);
% for n=1:N
%     t = fitctree(DD,labels,'CrossVal','On',...
%         'MinLeaf',leafs(n));
%     err(n) = kfoldLoss(t);
% end
% plot(leafs,err);
% xlabel('Min Leaf Size');
% ylabel('cross-validated error');
% 
% DefaultTree = fitctree(DD,labels);
% view(DefaultTree,'Mode','Graph')
% 
% OptimalTree = fitctree(DD,labels,'minleaf',10);
% view(OptimalTree,'mode','graph')
% 
% resubOpt = resubLoss(OptimalTree);
% lossOpt = kfoldLoss(crossval(OptimalTree));
% resubDefault = resubLoss(DefaultTree);
% lossDefault = kfoldLoss(crossval(DefaultTree));
% resubOpt,resubDefault,lossOpt,lossDefault
% 
% 
% % Pruning:
% [~,~,~,bestlevel] = cvLoss(tree,...
%     'SubTrees','All','TreeSize','min');
% view(tree,'Mode','Graph','Prune',6);
% 
% [~,~,~,bestlevel] = cvLoss(tree,'SubTrees','All');
% tree = prune(tree,'Level',6);
% view(tree,'Mode','Graph')
% 
% % Train Classification Trees Using classregtree
% t = classregtree(meas,species,...
%                  'Names',{'SL' 'SW' 'PL' 'PW'});
% treetype = type(t);
% 
% 


