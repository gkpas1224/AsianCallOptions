function [price, CI] = AsianMonteCarloPriceandCI(S0, K, r, sigma, T, NSteps, NRepl, Z)
    SPaths = AssetPathsAsian(S0, r, sigma, T, NSteps, NRepl, Z);
    geom_means = exp(mean(log(SPaths(:,2:end)), 2));
    discounted_payoffs = exp(-r * T) * max(geom_means - K, 0);
    price = mean(discounted_payoffs);
    s = std(discounted_payoffs); 
    SE = s / sqrt(NRepl); 
    CI_lower = price - 1.96 * SE;
    CI_upper = price + 1.96 * SE;
    CI = [CI_lower, CI_upper];
end