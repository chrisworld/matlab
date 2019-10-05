clear all;
close all;
clc;

% packages for octave
% did not work with optim
pkg load optim

% measurements [Q1 Q2 Q3 Q4]
d_tilde = [100; 30; 60; 110];

% uncertainty of measurements
u_q = [1.5 2 2 4];

% covariance matrix
sigm = diag(u_q .^ 2);

% measurement matrix
H = eye(4);

% map estimator function
map = @(x) (H * x - d_tilde)' * inv(sigm) * (H * x - d_tilde);

% start value 
x0 = zeros(4, 1);

% equalities for optimation
Aeq = [1 0 0 -1; 1 -1 -1 0; 0 0 0 0; 0 0 0 0];
beq = zeros(4, 1);

% calculate optimum
x_hat = fmincon(map, x0, [], [], Aeq, beq)

% results:
% 99.0110
% 34.5055
% 64.5055
% 99.0110


% --
% non redundant state vector

H = [1 0; 0 1; 1 -1; 1 0];

% ML estimate, since no prior conditions
x_hat_nr = inv(H' * inv(sigm) * H) * H' * inv(sigm) * d_tilde  

% results:
% 99.011
% 34.505


% --
% Q3 under maintenance

H = eye(4);

% remove Q3 from the measurements
H(3, :) = [];
u_q(3) = [];

% calculate optimum
x_hat = fmincon(map, x0, [], [], Aeq, beq)

% results:
% 99.0110
% 34.5055
% 64.5055
% 99.0110


