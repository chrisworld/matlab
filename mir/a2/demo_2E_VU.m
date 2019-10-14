% Demo: Frequenzauflösung aus STFT versus parabolische Interpolation bzw. 
%       Ableitung der Momentanfrequenz aus Phasendifferenz benachbarter STFT-Frames

%% Aufbau einer Transformationsmatrix 
% Blocktransformmatrix Nachbildung der FFT 
% Basisfunktion der Transformationsmatrix
clear variables
close all

% --
% octave stuff
pkg load signal

% --
% some functions, put down in matlab

% --
% phase
function phase = princarg(phasein) 
  % phase => ]-pi,pi]
  phase = mod(phasein + pi, -2 * pi) + pi;
  % see DAFX Book, Zölzer, p.262
end

% --
% db function
function d = db(A)
  d = 10 * log10(A);
end

% --
% parabol interpolation
function [_alpha, _beta, _gamma, _k] = parabol_interp(X, p)

  % gamma
  _gamma = 0.5 * (abs(X(p-1)) - abs(X(p+1))) / (abs(X(p-1)) - 2 * abs(X(p)) + abs(X(p+1)));
  
  % middle point
  _k = p - 1 + _gamma;

  % correction
  _alpha = (abs(X(p-1)) - abs(X(p))) / ( 1 + 2 * _gamma);
  _beta = abs(X(p)) - _alpha * _gamma^2;

end

% --
% coding starts here

% for fft
compFreq = @(k,N) exp(i*2*pi*k./N*[0:N-1]); % Kernfunktionen / orthogonale komplexe Schwingungen

%figure, plot(real(compFreq(10,1024))), grid on, title('Realteil der 11. komplexen Schwingung')

