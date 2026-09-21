function SPaths = PathsASV(S0,r,sigma,T,NSteps,NRepl)

% Υπολογίζει το μήκος κάθε χρονικού βήματος
dt = T/NSteps;

% Drift του log-price σε risk-neutral περιβάλλον
nudt = (r-0.5*sigma^2)*dt;

% Τυχαίο κομμάτι της κίνησης
sidt = sigma*sqrt(dt);

% Δημιουργεί πίνακα τυχαίων κανονικών μεταβλητών
RandomShocks = randn(NRepl,NSteps);

% Υπολογίζει τα log-increments για όλα τα paths και όλα τα βήματα
LogIncrements = nudt + sidt*RandomShocks;

% Προσθέτει την αρχική τιμή log(S0) και αθροίζει σωρευτικά κατά γραμμή
LogPaths = cumsum([log(S0)*ones(NRepl,1) LogIncrements],2);

% Μετατρέπει τα log-prices σε κανονικές τιμές μετοχής
SPaths = exp(LogPaths);

% Εξασφαλίζει ότι η πρώτη στήλη είναι ακριβώς S0
SPaths(:,1) = S0;

end