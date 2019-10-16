clear all;
close all;
clc;

% packages for octave
pkg load control

% plot config
fig_size_long = [1000, 0, 900, 400];

%
% data

load("./angabe/SSP_HW3_EX1.mat")
% who

% system params
m = 1;
c = 1;
d = 0.1;

% sampling
fs = 100;
Ts = 1/fs;
t = 0 : Ts : length(y1) * Ts - Ts;

%
% analyze data
%{
figure 1
hold on
plot(xtrue, '-r')
plot(y1)

figure 2
hold on
plot(vtrue, '-r')
plot(y2)

figure 3
hold on
plot(y3, '-r')

%%}
figure 4
hold on
plot(y1, '-b')
plot(y2, '-r')
plot(y3, '-g')
%}


%
% ordinary kalman filter

% noise model
mu1 = 0;
sigm1 = 0.05;

% transition matrix phi
Phi = [1, Ts; 0, 1];

% measurement vector
C = [1, 0];

% cov. matrice init values
P = diag([1 1]);

% process noise
Q = diag([0.001 0.001]);

% measurement noise
R = diag(sigm1^2);

% input function
%H = [1];

% estimates
x_est_kf = zeros(2, length(y1));
x_est_kf(:, 1) = [0; 0];

% Kalman filter
for k = 2 : length(y1)
  xs = Phi * x_est_kf(:, k - 1);
  Ps = Phi * P * Phi' + Q;
  Kk = Ps * C' * inv(C * Ps * C' + R);
  x_est_kf(:, k) = xs + Kk * (y1(k) - C * xs);
  P = (eye(length(xs)) - Kk * C) * Ps;
end


% --
% sensor fusion

% incorporated in measurement vector
C = [1, 0; 1,0];

% estimates for sensor fusion with kf
x_est_sf = zeros(2, length(y1));
x_est_sf(:, 1) = [0; 0];

% Kalman filter
for k = 2 : length(y1)

  % prediction
  xs = Phi * x_est_sf(:, k - 1);

  % measurement noise
  sigm2 = 0.1 * abs(xs(1)) + 0.01;
  sigm3 = -0.1 * (abs(xs(1)) - 1) + 0.01;
  R = diag([sigm2^2 sigm3^2]);

  % other kalman equations
  Ps = Phi * P * Phi' + Q;
  Kk = Ps * C' * inv(C * Ps * C' + R);
  x_est_sf(:, k) = xs + Kk * ([y2(k); y3(k)] - C * xs);
  P = (eye(length(xs)) - Kk * C) * Ps;
end


% --
% system matrix

A = [0, 1; -c/m, -d/m];
b = [0; 1/m];
ct = [1, 0];

%sys = ss(A, b, ct);

% measurement vector
C = [1, 0];

% cov. matrice init values
P = diag([1 1]);

% process noise
Q = diag([0.001 0.001]);

% measurement noise
R = diag(sigm1^2);

% transition matrix
Phi = expm(A * Ts)

% estimates
x_est_sys = zeros(2, length(y1));
x_est_sys(:, 1) = [0; 0];

% Kalman filter
for k = 2 : length(y1)
  xs = Phi * x_est_sys(:, k - 1);
  Ps = Phi * P * Phi' + Q;
  Kk = Ps * C' * inv(C * Ps * C' + R);
  x_est_sys(:, k) = xs + Kk * (y1(k) - C * xs);
  P = (eye(length(xs)) - Kk * C) * Ps;
end


% plots position
%{
figure (11, 'position', fig_size_long)
hold on
plot(t, xtrue, '-k', 'LineWidth', 2)
plot(t, x_est_kf(1, :), '-b')
set(gca,'FontSize',12)
title('Discrete Time State Space Model', 'fontsize', 16)
ylabel('Position x [m]', 'fontsize', 16)
xlabel('Time [s]', 'fontsize', 16)
legend('x true', 'x est kf')
grid on
%print(['pos'],'-dpng', '-S900,400')

%%{
figure (21, 'position', fig_size_long)
hold on
plot(t, xtrue, '-k', 'LineWidth', 2)
plot(t, x_est_sf(1, :), '-b')
set(gca,'FontSize',12)
title('Sensor Fusion', 'fontsize', 16)
ylabel('Position x [m]', 'fontsize', 16)
xlabel('Time [s]', 'fontsize', 16)
legend('x true', 'x est sf')
grid on
%print(['pos'],'-dpng', '-S900,400')

%%{
figure (31, 'position', fig_size_long)
hold on
plot(t, xtrue, '-k', 'LineWidth', 2)
plot(t, x_est_sys(1, :), '-b')
set(gca,'FontSize',12)
title('System Matrix', 'fontsize', 16)
ylabel('Position x [m]', 'fontsize', 16)
xlabel('Time [s]', 'fontsize', 16)
legend('x true', 'x est sys')
grid on
%print(['pos'],'-dpng', '-S900,400')
%}



% plots velocity
%%{
figure (12, 'position', fig_size_long)
hold on
plot(t, vtrue, '-k', 'LineWidth', 2)
plot(t, x_est_kf(2, :), '-b')
set(gca,'FontSize',12)
title('Discrete Time State Space Model', 'fontsize', 16)
ylabel('Velocity [m/s]', 'fontsize', 16)
xlabel('Time [s]', 'fontsize', 16)
legend('v true', 'v est kf')
grid on
%print(['v_dtss'],'-dpng', '-S900,400')
%}

%%{
figure (22, 'position', fig_size_long)
hold on
plot(t, vtrue, '-k', 'LineWidth', 2)
plot(t, x_est_sf(2, :), '-b')
set(gca,'FontSize',12)
title('Sensor Fusion', 'fontsize', 16)
ylabel('Velocity [m/s]', 'fontsize', 16)
xlabel('Time [s]', 'fontsize', 16)
legend('v true', 'v est sf')
grid on
%print(['v_sf'],'-dpng', '-S900,400')
%}

%%{
figure (32, 'position', fig_size_long)
hold on
plot(t, vtrue, '-k', 'LineWidth', 2)
plot(t, x_est_sys(2, :), '-b')
set(gca,'FontSize',12)
title('System Matrix', 'fontsize', 16)
ylabel('Velocity [m/s]', 'fontsize', 16)
xlabel('Time [s]', 'fontsize', 16)
legend('v true', 'v est sys')
grid on
%print(['v_sys'],'-dpng', '-S900,400')
%}


% compare
figure (4, 'position', fig_size_long)
hold on
plot(t, vtrue, '-k', 'LineWidth', 3)
plot(t, x_est_kf(2, :), '-b', 'LineWidth', 1.5)
plot(t, x_est_sf(2, :), '-m', 'LineWidth', 1.5)
plot(t, x_est_sys(2, :), '-r', 'LineWidth', 1.5)
set(gca,'FontSize',12)
title('Comparison', 'fontsize', 16)
ylabel('Velocity [m/s]', 'fontsize', 16)
xlabel('Time [s]', 'fontsize', 16)
legend('v true', 'v est kf', 'v est sf', 'v est sys')
xlim([3 10])
ylim([-1 1])
grid on
%print(['v_comp'],'-dpng', '-S900,400')
