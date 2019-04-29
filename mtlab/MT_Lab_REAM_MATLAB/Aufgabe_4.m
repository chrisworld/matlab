% Aufgabe 4: Darstellen eines Betragsspektrums, Demonstration des
% Aliasing-Effektes
% 
% Anfangseinstellungen:
% Kanal IN1 : Funktionsgenerator: Sinus Us = 1 V, f = 1 kHz
% 
% '%' beginnt einen Kommentar
% ';' unterdrückt die Ausgabe einer Befehlszeile im Command Window
% 'close all' schließt alle figures
% 'clear all' löscht alle Variablen
% 'clc' leert das Command Window
% 'Startwert:Inkrement:Endwert' erzeugt einen Vektor
% 'length' Länge eines Vektors
% 'mean' Arithmetischer Mittelwert
% 'max' Maximalwert
% 'abs' Betrag
% 'sqrt' Wurzel
% 'fft' Diskrete Fouriertransformation
% 'fftshift' vertausche obere und untere Vektorhälfte
% 'interpft' Führt eine Sinc-Interpolation durch

clearvars, close all, clc

%  Korrekturwerte einsetzen
U_off_corr_1=0.002152507822463;
U_off_corr_2=-0.001601462794531;
K_gain_corr_1=1.000228165021257;
K_gain_corr_2=1.000771051199381;

% Werte für die Einlesefunktion
N = 1000;
fs = 10000;
vrange = 2.5;

% Sonstige Variablen
upsample_factor = 100;
N_upsampled = N * upsample_factor;
fs_upsampled = fs * upsample_factor;

% Erzeugen des Stop-Button-Fensters
make_panel

% Konfiguration der Messhardware auf die gewünschten Parameter
% Diesmal wird ein Trigger verwendet um ein Stehendes Bild zu erreichen
reamio('configure',N,fs,vrange,'average',1,'rising',0.5)

% Erstellen des Zeitvektors t
t = (0:N-1)/fs;

% Erstellen des upgesampleden Zeitvektors t_upsampled
t_upsampled = (0:N_upsampled-1)/fs_upsampled;

% Erstellen des Frequenzvektors f in kHz
    % Hier bitte Code ergänzen
f = (-fs/2 : fs/N: fs/2-(fs/N)) / 1000;

% Schleife läuft bis Stop-Button gedrückt wird
while not_stop()

    % Einlesen von Kanal IN1 und Korrektur
    x = reamio('in',1);
    x = (x-U_off_corr_1)/K_gain_corr_1;
    
    % Betragsspektrum von x
    % Hier bitte Code ergänzen
    X = fftshift(abs(fft(x))) / N;
    
    % Sinc-Interpolation von x
    % Hier bitte Code ergänzen
    x_upsampled = interpft(x, N_upsampled);
    
    sfigure(1)
    plot(t,x)
    title('x(t)')
    xlabel('t in s')
    ylabel('x(t) in V')
    grid on
    
    sfigure(2)
    plot(f,X)
    title('|X(f)| - Betragsspektrum von x')
    xlabel('f in kHz')
    ylabel('|X(f)| in Volt')
    grid on
    
    % Darstellung des Interpolierten Signals x_upsampled(t) und des
    % ursprünglichen Signals x(t) strichliert
    sfigure(3)
    plot(t_upsampled,x_upsampled,...
        t, x, '.--')
    title('x_{upsampled}(t) - Sinc-Interpolation von x(t)')
    xlabel('t in s')
    ylabel('x(t), x_{upsampled}(t) in V')
    grid on
    
end