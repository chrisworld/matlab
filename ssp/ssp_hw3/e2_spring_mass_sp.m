clear all;
%close all;
clc;

% packages for octave
pkg load control

% plot config
fig_size_long = [1000, 0, 900, 400];

% --
% data

load("./angabe/SSP_HW3_EX2.mat")
% who

% system params
m_approx = 1;
c = 1;
d = 0.1;

% sampling
fs = 100;
Ts = 1/fs;
t = 0 : Ts : length(y1) * Ts - Ts;

% measurement noise
sigm1 = 0.02;


% --
% mixted state estimation or state parameter estimation

% system model
A = @(m) [0, 1, 0; -c/m, -d/m, 0; 0, 0, 0];
b = @(m) [0; 1/m; 0];
ct = [1, 0, 0];


% measurement vector
C = [1, 0, 0];

% cov. matrice init values
P = diag([1 1 1]);

% process noise
Q = diag([0.001 0.001 0.001]);

% measurement noise
R = diag(sigm1^2);

% transition matrix
Phi = @(m) expm(A(m) * Ts);

% estimates
x_est_sp = zeros(3, length(y1));
x_est_sp(:, 1) = [0; 0; m_approx];

% Kalman filter
for k = 2 : length(y1)

  % prediction
  xs = Phi(x_est_sp(3, k - 1)) * x_est_sp(:, k - 1);

  % Numerical Evaluation of Jacobian
  J = zeros(length(x_est_sp(:, k - 1)));
  delta = 0.01;
  for jj = 1:length(x_est_sp(:, k - 1))
    xt = x_est_sp(:, k - 1);
    
    xt(jj) = x_est_sp(:, k - 1)(jj) + delta;        
    Phixp = Phi(xt(3)) * xt;
    
    xt(jj) = x_est_sp(:, k - 1)(jj) - delta;        
    Phixm = Phi(xt(3)) * xt;
    
    J(:, jj) = (Phixp - Phixm) / (2 * delta);
  end

  % other kalman equations with EKF
  Ps = J * P * J' + Q;
  Kk = Ps * C' * inv(C * Ps * C' + R);
  x_est_sp(:, k) = xs + Kk * (y1(k) - C * xs);
  P = (eye(length(xs)) - Kk * C) * Ps;
end

m_est = x_est_sp(3, end)



% --
% plots
%%{
figure (1, 'position', fig_size_long)
plot(t, y1,'LineWidth', 1.5)
set(gca,'FontSize',12)
ylabel('Position x [m]', 'fontsize', 16)
xlabel('Time [s]', 'fontsize', 16)
grid on
ylim([-1.5, 1.5])
%print(['pos'],'-dpng', '-S900,400')

figure (2, 'position', fig_size_long)
plot(t, x_est_sp(2, :), 'LineWidth', 1.5)
set(gca,'FontSize',12)
ylabel('Velocity [m/s]', 'fontsize', 16)
xlabel('Time [s]', 'fontsize', 16)
grid on
ylim([-1.5, 1.5])
%print(['velo'],'-dpng', '-S900,400')

figure (3, 'position', fig_size_long)
plot(t, x_est_sp(3, :), 'LineWidth', 1.5)
set(gca,'FontSize',12)
ylabel('Mass [kg]', 'fontsize', 16)
xlabel('Time [s]', 'fontsize', 16)
grid on
%print(['mass'],'-dpng', '-S900,400')
%}
