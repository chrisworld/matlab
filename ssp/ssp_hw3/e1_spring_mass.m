clear all;
close all;
clc;

% packages for octave
pkg load control

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

%{
figure 11
hold on
plot(y1, '-r')
plot(x_est_kf(1, :), '-b')
plot(x_est_kf(2, :), '--b')
legend('y1', 'x est kf', 'velocity')
%}


%
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

%{
figure 12
hold on
plot(y2, '-r')
plot(y3, '-r')
plot(x_est_sf(1, :), '-b')
plot(x_est_sf(2, :), '--b')
legend('y1', 'x est kf', 'velocity')
%}

%{
figure 13
hold on
plot(x_est_kf(1, :), '-r')
plot(x_est_sf(1, :), '-b')
legend('x kf', 'x sf')
%}


%
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

%{
figure 21
hold on
plot(x_est_sys(1, :), '-r')
plot(y1, '-b')
legend('x sys', 'y1')
%}

%%{
figure 22
hold on
plot(x_est_sys(2, :), '-r')
plot(x_est_kf(2, :), '-b')
plot(vtrue, '-k', 'linewidth', 2)
legend('v sys', 'v kf', 'v true')
%}