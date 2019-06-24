
close all;
clear all;
clc;

% load packages for octave
pkg load signal

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
[b_, a_] = butter(filter_order, f_window_cue / (SR / 2));

% container for filtered signal
s_band = zeros(size(Sig));

% apply filter for each channel
s_band = filtfilt(b_, a_, Sig')';

% choose interesting time segments in samples
samples_cue = [1.5, 2.5] * SR;

% data matrix
X = zeros(100, n_channels, 128);

% epoch channels
for ch = 1 : n_channels
  % create cues for class hand
  for trig = 1 : length(ClassPosH)
    X(trig, ch, :) = s_band(ch, ClassPosH(trig) + samples_cue(1) : ClassPosH(trig) + samples_cue(2) - 1);
  end

  % create cues for class feet
  for trig = 1 : length(ClassPosF)
    X(trig + 50, ch, :) = s_band(ch, ClassPosF(trig) + samples_cue(1) : ClassPosF(trig) + samples_cue(2) - 1);
  end
end

% get CSP filter matrix
[V_s, D_s] = custom_CSP(X);


% --
% extract CSP and train LDA

% use most important filters
C = [V_s(:, 1 : 2), V_s(:, 14 : 15)];

% CSP filtering
s_csp = C' * s_band;

% data matrix CSP
X_csp = zeros(100, 4, 128);

% epoch channels with csp filtering
for ch = 1 : 4
  % create cues for class hand
  for trig = 1 : length(ClassPosH)
    X_csp(trig, ch, :) = s_csp(ch, ClassPosH(trig) + samples_cue(1) : ClassPosH(trig) + samples_cue(2) - 1);
  end

  % create cues for class feet
  for trig = 1 : length(ClassPosF)
    X_csp(trig + length(ClassPosH), ch, :) = s_csp(ch, ClassPosF(trig) + samples_cue(1) : ClassPosF(trig) + samples_cue(2) - 1);
  end
end

% calculate band power
x_train = log10(sum(X_csp .^ 2, 3));

% get labels
y_train = [ones(1, length(ClassPosH)) * class_hand, ones(1, length(ClassPosF)) * class_feet];

% training
[w, b] = custom_LDA(x_train, y_train);

% compute scores on train and test set
disp('Train score:')
score_train = custom_score(sign(w' * x_train' - b), y_train)


% --
% Validation

% load data
load('SigVal.mat')
load('ClassPosHVal.mat')
load('ClassPosFVal.mat')

% container for filtered signal
s_band_val = zeros(size(SigVal));

% apply filter for each channel
s_band_val = filtfilt(b_, a_, SigVal')';

% score pool
score_pool = zeros(1, 5);

% compute csp scores
for n_csp = 2 : 7;
  % use most important filters
  C = [V_s(:, 1 : n_csp), V_s(:, 15 - n_csp : 15)];

  % CSP filtering
  s_csp_val = C' * s_band_val;

  % data matrix CSP
  X_csp = zeros(60, 4, 128);

  % epoch channels with csp filtering
  for ch = 1 : 4
    % create cues for class hand
    for trig = 1 : length(ClassPosHVal)
      X_csp(trig, ch, :) = s_csp_val(ch, ClassPosHVal(trig) + samples_cue(1) : ClassPosHVal(trig) + samples_cue(2) - 1);
    end

    % create cues for class feet
    for trig = 1 : length(ClassPosFVal)
      X_csp(trig + length(ClassPosHVal), ch, :) = s_csp_val(ch, ClassPosFVal(trig) + samples_cue(1) : ClassPosFVal(trig) + samples_cue(2) - 1);
    end
  end

  % calculate band power
  x_val = log10(sum(X_csp .^ 2, 3));

  % get labels
  y_val = [ones(1, length(ClassPosHVal)) * class_hand, ones(1, length(ClassPosFVal)) * class_feet];

  % compute score
  disp(['Val score: ', num2str(n_csp)])
  score_val = custom_score(sign(w' * x_val' - b), y_val)
end



% Laplacian to compare
% accuracy 85%




