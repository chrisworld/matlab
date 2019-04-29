% Aufgabe 2: Aufnahme einer Diodenkennlinie
% 
% Anfangseinstellungen:
% Kanal OUT1: u1
% Kanal IN1 : ube
% Kanal IN2 : ur1
% 
% '%' beginnt einen Kommentar
% ';' unterdrückt die Ausgabe einer Befehlszeile im Command Window
% 'close all' schließt alle figures
% 'clear all' löscht alle Variablen
% 'clc' leert das Command Window
% 'Startwert:Inkrement:Endwert' erzeugt einen Vektor

clearvars, close all, clc

%  Korrekturwerte einsetzen
    % Hier bitte Code ergänzen
U_off_corr_1=0.002152507822463;
U_off_corr_2=-0.001601462794531;
K_gain_corr_1=1.000228165021257;
K_gain_corr_2=1.000771051199381;

% Werte für die Einlesefunktion
    % Hier bitte Code ergänzen
N = 1;
fs = 10000;
vrange = 25;

% Widerstand R1
    % Hier bitte Code ergänzen
R1 = 10000;

% Konfiguration der Messhardware auf die gewünschten Parameter
    % Hier bitte Code ergänzen
reamio('configure',N,fs,vrange,'average');

% Erstellen des Vektors u1
    % Hier bitte Code ergänzen
u1 = 0:0.05:5;

for i_count = 1 : length(u1)
    % Ausgeben von u1(i)
        % Hier bitte Code ergänzen
        reamio('out',1,u1(i_count)); 
        
        [x1 x2] = reamio('in',12);
        Ur1(i_count) = (x1 - U_off_corr_1) / K_gain_corr_1;
        Ube(i_count) = (x2 - U_off_corr_2) / K_gain_corr_2;
                pause(0.005);
end

% Berechnung des Stromes ib
ib = Ur1 / R1;

% Darstellung der Transistor-Eingangskennlinie ib=f(ube)
% Hier bitte Code ergänzen
figure(1)
plot(Ube, ib)
title('Transistor-Eingangskennlinie i_B=f(u_{BE}) (average)')
xlabel('u_{BE} in V')
ylabel('i_B in A')
grid on, zoom on



