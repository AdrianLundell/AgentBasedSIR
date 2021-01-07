function Agents = SirStep(Agents, decisionVector, infectionRate, recoverRate, remissionRate)
    
    agentsGoingOut = Agents(decisionVector==1, :);
    N = length(agentsGoingOut);
    I = sum(agentsGoingOut(:,2)==1);

    numberOfAgents = length(Agents);
    
    for iAgent = 1:numberOfAgents
        if decisionVector(iAgent) == 1 && Agents(iAgent,2) == 0 && rand < infectionRate*I/N
            Agents(iAgent,2) = 1;
        end
        
        if Agents(iAgent,2) == 1 && rand < recoverRate
            Agents(iAgent, 2) = 2;
        end
        
        if Agents(iAgent,2) == 2 && rand < remissionRate
            Agents(iAgent,2) = 0;
        end
    end
 
end