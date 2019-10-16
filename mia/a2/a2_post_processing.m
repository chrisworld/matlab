clear variables
%close all

% load packages for octave
pkg load signal

% plot config
fig_size_long = [1000, 0, 900, 400];

% --
% params for signals
fs = 44100;
N = 1024;

% simple syntethic test signal
k = 40.22;
A = 3;
Nx = 2 * N;

% frequency and time vector
f = 0 : fs/N : fs/2;
t = 0 : 1/fs : Nx/fs-1/fs;

% signal
x = A * cos(2 * pi * k / N * [0:Nx-1]');

% frequency
fk = k * fs / N

% plot
%{
figure(11, 'position', fig_size_long)
plot(t', x, 'LineWidth', 1.5)
set(gca,'FontSize',12)
xlabel('Time [s]', 'fontsize', 16)
ylabel('Magnitude', 'fontsize', 16)
grid on
print(['t_simple'],'-dpng', '-S900,400')
%}

% --
% buffer signal in blocks

% Overlap
OL = N / 2;

% Hop size
R = N - OL;

% window
w = hann(N);

% buffering
x_buff = w .* buffer(x, N, OL, 'nodelay');

% --
% signal transformation

% orthogonal signal transform
compFreq = @(k, N) exp(i * 2 * pi * k ./ N * [0:N-1]);

% transformation matrix
H = compFreq([0:N-1]', N);

% transformation into image space
X_buff = H * x_buff;

% logarithmic frequency response
Y = 20 * log10(2 / N * abs(X_buff(1:end/2+1, 2)));

% plot
%{
figure(12, 'position', fig_size_long)
plot(f, Y, 'LineWidth', 1.5)
set(gca,'FontSize',12)
xlabel('Frequency f [Hz]', 'fontsize', 16)
ylabel('Logarithmic Magnitude [dB]', 'fontsize', 16)
grid on
print(['fft_simple'],'-dpng', '-S900,400')
%}


% --
% parabolic interpolation

[v, p] = max(Y);

% parabol params
[alpha_log, beta_log, gamma_log, k_log] = parabol_interp(Y, p);

disp(['---'])
disp(['---simple cosine', ])
disp(['Parabolic Estimation:'])

% parabol estimation vs peak
f_peak_log = p * fs/N
f_est_log = 44100/1024 * k_log

A_peak_log = 10^(Y(p) / 20)
A_est_log = 10^(beta_log / 20)

% --
% phase derivation
disp(['phase derivation:'])
f_t = k * fs / N
f_k = p * fs / N
f_i = inst_f(X_buff, p, 1, R, N, fs)


% --
% read files
filepath = "./angabe/";
filenames = ['trumpet'; 'drumloop'];
file_ext = '.wav';


% --
% analyze audio files

% configure spectrogram
segment_len = 256;

% run through all audiofiles
for file_idx = 1 : size(filenames, 1)

  disp(['---'])
  disp(['---', filenames(file_idx, :)])

  % read file
  [x, fs] = wavread(strcat(filepath, filenames(file_idx, :), file_ext));
  fs
  xlen = length(x)

  % frequency vector
  f = 0 : fs/N : fs/2;

  % get number of slices
  x_slices = length(x) / OL

  % buffering
  x_buff = w .* buffer(x, N, OL, 'nodelay');

  % transform signal
  X_buff = H * x_buff;

  % pick the middle slice (at least for trumped)
  s = round(x_slices / 2)

  % log
  Y = 20 * log10(2 / N * abs(X_buff(1:end/2+1, s)));

  % plot
  %%{
  figure(20 + file_idx, 'position', fig_size_long)
  plot(f, Y, 'LineWidth', 1.5)
  set(gca,'FontSize',12)
  title([filenames(file_idx, :)], 'fontsize', 18)
  xlabel('Frequency f [Hz]', 'fontsize', 16)
  ylabel('Logarithmic Magnitude [dB]', 'fontsize', 16)
  grid on
  xlim([200, 500])
  %print(['fft_frame_', int2str(s), '_', filenames(file_idx, :)],'-dpng', '-S900,400')
  print(['fft_zoom_frame_', int2str(s), '_', filenames(file_idx, :)],'-dpng', '-S900,400')
  %}

  % plots spectogram
  %{
  figure(30 + file_idx, 'position', fig_size_long)
  specgram(x, segment_len, fs);
  %set(gca,'FontSize',12)
  title([filenames(file_idx, :)], 'fontsize', 18)
  %print(['spec_', filenames(file_idx, :)],'-dpng', '-S900,400')
  %}

  % --
  % parabolic interpolation

  % search for first peak in trumpet only till 400Hz
  [v, p] = max(Y(1:(N/fs)*400));

  % parabol params
  [alpha_log, beta_log, gamma_log, k_log] = parabol_interp(Y, p);


  disp(['Parabolic Estimation:'])

  % parabol estimation vs peak
  f_peak_log = p * fs / N
  f_est_log = k_log * fs / N

  beta_log
  A_peak_log = 10^(Y(p) / 20)
  A_est_log = 10^(beta_log / 20)

  % --
  % phase derivation
  disp(['phase derivation:'])
  f_k = p * fs / N
  f_i = inst_f(X_buff, p, 1, R, N, fs)

end



