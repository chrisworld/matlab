clear all;
close all;
clc;

% packages for octave
pkg load signal

% load data for octave
%load('mic_signals.mat');
load('mic_signals.mat');

% variables
c = 343;

% Time of flight calculation
toF = @(xm, xs) 1 / c * norm(xm - xs);

% objective function
function dt_ab = delta_t(A, B, t)
  % time
  T = length(t);
  dt = t(2);

  % correlation
  r_ab = xcorr(A, B);
  
  % maximum
  [~, idx_peak] = max(abs(r_ab));
  dt_ab = (T - idx_peak) * dt;
end

% plot signals
%{
figure, hold on, set(gca,'FontSize', 16),set(gcf,'Color','White');  
plot(t, S, 'LineWidth',2)
xlabel('t (s)')
ylabel('d (1)')
grid on
title('Signals')
legend('Mic 1: t_1','Mic 2: t_2','Mic 3: t_3')
axis tight
%}

% plot correlation
%{
r12 = xcorr(S(:, 1), S(:, 2));
r13 = xcorr(S(:, 1), S(:, 3));
r23 = xcorr(S(:, 2), S(:, 3));

figure 2, set(gca,'FontSize', 16),set(gcf,'Color','White');
plot(r12, 'LineWidth', 1.5)
xlabel('t (s)')
ylabel('d (1)')
title('r12')
grid on

figure 3, set(gca,'FontSize', 16),set(gcf,'Color','White');
plot(r13, 'LineWidth', 1.5)
xlabel('t (s)')
ylabel('d (1)')
title('r12')
grid on

figure 4, set(gca,'FontSize', 16),set(gcf,'Color','White');
plot(r23, 'LineWidth', 1.5)
xlabel('t (s)')
ylabel('d (1)')
title('r12')
grid on
%}

%
% position estimation

% init x source with reference mic
xs = [mic_pos(1, 1) mic_pos(3, 2)]

% vector
point_vec = @(a,b) (b - a);

% unit vector
e_ab = @(a, b) point_vec(a, b) / norm(point_vec(a, b));

% time to meter
soF = @(dt) dt * c;



% only for orthogonal mics

% time delay between the first mic and the other
dt = delta_t(S(:, 1), S(:, 2), t)

% unit vector in the direction of the mics
e = e_ab(mic_pos(1, :), mic_pos(2, :))

% mic pos
a = mic_pos(1, :);
b = mic_pos(2, :);

ds = e * soF(dt)
xs = xs + (point_vec(a, b) - ds) / 2


% time delay between the first mic and the other
dt = delta_t(S(:, 3), S(:, 4), t)

% unit vector in the direction of the mics
e = e_ab(mic_pos(3, :), mic_pos(4, :))

% mic pos
a = mic_pos(3, :);
b = mic_pos(4, :);

ds = e * soF(dt)
xs = xs + (point_vec(a, b) - ds) / 2







