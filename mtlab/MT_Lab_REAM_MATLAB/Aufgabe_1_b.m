% Aufgabe 1b: �berpr�fung der Ausgabefunktion
% 
% Anfangseinstellungen:
% Kanal OUT1: Oszilloskop
% 
% '%' beginnt einen Kommentar
% ';' unterdr�ckt die Ausgabe einer Befehlszeile im Command Window
% 'close all' schlie�t alle figures
% 'clear all' l�scht alle Variablen
% 'clc' leert das Command Window
% 'Startwert:Inkrement:Endwert' erzeugt einen Vektor
% 'pause' pausiert die Ausf�hrung

clearvars, close all, clc

% Erzeugt ein Fenster mit einem Stop-Button
% Solange der Button nicht gedr�ckt ist liefert die Funktion 'not_stop'
% true, wird er gedr�ckt liefert sie ein false
make_panel

% while-Schleife, l�uft solange der Stop-Button nicht gedr�ckt wurde
% Schleifen ben�tigen immer ein 'end'-Statement
while not_stop()            % �berpr�ft den Status des Stopp-Buttons
    
    u1 = 0:0.5:5;
    
    % for-Schleife
    for i_count = 1 : length(u1)    % u1 l�uft von 0 bis 5 in 1 Schritten
        
        % Ausgeben der Variable u1 auf OUT1
        reamio('out',1,u1(i_count));  
        
        % Pausiert die Ausf�hrung f�r 50ms
        % unterst�tz nur 10ms Schritte, daher etwas ungenau, siehe
        % Oszilloskop
        % Hier bitte Werte anpassen
        pause(0.1);

    end
end
