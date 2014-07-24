function num = getNum(action, actions)

closed_group = {'Closed - Dead';'Closed/Dead';'Closed - Lost';'Closed - Internal';'Closed - Duplicate';'Closed Duplicate';'Submitted for Deletion';};

num = find (strcmp(actions, action));

if (find(strcmp(closed_group , action))>0)
    num = 26;
end

if (strcmp('Closed Won' , action))
    num = 27;
end

if (strcmp('created' , action))
    num = 1;
end

if (size(num,1)==0)
    display(['action ' action ' is not considered for this verion']);
end


        
        