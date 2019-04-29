% Aufgabe 1a: Überprüfung der Einlesefunktion
% 
% Anfangseinstellungen:
% Kanal IN1: Sinussignal vom Funktionsgenerator mit Us = 1 V und f = 1kHz
% Kanal IN2: 0 V, beide Leiter auf GND
% 
% '%' beginnt einen Kommentar
% ';' unterdrückt die Ausgabe einer Befehlszeile im Command Window
% 'close all' schließt alle figures
% 'clear all' löscht alle Variablen
% 'clc' leert das Command Window
% 'Startwert:Inkrement:Endwert' erzeugt einen Vektor
% 'figure' erzeugt ein neues Fenster
% 'plot' Zeichnet ein Diagramm
% 'hist' Zeichnet ein Histogramm
% 'mean' Arithmetischer Mittelwert
% 'save' Speichert Variablen in eine Datei
% 'load' lädt Variablen aus einer Datei

% Leeren des Command Window
clearvars, close all, clc

% Werte für die Einlesefunktion
N = 1000;       % Anzahl der einzulesenden Werte, Vektorlänge
fs = 10000;     % Samplefrequenz, Abtastrate
vrange = 2.5;   % Eingangsspannungsbereich +- um 0V

% Einlesen eines Signals x von Kanal IN1
% Konfiguration der Messhardware auf die gewünschten Parameter
reamio('configure',N,fs,vrange,'average');

% Einlesen von Kanal IN1 und Speichern der Messwerte in x
x = reamio('in',1);

% Definition des Zeitvektors t
% 'Startwert:Inkrement:Endwert' erzeugt einen Vektor
t = (0:N-1)/fs;

% Darstellen des eingelesenen Signals x
figure(1)       % Erzeugt ein neues Fenster mit der Nummerierung 1
plot(t,x)       % Plotten von x=f(t)
title('x(t)')   % Titel für figure(1)
xlabel('t in s')% Beschriftung der X-Achse für figure(1)
ylabel('x in V')% Beschriftung der Y-Achse für figure(1)
grid on         % Darstellen des Rasters

% Einlesen von Kanal 2 mit den drei unterschiedlichen Einlese-Methoden
reamio('configure',N,fs,vrange,'decimate');
xD = reamio('in',2);

reamio('configure',N,fs,vrange,'average');
xA = reamio('in',2);

reamio('configure',N,fs,vrange,'minmax');
xMM = reamio('in',2);

% Darstellen von xD, xA und xMM in einem gemeinsamen Plot
figure(2), hold on
plot(t,xD, 'blue')
plot(t,xA, 'red')
plot(t(1:2:end), xMM(1:2:end), 'magenta')
plot(t(1:2:end), xMM(2:2:end), 'cyan')
    % Hier bitte Code einfügen
legend('decimate','average','min','max')
title('x(t) Vergleich ''decimate'', ''average'' und ''minmax''')
xlabel('t in s')
ylabel('xD, xA und xMM in V')

% Darstellen des Histogrammes bei unterschiedlichen Einlesemethoden
% Vergleichen Sie die Histogramme der unterschiedlichen Einlesemethoden
figure(3)
hist(xA,100)     % Stellt das Histogramm von xD mit 100 Unterteilungen dar
title('Histogramm von xA')
xlabel('U_e / V')
ylabel('Anzahl')

    % Hier bitte Code einfügen

% Gain- und Offsetkorrektur
% Ermitteln sie für beide Kanäle die Werte für die Gain- und
% Offsetkorrektur
% mean Berechnet das arithmetische Mittel eines Vektors
close all

% Einlesen von beiden Kanälen gleichzeitig
reamio('configure',N,fs,vrange,'average');
[x1 x2] = reamio('in',12);

% Hier bitte Code einfügen

%x1_mean = mean(x1)
%x2_mean = mean(x2) 
%x1_ref = 2.502722920375606;
%x2_ref = 2.500326165203921;

% Hier bitte richtige Werte einfügen 
U_off_corr_1=0.002152507822463;
U_off_corr_2=-0.001601462794531;
K_gain_corr_1=1.000228165021257;
K_gain_corr_2=1.000771051199381;

% Korrigieren von x
% Sobald Sie die Korrekturwerte ermittelt haben führen Sie hier die
% Korrektur der eingelesenen Werte durch

% Hier bitte Code einfügen

x1_corr = (x1 - U_off_corr_1) / K_gain_corr_1;
x2_corr = (x2 - U_off_corr_2) / K_gain_corr_2;

x1_mean = mean(x1_corr)
x2_mean = mean(x2_corr) 

% Darstellung des korrigierten Signals x
% Stellen Sie das korrigierte Signal x dar

figure(3)
plot(x1_corr)     % Stellt das Histogramm von xD mit 100 Unterteilungen dar
title('Plot von x1_{corr}')
xlabel('U_e / V')
ylabel('Anzahl')














