% --
% tips
% box plots -> boxplot() for cross-val scores
% use save function to store data .mat

close all;
clear all;
clc;

% plot config
fig_size_long = [0, 0, 900, 300];

% time and seampling stuff
t_len = 100;
fs = 256;
dt = 1/fs;

t = 0 : dt : t_len;

N = length(t);
f_x = -fs / 2 : fs / N : fs / 2 - fs / N;


% --
% 4.1 generate an artificial SSVEP

% class 1 signal
f = [8 16];
A = [1 0.5];
s1 = A(1) * sin(2*pi*f(1)*t) + A(2) * sin(2*pi*f(2)*t);

% class 2 signal
f = [13 26];
A = [1 0.5];
s2 = A(1) * sin(2*pi*f(1)*t) + A(2) * sin(2*pi*f(2)*t);

% noise
std_noise = 3 : 9;
v = std_noise' * randn(1, length(t));

% signals + noise -> measurements d
d1 = s1 + v;
d2 = s2 + v;

%{
d = [d1; d2];
d_index = [1 2];
for idx = 1:length(d_index)
    figure(0 + idx) 
    plot(t, d(idx, :))
    xlabel('Time [s]')
    ylabel('Amplitude')
end
%}

% SNR

%snr = 10 * log10(var(s1) / var(p_v) )

p_s1 = sqrt(mean(s1 .* s1));
p_s2 = sqrt(mean(s2 .* s2));
p_v = sqrt(mean(v .* v, 2));

snr_d1 = 10 * log10(p_s1 ./ p_v);
snr_d2 = 10 * log10(p_s2 ./ p_v);

%%{
%figure
figure(10, 'position', fig_size_long)
plot(std_noise, snr_d1, 'LineWidth', 2)
ylabel('SNR', 'fontsize', 16)
xlabel('Standard deviation of noise', 'fontsize', 16)
grid on
%print('snr','-dpng')
%}


% --
% 4.2 extract feature from artificial SSVEP

% %{
segment_time_len = 1;

segment_len = segment_time_len / dt;
n_segment = t_len / segment_time_len;
pool_score = zeros(1, length(std_noise));

for sigm = 1 : length(std_noise)

  % segmentation
  d1_seg = zeros(n_segment, segment_len);
  for seg = 1 : n_segment
    for seg_idx = 1 : segment_len
      d1_seg(seg, seg_idx) = d1(sigm, (seg - 1) * n_segment + (seg_idx));
      d2_seg(seg, seg_idx) = d2(sigm, (seg - 1) * n_segment + (seg_idx));
    end
  end

  % DFT
  D1_SEG = fftshift(abs(custom_dft(d1_seg)));
  D2_SEG = fftshift(abs(custom_dft(d2_seg)));

  % extract frequencies
  f_ex = [8, 13, 16, 26];

  % features
  c1_feat = D1_SEG(:, fs / 2 + f_ex + 1);
  c2_feat = D2_SEG(:, fs / 2 + f_ex + 1);

  % labels
  c1_label = 1;
  c2_label = 2;

  % training set
  x_train = [c1_feat(1 : n_segment / 2, :); c2_feat(1 : n_segment / 2, :)]; 
  y_train = [c1_label * ones(length(c1_feat) / 2, 1); c2_label * ones(length(c2_feat) / 2, 1)];

  % test set
  x_test = [c1_feat(n_segment / 2 + 1 : end, :); c2_feat(n_segment / 2 + 1 : end, :)]; 
  y_test = [c1_label * ones(length(c1_feat) / 2, 1); c2_label * ones(length(c2_feat) / 2, 1)];

  %W = LDA(x_train, y_train);

  [w, b] = custom_LDA(x_train, y_train);

  % output 
  output_lda = sign(w' * x_test' - b);

  % compute score
  score = custom_score(output_lda, y_test);
  pool_score(sigm) = score;
end
% save scores
save('scores.mat', 'pool_score');
%}

% load scores for time saving
%load('scores.mat')

% plots of scores
%%{
pool_score
figure(20, 'position', fig_size_long)
plot(std_noise, pool_score, 'LineWidth', 2)
ylim([0, 1])
ylabel('Accuracy', 'fontsize', 16)
xlabel('Standard deviation of noise', 'fontsize', 16)
grid on
%print('acc_std_noise','-dpng')
%}


% plots of fft
% %{
f_x = -fs / 2 : fs / segment_len : fs / 2 - fs / segment_len;

figure(31)
hold on
plot(f_x, D1_SEG(1, :), 'LineWidth', 2)
scatter(f_ex, c1_feat(1, :), 12, 'r' )
set(gca,'FontSize',12)
xlim([0, 40])
grid on
ylabel('Amplitude', 'fontsize', 16)
xlabel('Frequency [Hz]', 'fontsize', 16)
lgd = legend('DFT', 'feature points');
set(lgd, 'FontSize', 12);
%print(['c1_std-' num2str(std_noise)],'-dpng')

figure(32)
hold on
plot(f_x, D2_SEG(1, :), 'LineWidth', 2)
scatter(f_ex, c2_feat(1, :), 12, 'r')
set(gca,'FontSize',12)
xlim([0, 40])
grid on
ylabel('Amplitude', 'fontsize', 16)
xlabel('Frequency [Hz]', 'fontsize', 16)
legend('DFT', 'feature points')
lgd = legend('DFT', 'feature points');
set(lgd, 'FontSize', 12);
%print(['c2_std-' num2str(std_noise)],'-dpng')
%}


% --
% 4.3 Classification of patient

% load data
load('X.mat')
load('Y.mat')

% do 10x10 cross-validation
[L, K] = cross_val_10x10(X, Y);

% extract some statistical properties
mean_score_folds = mean(K);
var_score_folds = var(K);

% print scores
av_score_all = L
var_score = var(var_score_folds);

pkg load statistics

%%{
figure(40)
boxplot(K);
%}











