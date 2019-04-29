% Aufgabe 1b: Überprüfung der Ausgabefunktion
% 
% Anfangseinstellungen:
% Kanal OUT1: Oszilloskop
% 
% '%' beginnt einen Kommentar
% ';' unterdrückt die Ausgabe einer Befehlszeile im Command Window
% 'close all' schließt alle figures
% 'clear all' löscht alle Variablen
% 'clc' leert das Command Window
% 'Startwert:Inkrement:Endwert' erzeugt einen Vektor
% 'pause' pausiert die Ausführung

clearvars, close all, clc

% Erzeugt ein Fenster mit einem Stop-Button
% Solange der Button nicht gedrückt ist liefert die Funktion 'not_stop'
% true, wird er gedrückt liefert sie ein false
make_panel

% while-Schleife, läuft solange der Stop-Button nicht gedrückt wurde
% Schleifen benötigen immer ein 'end'-Statement
while not_stop()            % Überprüft den Status des Stopp-Buttons
    
    u1 = 0:0.5:5;
    
    % for-Schleife
    for i_count = 1 : length(u1)    % u1 läuft von 0 bis 5 in 1 Schritten
        
        % Ausgeben der Variable u1 auf OUT1
        reamio('out',1,u1(i_count));  
        
        % Pausiert die Ausführung für 50ms
        % unterstütz nur 10ms Schritte, daher etwas ungenau, siehe
        % Oszilloskop
        % Hier bitte Werte anpassen
        pause(0.1);

    end
end
