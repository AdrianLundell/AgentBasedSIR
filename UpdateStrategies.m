function [Agents, longtermPayoff] = UpdateStrategies(Agents, payoff, longtermPayoff, updateRate, learningRate, t)
    
    numberOfAgents = length(Agents); 

    for iAgent = 1:numberOfAgents
        if rand < updateRate && Agents(iAgent, 1) ~= 2
            if longtermPayoff(iAgent,1)/(t-longtermPayoff(iAgent,2)) < mean(payoff)
                
                longtermPayoff(iAgent, :) = [0, t];
                
                if Agents(iAgent, 1) > mean(Agents(Agents(:,1)~=-1,1))
                    newProbability = max(0, min(1, Agents(iAgent, 1) - learningRate));
                else
                    newProbability = max(0, min(1, Agents(iAgent, 1) + learningRate));  
                end
                
                Agents(iAgent, 1) = newProbability; 
            end
        end
    end
end