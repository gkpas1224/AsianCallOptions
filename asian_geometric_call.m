function P = asian_geometric_call(S0, K, r, sigma, T, NSteps)
n = NSteps;
h = T / n;
var_G = (sigma^2 * h * (2*n + 1) * (n + 1)) / (6 * n);
sigma_G = sqrt(var_G);
mu_G = log(S0) + 0.5 * (r - 0.5 * sigma^2) * (T + h);
d1 = (mu_G - log(K) + var_G) / sigma_G;
d2 = d1 - sigma_G;
P = exp(-r * T) * (exp(mu_G + 0.5 * var_G) * normcdf(d1) - K * normcdf(d2));
end 