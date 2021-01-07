function payoffVector =  CalculatePayoff(Agents, decisionVector, penaltySick, payoffLeavingHome)

    payoffVector = payoffLeavingHome.*decisionVector - penaltySick.*(Agents(:, 2)==1);
    
    
end