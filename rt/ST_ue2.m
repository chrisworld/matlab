clear all;
close all;
clc;

%% (a) lin. System

A = [0, -4; 1, -2];
b = [1; 0];
cT = [0,4];
d = 0;

%% (b) y(t) Sprungantwort

sim('simu_UE2.slx',5)

figure();
plot(tsim, ysim);
grid on;

%% (c) System mit Abtaster und Halteglied

Td = 0.05;
SysC = ss(A, b, cT, d);     %creates the discrete-time model
SysD = c2d(SysC, Td);       %discrete system  

%% (d) Sprungantwort des zeitdiskreten Systems (yk)

t = 0:Td:5;                 %time-vector
u = ones(1, length(t));     %step

[y,t] = lsim(SysD, u, t);

hold on;
stem(t, y, '*g', 'Color','green');

%% (e) Alternative zur Diskretisierung

Ad = eye(2) + Td * A;          %eye=Einheitsmatrix
bd = Td * b;
cTd = cT;
dd = d;

%% (f) verschiedene Abtastzeiten
title('Diskretisierung')
xlabel('t');
ylabel('y(t)');

SysDd = ss(Ad, bd, cTd, dd, Td);
[y,t] = lsim(SysDd, u, t);
plot(t, y, 'xr', 'Color','red')

%---------------------------------Td = 0.2
Td = 0.2;
t = 0:Td:5;                 %time-vector
u = ones(1, length(t));     %step

Ad = eye(2) + Td * A;
bd = Td * b;
cTd = cT;
dd = d;

SysDd1 = ss(Ad, bd, cTd, dd, Td);
[y,t] = lsim(SysDd1, u, t);
plot(t, y, 'xr', 'Color','blue')

%---------------------------------Td = 0.55
Td = 0.55;
t = 0:Td:5;                 %time-vector
u = ones(1, length(t));     %step

Ad = eye(2) + Td * A;
bd = Td * b;
cTd = cT;
dd = d;

SysDd1 = ss(Ad, bd, cTd, dd, Td);
[y,t] = lsim(SysDd1, u, t);
plot(t, y, 'xr', 'Color','magenta')


