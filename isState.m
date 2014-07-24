function y = isState(action, stages)

% 16 stages
closed_group = {'Closed - Dead';'Closed/Dead';'Closed - Lost';'Closed - Internal';'Closed - Duplicate';'Closed Duplicate';'Submitted for Deletion';};

% stages = {'Project - Early/Undefined 10%';
%           '1 - Project - Early/Undefined';
%           'Project - Budget & Close Date 25%';
%           '2 - Project - Budget & Close Date';
%           'Pilot';
%           'Technical Acceptance 50%';
%           '3 - Pilot - Technical Acceptance';
%           'Negotiation/Review';
%           'Proposal Made 75%';
%           'Proposal Submitted';
%           '4 - Negotiations - Proposal Submitted';
%           'Procurement 90%';
%           '5 - Purchasing - Procurement';
%           'Closed - Dead';'Closed/Dead';'Closed - Lost';'Closed - Internal';'Closed - Duplicate';'Closed Duplicate';'Submitted for Deletion';
%           'Closed - Won';'Closed Won';
%           'Put On Hold';
%           };

y = 0;
if (find(strcmp(closed_group , action))>0)
    y = 15;
end

if (find(strcmp(stages , action))>0)
    y = find(strcmp(stages , action));    
elseif (strcmp('Closed Won' , action))
    y = 16;
end

end