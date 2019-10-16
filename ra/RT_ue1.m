%% Aufgabe 1/a)

s = tf('s');
Ps = 1/(s+3)^3;
% Ps = zpk([], [-3 -3 -3], 1) % effizienter; Eingabe über Pol- und Nullstellen

%% Sprungantwort

T = 5; % Dauer des Sprungantwort-Experiments

figure
step(Ps,T)
grid on


%% Wendetangente
[h, tsim] = step(Ps, linspace(0,T,1000));
dhdt = diff(h)./diff(tsim); % Zeitableitung von h
[~, idx] = max(dhdt); % Maximum der Ableitung bei tsim(idx)

% Alternative:
% d2hdt2 = diff(dhdt)./diff(tsim(1:end-1)); % 2. Zeitableitung von h
% idx = find(d2hdt2*d2hdt2(1) < 0, 1); % erster Vorzeichenwechsel der 2. Ableitung

hold on;
k = dhdt(idx); % Steigung der Wendetangente
d = h(idx) - k*tsim(idx); % Offset der Wendetangente
plot(tsim, k*tsim+d, 'r');

%% Berechnung der Kenngrößen

KS = h(end) % Streckenverstärkung
Tv = -d/k % Verzugszeit
Tg = (KS-d)/k - Tv % Ausgleichszeit

%% PI-Regler mittels Open-Loop Methode nach Ziegler-Nichols

KP = 0.9*Tg/(KS*Tv);
TN = 3.33*Tv;

% Reglerübertragungsfunktion
Rs = KP*(1+tf([1], [TN, 0]));

% Sprungantwort
Ts = minreal(Rs*Ps/(1+Rs*Ps));
zn_fig = figure
step(Ts, 10)

%% Aufgabe 2/b)

figure
step(Ps,T)
grid on

% Verstärkung der Strecke: Ermittlung von P(0)
KS = dcgain(Ps)

% Flächenberechnung von 1-h -> Endwert der Sprungantwort von 1/s-P(s)/(KS*s)
% (minreal ermöglicht Kürzung von s in Zähler und Nenner)
TSigma = dcgain(minreal((1-Ps/KS)/s))

hold on
plot(tsim, (tsim-TSigma)*1e4, 'r');

%% Regler mittels T-Summen Regel

KP = 1/(2*KS);
TN = 0.5*TSigma;

% Reglerübertragungsfunktion
Rs = KP*(1+1/(TN*s));

% Sprungantwort
Ts = minreal(Rs*Ps/(1+Rs*Ps));
figure(zn_fig)
hold on
step(Ts, 10)
legend('Ziegler-Nichols Open-Loop', 'T-Summen Regel');

%% Aufgabe 2/a)

% Strecke
Ps = -(3*s-8)/(s+3)^2;
%Ps = -tf([3, -8], [1, 6, 9]) % effizienter, Eingabe über Zähler- und Nennerpolynom

% Ortskurve
% figure
% opt = nyquistoptions;
% opt.ShowFullContour = 'off';
% nyquist(Ps,logspace(-3,3,10000),opt)

% Impulsanregung
K = 1.95;
figure
impulse(K*Ps/(1+K*Ps), 10)
hold on
K = 2;
impulse(K*Ps/(1+K*Ps), 10);
K = 2.05;
impulse(K*Ps/(1+K*Ps), 10);
grid on

legend('K = 1.95', 'K = 2', 'K = 2.05');

Kk = 2
Tk = 2*pi/5

%% Aufgabe 2/b)

% Closed-Loop Methode nach Ziegler-Nichols
KP = 0.6*Kk;
TN = 0.5*Tk;
TV = 0.12*Tk;

% KP = 0.8 % liefert in Simulation etwas besseres Ergebnis

% Regler: KP*(1+1/(s*TN)+s*TV/(1 + s*TR))
% Realisierungszeitkonstante für Differenzierer
TR = TV/10;

% Reglerübertragungsfunktion
Rs = KP*(1+1/(TN*s)+TV*s/(1+s*TR));
% Rs = KP*(1+tf([1],[TN 0])+tf([TV 0],[TR 1]));

% Sprungantwort
Ts = minreal(Rs*Ps/(1+Rs*Ps));
figure
step(Ts, 10)

% Stellgröße
Gs = minreal(Rs/(1+Rs*Ps))
figure
step(Gs,10);
