function t = findHistThreshold(stage)
% stage may be used in the next version

    [histS , centers] = hist(stage(:,1), 100); 
    Thr = 0.75;
    ssum = 0;
    for i=1:size(histS,2)
        if (double(ssum/sum(histS))<0.75)
            ssum = ssum + histS(i);
        else
            break;
        end
    end
    
    t = centers(i);