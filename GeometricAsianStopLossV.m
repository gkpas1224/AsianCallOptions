function Price = GeometricAsianStopLossV(S0,K,sigma,r,T,Paths)

% Παίρνει τον αριθμό των paths και των χρονικών σημείων
[NRepl,NStepsPlusOne] = size(Paths);

% Τα πραγματικά χρονικά βήματα είναι οι στήλες μείον 1
NSteps = NStepsPlusOne - 1;

% Μήκος κάθε χρονικού βήματος
dt = T/NSteps;

% Πίνακας χρηματοροών
CashFlows = zeros(NRepl,NSteps+1);

% Προεξοφλητικοί παράγοντες για κάθε χρονική στιγμή
DiscountFactors = exp(-r*(0:NSteps)*dt);

% Παίρνουμε λογάριθμο των paths για τον γεωμετρικό μέσο
LogPaths = log(Paths);

% Σωρευτικό άθροισμα των logs κατά γραμμή
CumLogSum = cumsum(LogPaths,2);

% Χρονικά σημεία 1,2,...,NSteps+1
TimeSteps = 1:NSteps+1;

% Υπολογισμός γεωμετρικού rolling average
RunningAverage = exp(CumLogSum./TimeSteps);

% Κρατάμε τους μέσους όρους μέχρι πριν τη λήξη
CurrentAverage = RunningAverage(:,1:NSteps);

% Προηγούμενος μέσος όρος, για να εντοπίσουμε crossings
OldAverage = [zeros(NRepl,1) CurrentAverage(:,1:end-1)];

% Σημεία όπου ο μέσος περνάει πάνω από το strike
UpTimes = CurrentAverage >= K & OldAverage < K;

% Σημεία όπου ο μέσος πέφτει κάτω από το strike
DownTimes = CurrentAverage < K & OldAverage >= K;

% Αγοράζουμε όταν περνάει πάνω από K και πουλάμε όταν πέφτει κάτω από K
CashFlows(:,1:NSteps) = -UpTimes.*Paths(:,1:NSteps) + DownTimes.*Paths(:,1:NSteps);

% Flag για το αν κρατάμε μετοχή στο τέλος
CoveredFlag = zeros(NRepl,1);

% Αν ο τελευταίος μέσος πριν τη λήξη είναι πάνω από K, θεωρούμε ότι είμαστε covered
CoveredFlag(CurrentAverage(:,end) >= K) = 1;

% Τελική τιμή μετοχής
ST = Paths(:,NSteps+1);

% Τελικός γεωμετρικός μέσος
GeoAverageS = RunningAverage(:,end);

% Payoff του Geometric Asian Call
Payoff = max(GeoAverageS-K,0);

% Τελική χρηματοροή: πουλάμε τη θέση στη μετοχή και πληρώνουμε το payoff
CashFlows(:,NSteps+1) = CoveredFlag.*ST - Payoff;

% Προεξόφληση όλων των χρηματοροών
Cost = -CashFlows*DiscountFactors';

% Μέση τιμή από όλα τα paths
Price = mean(Cost);

end