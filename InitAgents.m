function Agents = InitAgents(numberOfAgents, initialInfectionRate, essentialWorkerRate)

    probablityLeavingHome = rand(numberOfAgents, 1);
    probablityLeavingHome(rand(numberOfAgents, 1) < essentialWorkerRate) = 2;
    
    sirState = rand(numberOfAgents, 1) < initialInfectionRate;
    
    Agents = [probablityLeavingHome, sirState];
end