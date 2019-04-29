% ================================
% Athor:    Christian walter
% Problem:  Uebung_0
% ================================

clear all;

% Parameter
B = 2*360;
N = -70;
rb = 2048

% TPC3/4 
CR = 3/4;
%rb = 2048 * CR;

% Messwerte TPC3/4
BER = [5.210*10^(-7) 1.674*10^(-6) 5.351*10^(-4) 1.933*10^(-2) 6.768*10^(-2) 9.174*10^(-2) 1.186*10^(-1) 1 1];
Pwlvl = [-7 -7.2 -7.5 -8 -8.2 -8.5 -9 -9.2 -9.5];
SN = [-55, -55.2, -55.5, -56, -56.2, -56.5, -57.3, -57.5 -57.5] - N;

SNR_Eb = SN * B/rb
BER_log = 10*log(BER);

% TPC7/8 
CR = 7/8;
%rb = 2048 * CR;

% Messwerte TPC7/8
BER2 = [4.185*10^(-7) 2.137*10^(-5) 2.243*10^(-3) 4.758*10^(-2) 6.935*10^(-2) 9.284*10^(-2) 1 1];
Pwlvl2 = [-6.5 -6.7 -7 -8 -8.5 -9 -9.2 -9.5];
SN2 = [-54, -54.2, -55, -55.5, -56, -56.5, -57.5, -57.5] - N;

SNR_Eb2 = SN2 * B/rb
BER2_log = 10*log(BER2);

% Ausgleichsgerade R(Polynom 1.Ordnung)
%p = polyfit(Pwlvl, BER_log, 2);
%pwr_extrap = (-9.5:0.1:-9);
%pwr_interp = (-9.0:0.1:-7);    % Stützstellen für Ausgleichskurve
p = polyfit(SNR_Eb, BER_log, 2);
pwr_extrap = (5.86:0.05:5.95);
pwr_interp = (5.95:0.05:7.1);    % Stützstellen für Ausgleichskurve
BER_extrap = polyval(p, pwr_extrap);
BER_interp = polyval(p, pwr_interp);

%p2 = polyfit(Pwlvl2, BER2_log, 2);
%pwr_extrap2 = (-9.5:0.1:-9);
%pwr_interp2 = (-9.0:0.1:-6.5);    % Stützstellen für Ausgleichskurve
p2 = polyfit(SNR_Eb2, BER2_log, 2);
pwr_extrap2 = (5.02:0.05:5.42);
pwr_interp2 = (5.42:0.05:6.5);    % Stützstellen für Ausgleichskurve
BER_extrap2 = polyval(p2, pwr_extrap2);
BER_interp2 = polyval(p2, pwr_interp2);

% -60db line code win
line_int = 5.3:0.05:7.3;
line = ones(length(line_int)) * -60;

% --- Figure tpc34
figure 1
hold on
%plot(Pwlvl, BER_log, 'b*', 'LineWidth', 1)  
plot(SNR_Eb, BER_log, 'b*', 'LineWidth', 1)  
plot(pwr_interp, BER_interp,  'b', 'LineWidth', 1)
plot(pwr_extrap, BER_extrap, 'b--')
title('BER Kurve mit 16QAM und TPC3/4')
legend('reale Messwerte', 'interpolierte Messwerte', 'kein BER messbar')
xlabel('Eb/N0 [dB]')
ylabel('10*log(BER) [dB]')
grid on
print('ber_tpc34','-dpng')
set(gca, 'XScale', 'log')

% --- Figure tpc78
figure 2
hold on
%plot(Pwlvl2, BER2_log, 'b*', 'LineWidth', 1)  
plot(SNR_Eb2, BER2_log, 'r*', 'LineWidth', 1)  
plot(pwr_interp2, BER_interp2,  'r', 'LineWidth', 1)
plot(pwr_extrap2, BER_extrap2, 'r--')
title('BER Kurve mit 16QAM und TPC7/8')
legend('reale Messwerte', 'interpolierte Messwerte', 'kein BER messbar')
xlabel('Eb/N0 [dB]')
ylabel('10*log(BER) [dB]')
grid on
print('ber_tpc78','-dpng')

% --- Figure
figure 3
hold on
plot(pwr_interp, BER_interp,  'b', 'LineWidth', 1)
plot(pwr_interp2, BER_interp2,  'r', 'LineWidth', 1)
plot(line_int, line,  '--k', 'LineWidth', 1)
title('BER Kurve mit 16QAM im Vergleich von TPC3/4 und TPC7/8')
legend('TPC3/4', 'TPC7/8', '10^(-6) Linie')
xlabel('Eb/N0 [dB]')
ylabel('10*log(BER) [dB]')
xlim([5.3 7.3])
grid minor
print('ber_tpc34_vs_tpc78','-dpng')

close all;