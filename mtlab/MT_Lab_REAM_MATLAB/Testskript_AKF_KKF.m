% Testskript für AKF und KKF
% Daniel Laggner, 18.11.2016
% beinhaltet eine Demonstration für Laufzeitmessung mittels KKF und
% Rauschleistungsmessung mittels AKF



close all;
clear all;
clc;

%% Parameter
% Abtastzeit in s
Ts=0.001;

% Signallänge in s
signal_length=10;

% Zeitverschiebung in s
runtime = 10;

% Signalfrequenz in Hz
f = 1;

% Amplitude in V
A = 1;

% Offset in V
offset = 0;

% Sigma des Rauschens
noise = 0.5;

% 1 für Sinus, 2 für Rechteck, 3 für Dreieck
signalform = 3;





%% Zeitvektor und Verschiebungsvektor

t = [0:Ts:(signal_length+runtime)];

k=-length(t)+1:length(t)-1;

k=k*Ts;

%% Signals

% Sinussignal
if signalform == 1
x1 = A.*sin(2*pi*f*t)+offset;
end

% Rechtecksignal
if signalform == 2
x1 = A.*sign(sin(2*pi*f*t))+offset;
end

% Dreiecksignal
if signalform == 3
x1 = A.*asin(sin(2*pi*f*t))./max(asin(sin(2*pi*f*t)))+offset;
end



% Verrauschtes Signal
for i=1:length(t)
    x2(i)=x1(i)+noise*randn(1,1);
end


% Verzögertes Signal
x3=[zeros(1,(runtime)/Ts) x1(1:length(t)-runtime/Ts)];
% x3=x3(1:length(t));

x1= [x1(1:signal_length/Ts) zeros(1,runtime/Ts+1)];
x2= [x2(1:signal_length/Ts) zeros(1,runtime/Ts+1)];



%% Plots


figure(1)
plot(t,x1);
hold on;
grid on;
xlabel('Zeit in s');
ylabel('Spannung in V');
title('unverrauschtes Signal');

figure(2)
plot(t,x2);
hold on;
grid on;
xlabel('Zeit in s');
ylabel('Spannung in V');
title('verrauschtes Signal');


figure(3)
plot(t,x3);
hold on;
grid on;
xlabel('Zeit in s');
ylabel('Spannung in V');
title('verzögertes Signal');


%Berechnung KKF
x1x3=xcorr(x1,x3,'biased');
x2x3=xcorr(x2,x3,'biased');
x1x2=xcorr(x1,x2,'biased');

%Berechnung AKF
x1x1=xcorr(x1,'biased');
x2x2=xcorr(x2,'biased');

%% Plots

% AKF

figure(4)
plot(k,x1x1);
hold on;
grid on;
xlabel('Zeitverschiebung in s');
ylabel('|AKF| in V²');
title('AKF des unverrauschten Signals')

figure(5)
plot(k,x2x2);
hold on;
grid on;
xlabel('Zeitverschiebung in s');
ylabel('|AKF| in V²');
title('AKF des verrauschten Signals')


figure(6)
hold on;
plot(k,x1x1,'b--','LineWidth',3)
plot(k,x2x2,'r','LineWidth',1.5)
grid on;
xlabel('Zeitverschiebung in s');
ylabel('|AKF| in V²');
legend('AKF des unverrauschten Signals','AKF des verrauschten Signals')
title('Vergleich der AKF von verrauschtem und unverrauschtem Signal')

Signalleistung = max(x1x1)
Gesamtleistung = max(x2x2)
Rauschleistung = Gesamtleistung - Signalleistung
SNR = 10*log(Signalleistung/Rauschleistung)


% KKF

figure(7)
plot(k,x1x2);
hold on;
grid on;
xlabel('Zeitverschiebung in s');
ylabel('|KKF| in V²');
title('KKF des unverrauschten Signals mit verrauschtem Signal')

figure(8)
hold on;
plot(k,x1x3);
stem(-runtime,max(x1x3),'r','LineWidth',2);
grid on;
legend('KKF','Maximum bei Laufzeitunterschied','Location','SouthEast')
xlabel('Zeitverschiebung in s');
ylabel('|KKF| in V²');
title('KKF des unverrauschten Signals mit verzögertem Signal')

figure(9)
hold on;
plot(k,x2x3);
stem(-runtime,max(x2x3),'r','LineWidth',2);
grid on;
legend('KKF','Maximum bei Laufzeitunterschied','Location','SouthEast')
xlabel('Zeitverschiebung in s');
ylabel('|KKF| in V²');
title('KKF des verrauschten Signals mit verzögertem Signal')







