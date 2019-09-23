clear all;
close all;
clc;

load("./angabe/SSP_HW3_EX1.mat")
% who

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

% system params
m = 1;
c = 1;
d = 0.1;

% sampling
fs = 100;

% noise model
mu1 = 0;
sigm1 = 0.05;

% transition matrix phi
phi = [1, 1/fs; 0, 1];

% measurement vector
C = [1, 0];

% estimates
x_est = zeros(2, length(y1));

for k = 2 : length(y1)
  x_est(:, k) = phi * x_est(:, k - 1);
end

% measurement matrix
H = [1];



