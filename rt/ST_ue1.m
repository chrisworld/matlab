clear all;
close all;
clc;

k1 = 1;
k2 = 1;
k3 = 1;

xR = [16, 16]';     %'Transformierte Matrix
uR = 4;

xR = [(k3*uR/k1)^2, (k3*uR/k2)^2]';

%% (a) 

A = 1/(2*k3*uR)*[-k1^2, 0; k1^2, -k2^2];
b = [k3; 0];
c = [0, 1];
d = 0;

Sys = ss(A, b, c, d);

%% (b)

x01 = [1, 0];

[~,~,x] = initial(Sys, x01);

figure;
hold on;
plot(x(:,1), x(:,2));

x02 = [0, 1];
[~,~,x] = initial(Sys, x02);
plot(x(:,1), x(:,2), 'r');

x03 = [-1, -1];
[~,~,x] = initial(Sys, x03);
plot(x(:,1), x(:,2), 'g');

grid on;
title('Trajektorien')
xlabel('x');
ylabel('y');
legend('x_{01}', 'x_{02}', 'x_{03}')

%% (c)

G = tf(Sys)

zpk(G)              %Pol und Nullstellen
nst = zero(G)
pst = pole(G)

%% (d)

figure;
[y,t] = step(Sys, 100);      %Sprungantwort

plot(t,y)


%% (e)

deltaU = 0.1
figure;
plot(t, y * deltaU);

deltaU = 1
figure;
plot(t, y * deltaU);


%% (f) Simulink Koppelplan


%% (g - i) Simulation von y(t) fr x0 und u(t) = us*Sigm(t)

x0 = [16, 16];
yR = 16;

ustep = 4.1;

sim('Simu_UE1.slx');

figure;
subplot(2, 1, 1)
hold on;
plot(simy.time, simy.signals.values)
deltaU = 0.1;
plot(t, y * deltaU+yR, 'red');

grid on;
title('y(t)')
xlabel('t');
ylabel('y');
legend('NL System', 'lin. System')

subplot(2, 1, 2)
plot(simu.time, simu.signals.values)
grid on;
title('u(t)')
xlabel('t');
ylabel('u');




%% (g - ii) Simulation von y(t) fr x0 und u(t) = us*Sigm(t)

x0 = [16, 16];
yR = 16;

ustep = 5;

sim('Simu_UE1.slx');

figure;
subplot(2, 1, 1)
hold on;
plot(simy.time, simy.signals.values)
deltaU = 1;
plot(t, y * deltaU+yR, 'red');

grid on;
title('y(t)')
xlabel('t');
ylabel('y');
legend('NL System', 'lin. System')

subplot(2, 1, 2)
plot(simu.time, simu.signals.values)
grid on;
title('u(t)')
xlabel('t');
ylabel('u');



%% (h)

t = [0:0.1:100];
u = exp(-0.5*t);

lsim(Sys, u, t)