% Aufbau der Transformationsmatrix
N = 1024;
H = compFreq([0:N-1]', N);

% for ii = 1:N
%     H(ii,:) = compFreq(ii-1,N); % k = 0, ..., N-1
% end

% plot
%{
figure, plot(real(H(1:5,:))'),title('Realteil der ersten fünf Basis/Kernfunktionen'),grid on
legend({'k=0','k=1','k=2','k=3','k=4'})
%}

% --
% Signalmodell

%k_test = 10;      % Wahl der digitalen Frequenz ident. mit Frequenz  einer Basisfunktion 
k_test = 10.35; % Wahl der digitalen Frequenz abweichend zu bestehenden Frequenzen der Basisfunktionen
x = cos(2*pi*k_test/N*[0:N-1]'); 


% --
% Signaltransformation

X = H * x; % Kurzzeitfuriertransformation des Signalmodells in den Bildbereich

% plot
%%{
figure, plot(abs(X)),title('resultierendes Gesamtspektrum OHNE Normierung inkl. pos. und neg. Frequenzen'); 
figure, stem(2/N*abs(X)),title('resultierendes normiertes Gesamtspektrum inkl. pos. und neg. Frequenzen');
%}

%% Festlegen 
fs = 44100;
fk = k_test*fs/N;
dfreq = 0:fs/N:fs/2;

% plot
%{
figure, 
    stem(dfreq, 2/N*abs(X(1:end/2+1))), grid on,
    title('normiertes Linienspektrum (pos. Frequenzen)');
    xlabel('Frequenz f/[Hz]'),ylabel('Betrag')
%}

% --
% Datensichtung / Stichproben
% fs/N*10   % Frequenz des 11. FFT-Bin 
% dfreq(11)
% 
% fs/N*11   % 
% fs/N*10.35 % Target
% 

Y = db(2 / N * abs(X(1:end/2+1)));

% plot
figure,plot(dfreq, Y),grid on,title('log. Betragsfrequenzgang'),ylabel('Betrag in dB'),xlabel('Frequenz f/[Hz]')
%{
figure,plot(dfreq,2/N*abs(X(1:end/2+1))),grid on,title('linearer Betragsfrequenzgang'),ylabel('Betrag'),xlabel('Frequenz f/[Hz]')
%}

% --
% Frequenzschätzung durch parabolische Interpolation

%[v, p] = findpeaks(Y, 'DoubleSided'); % 'SortStr','descend', 'NPeaks', 1
[v, p] = max(Y);

% parabol params
[alpha_log, beta_log, gamma_log, k_log] = parabol_interp(Y, p);
[alpha_lin, beta_lin, gamma_lin, k_lin] = parabol_interp(X, p);

% dono
fest_log = 44100/1024 * k_log
fest_lin = 44100/1024 * k_lin

Aest_log = 10^(beta_log / 20)
A_stft = 10^(Y(p) / 20)

Aest_lin = beta_lin * 2 / N

DFT_Koeff = x' * exp(i * 2 * pi * (k_test) / N * [0:N-1]');
Aest_DFT_k_test = abs(DFT_Koeff)*2/N

DFT_Koeff = x' * exp(i * 2 * pi * (k_log) / N * [0:N-1]');
Aest_DFT_k_log = abs(DFT_Koeff)*2/N

% Amplitude der Signalkomponente 
% aus Energie in der Hauptkeule bestimmen ...

% aus den Effektivwerten innerhalb der Hauptkeule
sqrt(sum((abs(X(p-1:p+1)) .* 2 / N .* 1 / sqrt(2)) .^ 2)) * sqrt(2) 

% aus den Spitzenwerten berechnet !
sqrt(sum((abs(X(p-1:p+1)) .* 2 / N) .^ 2))                    

% --
% Momentanfrequenz
OL = N - 512; % Overlap
R = N - OL;   % Hopsize in Samples

% lfd. Index für berechnete/evaluierte Frequenzen
jj = 1;     

% digitale Frequenz k = [0,N/2] und nicht FFT-Bin Index !
for k = 1.1 : 0.1 : 40     

  % Signalmodell
  x = cos(2 * pi * k / N * [0:2*N-1]'); 

  % Evaluierte Frequenz
  freq_target = fs / N * k;         

  % buffer
  xbuff = buffer(x, N, OL, 'nodelay');
  Xbuff = H * xbuff;
  
  %{
  figure,
  title('Betrags- und Phasenfrequenzgang fuer analysierte Bloecke')
  subplot(2,1,1),plot(dfreq,abs(Xbuff(1:end/2+1,:))),legend({num2str([1:size(Xbuff,2)]')})
  ylabel('Betrag'),grid on
  subplot(2,1,2),plot(dfreq,unwrap(angle(Xbuff(1:end/2+1,:)))),legend({num2str([1:size(Xbuff,2)]')})
  ylabel('Phase'),xlabel('Frequenz f/Hz'),grid on
  %}

  %[v,p] = findpeaks(abs(Xbuff(1:end/2+1, 2)), 'DoubleSided'); % 'SortStr','descend','NPeaks',1
  [v, p] = max(abs(Xbuff(1:end/2+1, 2)));
  %disp(['Peak@ p = ' num2str(p)])
  
  phi = angle(Xbuff(p,:));  % Phasenwert an der Peak-Frequenz für alle Frames 
  % princarg(diff(phi)) % principal argument von phi(2.Frame)- phi(1.Frame), phi(3.Frame)- phi(2.Frame) usw.
  
  omega_k = 2 * pi * (p - 1) / N;
  delta_phi = omega_k * R - princarg(phi(2) - phi(1) - omega_k * R);

  % instantaneous frequency at the next frame  
  freq_instphase = delta_phi / (2 * pi * R) * fs; 
  
  erg(jj, 1) = freq_target;
  erg(jj, 2) = freq_instphase;
  
  jj = jj + 1;
end

figure,plot(erg(:,1),erg(:,2),'LineWidth',2,'Color','r')
hold on, line([erg(1,1),erg(end,1)],[erg(1,1),erg(end,1)],'LineWidth',4,'LineStyle',':')
legend('geschaetzte Frequenz','evaluierte Frequenz'),grid on
xlabel('Frequenz Vorgabe in Hz'),ylabel('Frequenz Schaetzung in Hz')
title('Gegenueberstellung Vorgabe und Schaetzung')

figure,plot(erg(:,1),erg(:,2)-erg(:,1),'LineWidth',2,'Color','r'),grid on
xlabel('Frequenz Vorgabe in Hz'),ylabel('Abweichung der Frequenz Schaetzung in Hz')
title('Abweichung der Schaetzung von der Vorgabe')





