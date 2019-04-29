% Matlab Interface zur REAMIO-Hardware f�r die REAM �bung im MT-Labor
% 
% Konfigurieren der REAMIO-Messbox
%     reamio('configure',N,fSample,VRange,SampleMethod)
%         'configure' - W�hlt den Konfigurationsmodus der Funktion
%         N - Anzahl der zu lesenden Samples (1-1000000)
%         fSample - Sample-Frequenz (1-2000000)
%         VRange - Eingangsspannungsbereich (2.5 oder 25)
%         SampleMethod - Sample-Methode ('decimate', 'average' oder 'minmax')
% 
% Konfigurieren der REAMIO-Messbox mit Trigger
%     reamio('configure',N,fSample,Vrange,SampleMethod,TrigChannel,TrigCondition,TrigLevel)
%         TrigChannel - Eingangs-Channel auf den getriggert werden soll (1 oder 2)
%         TrigCondition - Trigger auf steigende oder fallende Flanke ('rising' oder 'falling')
%         TrigLevel - Trigger-Level (-25 - 25)
% 
% Einlesen von einem Kanal der REAMIO-Messbox
%     x = reamio('in',InChannel)
%         'in' - W�hlt den Einlesemodus der Funktion
%         InChannel - Channel von dem gelesen werden soll (1, 2 oder 12)
%  
% Einlesen von beiden Kan�len der REAMIO-Messbox
%     [x1 x2] = reamio('in',InChannel)
% 
% Ausgeben auf einem Kanal der REAMIO-Messbox 
%     reamio('out',OutChannel,OutValue)
%         'out' - W�hlt den Ausgabemodus der Funktion
%         OutChannel - Channel auf dem ausgegeben werden soll (1 oder 2)
%         OutValue - Spannungswert der ausgegeben werden soll (-5 - 5)
%     
% Anzeigen der internen Sensor-Messwerte der REAMIO-Messbox
%     reamio('aio')