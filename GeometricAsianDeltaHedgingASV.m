function P = GeometricAsianDeltaHedgingASV(S0,K,sigma,r,T,Paths)

% Παίρνει αριθμό paths και χρονικών σημείων
[NRepl,NStepsPlusOne] = size(Paths);

% Τα χρονικά βήματα είναι οι στήλες μείον 1
NSteps = NStepsPlusOne - 1;

% Μήκος κάθε χρονικού βήματος
dt = T/NSteps;

% Πίνακας χρηματοροών
CashFlows = zeros(NRepl,NSteps+1);

% Προεξοφλητικοί παράγοντες
DiscountFactors = exp(-r*(0:NSteps)*dt);

% Συνολικός αριθμός παρατηρήσεων
n = NSteps;

% Υπολογισμός γεωμετρικού rolling average για κάθε path και κάθε χρόνο
GeoAverageAll = exp(cumsum(log(Paths),2)./(1:NSteps+1));

% Τρέχουσες τιμές μετοχής μέχρι πριν τη λήξη
SCurrent = Paths(:,1:NSteps);

% Πλήθος παρατηρήσεων που έχουν ήδη γίνει
mVec = 0:NSteps-1;

% Πλήθος παρατηρήσεων που απομένουν
nRemain = n - mVec;

% Χρόνος που απομένει μέχρι τη λήξη
Tau = T - mVec*dt;

% Τρέχων γεωμετρικός μέσος
Acurr = GeoAverageAll(:,1:NSteps);

% Μετατροπή των vectors σε matrices ώστε να ταιριάζουν με όλα τα paths
mMatrix = repmat(mVec,NRepl,1);
nRemainMatrix = repmat(nRemain,NRepl,1);
TauMatrix = repmat(Tau,NRepl,1);

% Effective strike, προσαρμοσμένο για τον μέσο όρο που έχει ήδη πραγματοποιηθεί
Keff = (K.*Acurr.^(-mMatrix/n)).^(n./nRemainMatrix);

% Προσαρμοσμένη μεταβλητότητα του geometric average
sigmaStar = sigma.*sqrt((nRemain+1).*(2*nRemain+1)./(6*nRemain.^2));

% Προσαρμοσμένο drift του geometric average
bStar = (r-0.5*sigma^2).*(nRemain+1)./(2*nRemain) + 0.5*sigmaStar.^2;

% Μετατροπή sigmaStar σε matrix
sigmaStarMatrix = repmat(sigmaStar,NRepl,1);

% Μετατροπή bStar σε matrix
bStarMatrix = repmat(bStar,NRepl,1);

% Υπολογισμός d1
d1 = (log(SCurrent./Keff) + (bStarMatrix + 0.5*sigmaStarMatrix.^2).*TauMatrix)./ (sigmaStarMatrix.*sqrt(TauMatrix));

% Delta του Geometric Asian Call (closed-form)
DeltaPaths = exp((bStarMatrix-r).*TauMatrix).*normcdf(d1);

% Αρχική αγορά Delta μετοχών
CashFlows(:,1) = -DeltaPaths(:,1).*Paths(:,1);

% Μεταβολές του delta από βήμα σε βήμα
DeltaChanges = DeltaPaths(:,2:end)-DeltaPaths(:,1:end-1);

% Χρηματοροές από τα rebalancings
CashFlows(:,2:NSteps) = -DeltaChanges.*Paths(:,2:NSteps);

% Τελική τιμή μετοχής
ST = Paths(:,NSteps+1);

% Τελικός γεωμετρικός μέσος
GeoAverageS = GeoAverageAll(:,end);

% Payoff του Geometric Asian Call
Payoff = max(GeoAverageS-K,0);

% Τελική χρηματοροή: ρευστοποιούμε τη θέση και πληρώνουμε το payoff
CashFlows(:,NSteps+1) = DeltaPaths(:,end).*ST - Payoff;

% Προεξόφληση χρηματοροών
Cost = -CashFlows*DiscountFactors';

% Μέση τιμή από όλα τα paths
P = mean(Cost);

end