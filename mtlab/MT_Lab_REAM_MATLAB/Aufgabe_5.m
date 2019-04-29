% Aufgabe 5: Signalanalyse mittels AKF und KKF
% 
% Anfangseinstellungen:
% Kanal IN1 : Funktionsgenerator: Sinus Us = 1 V, f = 100 Hz
% Kanal IN2 : Rauschgenerator: verrauschtes Signal vom Funktionsgenerator
% 
% '%' beginnt einen Kommentar
% ';' unterdrückt die Ausgabe einer Befehlszeile im Command Window
% 'close all' schließt alle figures
% 'clear all' löscht alle Variablen
% 'clc' leert das Command Window
% 'Startwert:Inkrement:Endwert' erzeugt einen Vektor
% 'xcorr' Schätzung der Autokorrelation/Kreuzkorrelation

clearvars, close all, clc

%  Korrekturwerte einsetzen
U_off_corr_1=0.002152507822463;
U_off_corr_2=-0.001601462794531;
K_gain_corr_1=1.000228165021257;
K_gain_corr_2=1.000771051199381;

% Werte für die Einlesefunktion
N = 100000;
fs = 1000000;
vrange = 2.5;

% Konfiguration der Messhardware auf die gewünschten Parameter
% Diesmal wird ein Trigger verwendet um ein Stehendes Bild zu erreichen
reamio('configure',N,fs,vrange,'average',1,'rising',0.5)

% Erstellen des Zeitvektors t
t = (0:N-1)/fs;

% Erstellen des Verschiebungsvektors k
    % Hier bitte Code ergänzen
k = -(N-1):1:N-1;


% Einlesen von Kanal IN1 und IN2 und Korrektur
[x1 x2] = reamio('in',12);
x1 = (x1-U_off_corr_1)/K_gain_corr_1;
x2 = (x2-U_off_corr_2)/K_gain_corr_2;


% Korrelationen
% Experimentieren Sie mit den verschiedenen SCALEOPT-Optionen von 'xcorr'
    % Hier bitte Code ergänzen
x1x2_kkf = xcorr(x1, x2, 'biased');
x1_akf = xcorr(x1, x1, 'unbiased');
x2_akf = xcorr(x2, x2, 'unbiased');

% leistung
x1x2_kkf_p = x1x2_kkf(N)
x1_akf_p = x1_akf(N)
x2_akf_p = x2_akf(N)

% Darstellung des Signals x1(t) und des verrauschten Signals x2(t)
figure(1)
plot(t,x1,...
    t,x2,'r')
title('Signal x1(t) und verrauschtes Signal x2(t)')
xlabel('t in s')
ylabel('x1(t) und x2(t) in V')
grid on

% Darstellung KKF(x1,x2)
figure(2)
plot(k,x1x2_kkf)
title('KKF(x1,x2)')
xlabel('k in Samples')
ylabel('Rx1x2 in V ^2')
grid on

% Darstellung AKF(x1)
figure(3)
plot(k,x1_akf)
title('AKF(x1)')
xlabel('k in Samples')
ylabel('Rx1x1 in V ^2')
grid on

% Darstellung AKF(x2)
figure(4)
plot(k,x2_akf)
title('AKF(x2)')
xlabel('k in Samples')
ylabel('Rx2x2 in V ^2')
grid on
    
