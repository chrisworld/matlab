% Aufgabe 3: Messung von Mittelwert, Gleichrichtwert und Effektivwert
% 
% Anfangseinstellungen:
% Kanal IN1 : Funktionsgenerator: Sinus Us = 1 V, f = 500 Hz
% 
% '%' beginnt einen Kommentar
% ';' unterdrückt die Ausgabe einer Befehlszeile im Command Window
% '.' Führt mathematische Operationen elementweise aus
% 'close all' schließt alle figures
% 'clear all' löscht alle Variablen
% 'clc' leert das Command Window
% 'Startwert:Inkrement:Endwert' erzeugt einen Vektor
% 'cutperiod' Beschneidet einen Vektor auf ganze Perioden
% 'length' Länge eines Vektors
% 'mean' Arithmetischer Mittelwert
% 'max' Maximalwert
% 'abs' Betrag
% 'sqrt' Wurzel

clearvars, close all, clc

%  Korrekturwerte einsetzen

% Hier bitte richtige Werte einfügen 
U_off_corr_1=0.002152507822463;
U_off_corr_2=-0.001601462794531;
K_gain_corr_1=1.000228165021257;
K_gain_corr_2=1.000771051199381;

% Werte für die Einlesefunktion
N = 1000;
fs = 10000;
vrange = 2.5;

% Erzeugen des Stop-Button-Fensters
make_panel

% Konfiguration der Messhardware auf die gewünschten Parameter
% Diesmal wird ein Trigger verwendet um ein Stehendes Bild zu erreichen
reamio('configure',N,fs,vrange,'average',1,'rising',0);

% Erstellen des Zeitvektors t
t = (0:N-1)/fs;

% Schleife läuft bis Stop-Button gedrückt wird
while not_stop()
    
    % Einlesen von Kanal IN1 und Korrektur
    x = reamio('in',1);
    x = (x-U_off_corr_1)/K_gain_corr_1;
    
    % 'cutperiod' schneided Werte eines Vektors ab die nicht zu einem
    % ganzzahligen Vielfachen der Periodendauer des Signals gehören
    % wichtig für die Einhaltung der Integrationsgrenzen
    x_cutperiod = cutperiod(x);
    
    % Erstellen des beschnittenen Zeitvektors t
    t_cutperiod = (0:length(x_cutperiod)-1)/fs;
    
    % Darstellung des Eingangssignals und des beschnittenen Eingangssignals
    sfigure(1)  %'sfigure' stiehlt bei einer Aktualisierung nicht den Fokus
    plot(t,x,'r--',...
        t_cutperiod,x_cutperiod,'b')
    title('Vergleich des Eingangssignals x(t) und des beschnittenen Eingangssignals ')
    xlabel('t in s')
    ylabel('x(t), x_{cutperiod}(t)')
    grid on
    
    % Berechnung der Kennwerte von x
    % Benutzen Sie immer 'x_cutperiod' um die Integrationsgrenzen einzuhalten 
    % Hier bitte Code ergänzen
    N_cutperiod = length(x_cutperiod);                   %Länge von Vektor x nach cutperiod
    x_max = max(x_cutperiod);                        %Maximalwert von x
    x_mean = mean(x_cutperiod);                       %Arithmetischer Mittelwert von x
    x_gleichricht = 1 / N_cutperiod * sum(abs(x_cutperiod));                %Gleichrichtwert von x
    x_effektiv =  sqrt(1 / N_cutperiod * sum(x_cutperiod.^2));                    %Effektivwert von x
    
    x_wechselanteil = x_cutperiod - x_mean;              %Wechselanteil von x
    
    x_effektiv_wechsel = sqrt(mean(x_wechselanteil.^2));            %Effektivwert des Wechselanteils von x
    x_gleichricht_wechsel = mean(abs(x_wechselanteil));        %Gleichrichtwert des Wechselanteils von x
    x_amplitude_wechsel = max(x_wechselanteil);          %Amplitude des Wechselanteils von x
    
    F = x_effektiv_wechsel / x_gleichricht_wechsel;                            %Formfaktor des Wechselanteils von x
    C = x_amplitude_wechsel / x_effektiv_wechsel;                            %Scheitelfaktor (Crestfaktor) des Wechselanteils von x
    
    % Anzeigen der Kennwerte im Stop-Button-Fenster
    % Werte die in die Variablen out{1} bis out{10} geschrieben werden
    % werden im Stop-Button-Fenster angezeigt
    out{1} = N_cutperiod;
    out{2} = x_max;
    out{3} = x_mean;
    out{4} = x_gleichricht;
    out{5} = x_effektiv;
    out{6} = x_effektiv_wechsel;
    out{7} = x_amplitude_wechsel;
    out{8} = F;
    out{9} = C;
    
end