
%close all;
%clear all;
%clc;

% load data
load('Sig.mat')
load('ClassPosH.mat')
load('ClassPosF.mat')
load('SampleRate.mat')

% common data
n_channels = size(Sig, 1);

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

% classes
class_hand = 1;
class_feet = 2;

% data matrix
X = zeros(100, 128, n_channels);

% for all channels
for ch = 1 : n_channels

  % data matrix channel
  X_ch = [];

  % create cues for class hand
  for trig = 1 : length(ClassPosH)
    vec = s_band(ch, ClassPosH(trig)) + samples_cue(1) : s_band(ch, ClassPosH(trig)) + samples_cue(2) - 1;
    X_ch = [X_ch; vec];
  end

  % create cues for class feet
  for trig = 1 : length(ClassPosF)
    vec = s_band(ch, ClassPosF(trig)) + samples_cue(1) : s_band(ch, ClassPosF(trig)) + samples_cue(2) - 1;
    X_ch = [X_ch; vec];
  end
  
  % add channel to data matrix
  X(:, :, ch) = X_ch;
end

size(X)
class_vec = [ones(1, length(ClassPosH)) * class_hand, ones(1, length(ClassPosF)) * class_feet];

% CSP

% Laplacian to compare





