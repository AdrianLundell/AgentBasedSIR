function decisionVector = MakeDecision(A, restrictionFactor)
    %Creates a vector with values 
    % 1 if agent a decides to leave the house
    % 0 if agent a decides to stay at home
    %restrictionFactor lies in the interval [0,1] and acts as a threshold
    %of possible decision
    
    numberOfAgents = length(A);
    decisionVector = rand(numberOfAgents,1)*(1-restrictionFactor) > 1-A(:,1);
end