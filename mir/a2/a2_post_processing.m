clear variables
close all

% plot config
fig_size_long = [0, 0, 900, 400];

% --
% params
N = 1024;
fs = 44100;

% frequency vector
f = 0 : fs/N : fs/2;

% simple syntethic test signal
k = 40.22;
A = 3;
x = A * cos(2 * pi * k / N * [0:N-1]');
fk = k * fs / N

% --
% signal transformation

% orthogonal signal transform
compFreq = @(k, N) exp(i * 2 * pi * k ./ N * [0:N-1]);

% transformation matrix
H = compFreq([0:N-1]', N);

% transformation into image space
X = H * x;

% logarithmic frequency response
Y = 20 * log10(2 / N * abs(X(1:end/2+1)));

% plot
%{
figure(1, 'position', fig_size_long)
plot(f, Y, 'LineWidth', 1.5)
set(gca,'FontSize',12)
xlabel('Frequency f [Hz]', 'fontsize', 16)
ylabel('Logarithmic Magnitude [dB]', 'fontsize', 16)
grid on
%print(['signal_fft'],'-dpng', '-S900,400')
%}


% --
% parabolic interpolation

[v, p] = max(Y);

% parabol params
[alpha_log, beta_log, gamma_log, k_log] = parabol_interp(Y, p);

% parabol estimation vs peak
f_peak_log = p * fs/N
f_est_log = 44100/1024 * k_log

A_peak_log = 10^(Y(p) / 20)
A_est_log = 10^(beta_log / 20)


% --
% read in files

filepath = "./angabe/";
filenames = ["drumloop.wav"; "trumpet.wav"];

% --
% analyze audio files

% configure spectrogram
segment_len = 256

for file_idx = 1 : length(filenames)

  % read file
  [x, fs] = wavread([filepath, filenames(file_idx, :)]);

  % transform signal
  N = length(x)
  %H = compFreq([0:N-1]', N);
  X = fft(x); 
  Y = 20 * log10(2 / N * abs(X(1:end/2+1)));

  % frequency vector
  f = 0 : fs/N : fs/2;

  %char(filenames(file_idx)
  % plot
  %%{
  figure(20 + file_idx, 'position', fig_size_long)
  plot(f, Y, 'LineWidth', 1.5)
  set(gca,'FontSize',12)
  title(['file: ' filenames(file_idx, :)], 'fontsize', 18)
  xlabel('Frequency f [Hz]', 'fontsize', 16)
  ylabel('Logarithmic Magnitude [dB]', 'fontsize', 16)
  grid on
  %print(['signal_fft'],'-dpng', '-S900,400')
  %}

  % plots
  figure 31
  specgram(x, segment_len, fs);

end



