# AsianCallOptions
PROJECT OVERVIEW
This repository contains a comprehensive computational framework built in MATLAB for the pricing and dynamic risk management of Asian Call Options.
Unlike standard vanilla options, Asian options are path-dependent derivatives where the payoff depends on the average price of the underlying asset over a specific period. This averaging mechanism mitigates market volatility and reduces the risk of spot-price manipulation near maturity, making them highly valuable in commodity and currency markets.
To bypass the structural limitations of arithmetic averaging—which lacks an exact analytical solution—this project utilizes the geometric mean. By exploiting the log-normal properties of Geometric Brownian Motion (GBM), we implemented the Kemna and Vorst (1990) closed-form solution to establish a rigorous theoretical pricing baseline, which we then replicated via Monte Carlo simulations and dynamic hedging algorithms.

METHODOLOGY & MATHEMATICAL FRAMEWORK
1. Underlying Asset DynamicsThe continuous-time stochastic process of the underlying asset is modeled using Geometric Brownian Motion (GBM) under the risk-neutral measure. To transition from analytical to computational valuation, we utilized a Monte Carlo simulation generating 50,000 discrete price paths over 252 monitoring steps.
2. Theoretical PricingWe applied the Kemna & Vorst (1990) analytical closed-form solution. Because the product of log-normal variables is log-normal, adjusting the volatility (σ*) and cost of carry (b*) parameters allows us to use an adapted Black-Scholes-Merton formula to price the geometric Asian option exactly.
3. Dynamic Risk Management (Hedging)
We evaluated the efficiency of two distinct portfolio replication strategies:
Stop-Loss Method: A static strategy where a covered position is taken when the running geometric average crosses the strike price (Gt > K), and liquidated when it falls below.
Dynamic Delta Hedging: A dynamic rebalancing strategy. Because the geometric average dampens volatility over time, the algorithm dynamically calculates the effective strike (K_eff) and updates the required Delta (Δt) at each time step based on the unobserved remaining interval.

KEY RESULTS
The empirical results from our MATLAB engine strongly validate the theoretical models.
Model Parameters:
S0 = 100, K = 100, r = 0.05, σ = 0.20, T = 0.5 (years), Paths = 50,000, Steps = 252.
Method                                Expected Cost/Price    Error vs Theoretical
Closed-Form Solution (theoretical)            3.7648              -
Monte Carlo Simulation                        3.7556              0.0092
Dynamic Delta Hedging                         3.7642              0.0006
Stop- Loss Hedging                            3.7679             -0.0031
Both hedging strategies approximate the initial premium with exceptional precision, with Dynamic Delta Hedging achieving an error margin of just $0.0006$. This confirms that the geometric average effectively reduces the option premium compared to its European counterpart.
