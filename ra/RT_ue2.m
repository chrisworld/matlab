
close all
clear all
clc

s = tf('s');

%{
%% Aufgabe 1, i)
figure
G1 = -8/s
G2 = -8
G3 = 1/s
bode(G1);
grid on

figure
nyquist(G1);


%% Aufgabe 1, ii)

G2 = 1/5*(s-200)/((s+2)*(s-20));

bode(G2);
grid on

figure
nyquist(G2);
%}

%% Aufgabe 1, iii)

G3 = -(s-10)/(2*s^2+22*s+20);

bode(G3);
grid on;

figure
nyquist(G3);

%{
%% Aufgabe1, Ortskurven

% Ortskurve nur für omega > 0 darstellen
opt = nyquistoptions;
opt.ShowFullContour = 'off';

figure;
subplot(2,2,1);
nyquist(G1, opt);

subplot(2,2,2);
nyquist(G2, opt);

subplot(2,2,3);
nyquist(G3, opt);

%% Aufgabe 2

P1 = (2-2*s)/((s+1)*(s+2));
P2 = -2*s/(s+1/2)^3;
P3 = -2*s/((s+1)*(s+2));
P4 = (2-2*s)/(s*(s-2)*(s+3));

figure
nyquist(P1, opt);
hold on
nyquist(P2, opt);
nyquist(P3, opt);
nyquist(P4, opt);

legend('P1', 'P2', 'P3', 'P4');
xlim([-4,2]);
ylim([-2,3]);
%}
