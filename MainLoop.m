clear; clf;
addpath('../');

%Agent parameters
numberOfAgents = 10000;
penaltySick = 5;
payoffLeavingHome = 1;

restrictionRate = [0,.25,.75];
learningRate = 0.3;
updateRate = 0.01;
essentialWorkerRate = 0;

%Model parameters
tMax = 4000;

%Infection parameters
infectionRate = 0.2;
recoverRate = 0.04;
remissionRate = 0.1;
initialInfectionRate = 0.01;

N = length(restrictionRate);
for i = 1:N
 
    averageDecisionVector = [];
    varianceDecisionVector = [];
    
    susceptibleVector = [];
    infectedVector = [];
    recoveredVector = [];
    
    averagePayoffVector = [];
    variancePayoffVector = [];
    
    Agents = InitAgents(numberOfAgents, initialInfectionRate, essentialWorkerRate); %Nx2 Matrix of agent states   
    
    t = 0;
    ongoingDisease = true;

    longtermPayoff = [zeros(numberOfAgents, 1), ones(numberOfAgents, 1)];
     
    restrictionFactor = restrictionRate(i);
    
    k=1;
        
    while t<tMax
        t=t+1;
        if mod(t, 100)==0
            t
        end        
        
        %Simulate one step
        decisionVector = MakeDecision(Agents, restrictionFactor);
        Agents = SirStep(Agents, decisionVector, infectionRate, recoverRate, remissionRate);
        payoff = CalculatePayoff(Agents, decisionVector, penaltySick, payoffLeavingHome);
        longtermPayoff(:,1) = longtermPayoff(:,1) + payoff;
        
        [Agents, longtermPayoff] = UpdateStrategies(Agents, payoff, longtermPayoff, updateRate, learningRate, t);
        
        %Save statistics
        averageDecisionVector(t) = mean(decisionVector);
        varianceDecisionVector(t) = std(decisionVector);
        
        susceptibleVector(t) = sum(Agents(:,2)==0);
        infectedVector(t) = sum(Agents(:,2)==1);
        recoveredVector(t) = sum(Agents(:,2)==2);
        
        averagePayoffVector(t) = mean(payoff);
        variancePayoffVector(t) = std(payoff);
        
        ongoingDisease = infectedVector(t) > 0;
        
%         if mod(t, 1000)==0
%             remissionRate = remissionRate + 0.1;
%         end
        
%         if t==1 ||  t==500 ||  t==1000 || t==1500
%             subplot(2,2,k)
%                 histogram(Agents(:,1), 30);
%                 axis([0,1,0,10000]); xlabel("q_i", 'FontWeight', 'b', 'FontSize', 10); ylabel("Number of agents", 'FontWeight', 'b', 'FontSize', 10);
%                 set(gca,'YScale','log')
%             k=k+1
%         end
    end    

    hold on;

%     switch i
%         case 1
%             plot(averageDecisionVector, 'color', '#ffdb99', 'LineWidth', 2); %Orange   
%         case 2
%             plot(averageDecisionVector, 'color', '#ffc966', 'LineWidth', 2); %Orange   
%         case 3
%             plot(averageDecisionVector, 'color', '#ffb732', 'LineWidth', 2); %Orange   
%         case 4
%             plot(averageDecisionVector, 'color', '#ffa500', 'LineWidth', 2); %Orange   
%     end


     hold on;
      subplot(N, 2, i*2-1);
        hold on;
        plot(averageDecisionVector, 'color', '#ffbf00', 'LineWidth', 2); %Orange
        plot(susceptibleVector/numberOfAgents, 'color', '#0000ee', 'LineWidth', 2); %Blue
        plot(infectedVector/numberOfAgents, 'color', '#ee0000', 'LineWidth', 2); %Red
        plot(recoveredVector/numberOfAgents, 'color', '#00cc00', 'LineWidth', 2); %Green  
        ylabel('Agent status', 'FontWeight', 'b', 'FontSize', 10); xlabel('t', 'FontWeight', 'b', 'FontSize', 10); 

        if i==3
            legend({"Agent mobility", "Susceptible", "Infected", "Recovered"}, 'Orientation','horizontal', 'Location', [0.515,0.03,0,0]);
        end
   subplot(N, 2, i*2);
        hold on;
        shade(1:t,averagePayoffVector+variancePayoffVector, 'blue', 1:t,averagePayoffVector-variancePayoffVector, 'blue', 'FillType', [1,2], 'FillColor', 'blue', 'FillAlpha', [0.1]);   
        plot(averagePayoffVector, 'color', '#0000ee', 'LineWidth', 2);
        ylim([-penaltySick, payoffLeavingHome])
        ylabel('Mean payoff', 'FontWeight', 'b', 'FontSize', 10); xlabel('t', 'FontWeight', 'b', 'FontSize', 10)
end

% ylabel('Agent mobility', 'FontWeight', 'b', 'FontSize', 10); xlabel('t', 'FontWeight', 'b', 'FontSize', 10); 
% legend({"\beta=1", "\beta=2", "\betal=5", "\beta=10"})
set(gcf,'Position',[100 100 500 400])
exportgraphics(gcf,'Figures/RemIncrease.png','Resolution',300) 
