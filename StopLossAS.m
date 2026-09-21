function[Price]=StopLossAS(T,r,Paths,K)
[NRepl,NStepsPlus1] = size(Paths);
NSteps = NStepsPlus1 - 1;
dt = T/NSteps;
Cost = zeros(NRepl,1);
DiscountFactors = exp(-r*(0:NSteps)*dt)'; 
FuturePaths = Paths(:, 2:end); 
LogPaths = log(FuturePaths);
CumLogSum = cumsum(LogPaths, 2);
t_steps = 1:NSteps; 
RunningAverageFuture = exp(CumLogSum ./ t_steps); 
RunningAverage = [Paths(:, 1), RunningAverageFuture]; 
for k=1:NRepl
    CashFlows = zeros(NStepsPlus1,1); 
    Covered = 0;
    
    
    if (Paths(k,1) >= K)
        Covered = 1;
        CashFlows(1) = -Paths(k,1); 
    end
    
    
    for t=2:NSteps
        if (Covered==1) && (RunningAverage(k,t) < K)
            Covered = 0;
            CashFlows(t) = Paths(k,t);
        elseif (Covered==0) && (RunningAverage(k,t) >= K)
            Covered = 1;
            CashFlows(t) = -Paths(k,t);
        end
    end
    
    
    FinalAverage = RunningAverage(k, NStepsPlus1); 
    FinalStockPrice = Paths(k, NStepsPlus1);
    
    
    Payoff = max(FinalAverage - K, 0);
    if Covered == 1
        CashFlows(NStepsPlus1) = FinalStockPrice - Payoff;
    else
       
        CashFlows(NStepsPlus1) = - Payoff;
    end
    Cost(k) = -dot(DiscountFactors, CashFlows);
end
Price = mean(Cost);
end
