
close all;
clear all;
clc;

% load data
load('Sig.mat')
load('ClassPosH.mat')
load('ClassPosF.mat')
load('SampleRate.mat')

% --
% CSP

% common data
n_channels = size(Sig, 1);

% classes
class_hand = 1;
class_feet = 2;

% band pass filtering
filter_order = 4;
f_window_cue = [7, 30];
[b, a] = butter(filter_order, f_window_cue / (SR / 2));

% container for filtered signal
s_band = zeros(size(Sig));

% apply filter for each channel
for ch = 1 : n_channels;
  s_band(ch, :) = filtfilt(b, a, Sig(ch, :));
end

% choose interesting time segments in samples
samples_cue = [1.5, 2.5] * SR;

% data matrix
X = zeros(100, n_channels, 128);

% epoch channels
for ch = 1 : n_channels
  % create cues for class hand
  for trig = 1 : length(ClassPosH)
    X(trig, ch, :) = s_band(ch, ClassPosH(trig)) + samples_cue(1) : s_band(ch, ClassPosH(trig)) + samples_cue(2) - 1;
  end

  % create cues for class feet
  for trig = 1 : length(ClassPosF)
    X(trig + 50, ch, :) = s_band(ch, ClassPosF(trig)) + samples_cue(1) : s_band(ch, ClassPosF(trig)) + samples_cue(2) - 1;
  end
end

% calculate separate spatial normalized covariance
sigm = zeros(100, 15, 15);
for trial = 1 : 100
  XX_t = squeeze(X(trial, :, :)) * transpose(squeeze(X(trial, :, :)));
  sigm(trial, :, :) = XX_t / trace(XX_t);
end

% average covariance matrices
sigm1 = squeeze(mean(sigm(1:50, :, :), 1));
sigm2 = squeeze(mean(sigm(51:100, :, :), 1));

% calculate eigenvalues
[V, D] = eig(sigm1, sigm1 + sigm2, 'qz');

% sort eigenvalues according to magnitude in D
[D_s, D_si] = sort(D * ones(15, 1));
V_s = V(:, D_si);


% --
% extract CSP and train LDA

% use most important filters
C = [V_s(:, 1), V_s(:, 2), V_s(:, 14), V_s(:, 15)];

% CSP filtering
s_csp = C' * s_band;

% data matrix CSP
X_csp = zeros(100, 4, 128);

% epoch channels with csp filtering
for ch = 1 : 4
  % create cues for class hand
  for trig = 1 : length(ClassPosH)
    X_csp(trig, ch, :) = s_csp(ch, ClassPosH(trig)) + samples_cue(1) : s_csp(ch, ClassPosH(trig)) + samples_cue(2) - 1;
  end

  % create cues for class feet
  for trig = 1 : length(ClassPosF)
    X_csp(trig + 50, ch, :) = s_csp(ch, ClassPosF(trig)) + samples_cue(1) : s_csp(ch, ClassPosF(trig)) + samples_cue(2) - 1;
  end
end

% calculate band power
x_train = log10(sum(X_csp .^ 2, 3));

% get labels
y_train = [ones(1, length(ClassPosH)) * class_hand, ones(1, length(ClassPosF)) * class_feet];

% training
[w, b] = custom_LDA(x_train, y_train);

% compute scores on train and test set
score_train = custom_score(sign(w' * x_train' - b), y_train)


% --
% 

% Laplacian to compare
% accuracy 85%




