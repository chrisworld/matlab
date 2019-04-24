% clear all
clear all;
close all;
clc


% signal parameters
A = [1 1 1];
f = [11 27 46];
fii = [0 0 0];

% sampling and time
fs = 100

t_len = 100
% faster, but less accurate:
t_len = 10

Ts = 1 / fs 

% time and frequency vector
t_x = 0 : Ts : t_len;
f_x = 0 : fs / length(t_x) : fs - fs / length(t_x);

% create signals
s = zeros(length(A), length(t_x));
for idx = 1 : size(s, 1)
  s(idx, :) = A(idx) * sin(2 * pi * f(idx) * t_x + fii(idx));
end

% sum the signals
s_sum = sum(s);


% DFT
%tic
S_SUM = custom_dft(s_sum);
%toc

% IDFT
%tic
s_sum_idft = custom_idft(S_SUM);
%toc


% plot the stuff
x_lim_time = [0 0.5];
y_lim_time = [-3 3];

% %{
figure 1
plot(f_x, abs(S_SUM))
grid on
ylabel('Amplitude')
xlabel('Frequency [Hz]')
%print('DFT_signals', '-dpng')

% %{
figure 2
plot(t_x, s_sum)
grid on
ylabel('Amplitude')
xlabel('Time [s]')
xlim(x_lim_time)
ylim(y_lim_time)
%print('time_signals', '-dpng')

% %{
figure 3
plot(t_x, s_sum_idft)
grid on
ylabel('Amplitude')
xlabel('Time [s]')
xlim(x_lim_time)
ylim(y_lim_time)
%print('IDFT_signals', '-dpng')
%}


% -----
% Downsampling


down_sample_factor = 2;
s_sum_down = downsample(s_sum, down_sample_factor);
f_x_down = downsample(f_x, down_sample_factor);
t_x_down = downsample(t_x, down_sample_factor);

% %{

% DFT
S_SUM_DOWN = custom_dft(s_sum_down);

% IDFT
s_sum_down_idft = custom_idft(S_SUM_DOWN);


figure 4
plot(f_x_down, abs(S_SUM_DOWN))
grid on
ylabel('Amplitude')
xlabel('Frequency [Hz]')
%print('DFT_down', '-dpng')

% %{
figure 5
plot(t_x_down, s_sum_down_idft)
grid on
ylabel('Amplitude')
xlabel('Time [s]')
xlim(x_lim_time)
ylim(y_lim_time)
%print('IDFT_down', '-dpng')

%}


% -----
% Anti-Aliasing filter
n_order = 25;
f_cut = 40;

% get filter coeffs
h = fir1(n_order, f_cut / fs * 2);

% apply filtering
y = filter(h, 1, s_sum);
y_down = downsample(y, down_sample_factor);

% check filter
%freqz(h, 1)

% DFT
Y = custom_dft(y);
Y_DOWN = custom_dft(y_down);

% IDFT
y_idft = custom_idft(Y);
y_down_idft = custom_idft(Y_DOWN);


% %{
figure 6
plot(f_x, abs(Y))
grid on
ylabel('Amplitude')
xlabel('Frequency [Hz]')
%print('DFT_filter', '-dpng')

% %{
figure 7
plot(t_x, y_idft)
grid on
ylabel('Amplitude')
xlabel('Time [s]')
xlim(x_lim_time)
ylim(y_lim_time)
%print('IDFT_filter', '-dpng')

figure 8
plot(f_x_down, abs(Y_DOWN))
grid on
ylabel('Amplitude')
xlabel('Frequency [Hz]')
%print('DFT_filter_down', '-dpng')

% %{
figure 9
plot(t_x_down, y_down_idft)
grid on
ylabel('Amplitude')
xlabel('Time [s]')
xlim(x_lim_time)
ylim(y_lim_time)
%print('IDFT_filter_down', '-dpng')

%}




% -----
% resampling

% %{
resample_factor = 2;
s_sum_res = resample(s_sum, 1, resample_factor);
f_x_res = resample(f_x, 1, resample_factor);
t_x_res = resample(t_x, 1, resample_factor);


% DFT
S_SUM_RES = custom_dft(s_sum_res);

% IDFT
s_sum_res_idft = custom_idft(S_SUM_RES);

% %{
figure 10
plot(f_x_down, abs(S_SUM_RES))
grid on
ylabel('Amplitude')
xlabel('Frequency [Hz]')
%print('DFT_resample', '-dpng')

% %{
figure 11
plot(t_x_down, s_sum_res_idft)
grid on
ylabel('Amplitude')
xlabel('Time [s]')
xlim(x_lim_time)
ylim(y_lim_time)
%print('IDFT_resample', '-dpng')

%}