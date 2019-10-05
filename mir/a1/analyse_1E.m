
clear all
close all


% plot config
fig_size_long = [0, 0, 900, 400];

% user interface öffnen
% uiopen % oder
%[filename,filepath]=uigetfile('.mat');
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
% Filename und Pfad verbinden
filepath = 'angabe/';
filename = 'sig_1E.mat';
fn = strcat(filepath,filename);

% mat-file öffnen 
load(fn)

% Zeitinstanzen
t = 0 : 1 / sig_1E.fs : (length(sig_1E.data) - 1) / sig_1E.fs;

% analyse signal plot
%%{
%figure(1, 'position', fig_size_long)
figure(1, 'position', fig_size_long)
plot(t,sig_1E.data,'LineWidth', 1.5)
set(gca,'FontSize',12)
title('Datenrepraesentation im Zeitbereich','fontsize',16)
xlabel('Zeit t/[s]', 'fontsize', 16)
ylabel('lineare Amplitude', 'fontsize', 16)
grid on
%print('signal','-dpng')
%}

% Berechnung-Spektrum
S = abs(fft(sig_1E.data(1:sig_1E.fs))) * 2  / sig_1E.fs;

% analyse spectrum
%%{
figure(2, 'position', fig_size_long)
plot(0:(sig_1E.fs)/2, S(1:end/2+1),'LineWidth', 1.5)
set(gca,'FontSize',12)
title('Datenrepraesentation im Frequenzbereich','fontsize',16)
xlabel('Frequenz in f/[Hz]', 'fontsize', 16)
ylabel('Magnitude lin.', 'fontsize', 16)
grid on
%print(['signal_fft'],'-dpng', '-S900,400')
%}

% Auffinden der Signalkomponenten im Spektrum
S_index = find(S(1:end/2+1)>1);

% Amplitude
A = S(S_index);

% Frequenz
f = S_index - 1;


%{
[val pos]=findpeaks(S(1:end/2+1));  % .... liefert viele Peaks !!!
[val pos]=findpeaks(S(1:end/2+1),'MinPeakProminence',2); % liefert die 2 prom. Peaks 

A(1) = val(1);
A(2) = val(2);
f(1) = pos(1)-1;
f(2) = pos(2)-1;
%}


format shortG
disp(['Ergebnis lautet:'])
disp([num2str(round(A(1))) ':' ... 
  num2str(100*(A(1)-round(A(1)))) ' ' ...
  num2str(f(1)) '.' ...
  num2str(A(2)) '.' num2str(f(2)) '.'])
