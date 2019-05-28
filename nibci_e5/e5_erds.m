% desynchronize: neurons stop firing, power of freq will decrease
% look at power levels
% calculate band power

%close all;
%clear all;
%clc;

% octave packages
pkg load signal;

% add library path
addpath('./ERDS-Maps');

% load data and save as variables
load('sGes.mat')
load('hGes.mat')
fs = hGes.SampleRate;
sGes_train = sGes;
hGes_train = hGes;
load('sGes_test.mat')
load('hGes_test.mat')
sGes_test = sGes;
hGes_test = hGes;
clear sGes;
clear hGes;

% erds map params
t = [-3, 0, 5];
f_borders = [4, 30];
t_ref = [-2.5, -0.5];

% calculate erds maps
%{
erds_maps_c1 = calcErdsMap(sGes_train, hGes_train, t, f_borders, 'ref', t_ref, 'sig', 'boot', 'alpha', 0.01, 'class', 1);
erds_maps_c2 = calcErdsMap(sGes_train, hGes_train, t, f_borders, 'ref', t_ref, 'sig', 'boot', 'alpha', 0.01, 'class', 2);
save('erds_maps.mat', 'erds_maps_c1', 'erds_maps_c2');
%}

% load pre calculated erds_maps
load('erds_maps.mat')

% plot erds maps
plotErdsMap(erds_maps_c1);
plotErdsMap(erds_maps_c2);


% --
% Exercise 5.2: BCI Simulation

% selected EEG channel
ch = 1;

% band pass filter params
filter_order = 4;
f_window_cue = [8, 13];
[b, a] = butter(filter_order, f_window_cue / (fs / 2));
%freqz(b, a);

% apply filter
s_band_train = filter(b, a, sGes_train(:, ch));
s_band_test = filter(b, a, sGes_test(:, ch));

% plot filtered erds map
%{
erds_maps_c1_filt = calcErdsMap(s_band_train, hGes_train, t, f_borders, 'ref', t_ref, 'sig', 'boot', 'alpha', 0.01, 'class', 1);
plotErdsMap(erds_maps_c1_filt);
%}

% choose interesting time segments
samples_cue = [1, 3] * fs;

% create cue vector for train
cues_train = [];
for trig = 1 : length(hGes_train.TRIG)
  vec = hGes_train.TRIG(trig) + samples_cue(1) : hGes_train.TRIG(trig) + samples_cue(2);
  cues_train = [cues_train; vec];
end

% create cue vector for test
cues_test = [];
for trig = 1 : length(hGes_test.TRIG)
  vec = hGes_test.TRIG(trig) + samples_cue(1) : hGes_test.TRIG(trig) + samples_cue(2);
  cues_test = [cues_test; vec];
end

% determine band power of the signal
x_train = log10(sum(s_band_train(cues_train) .^ 2, 2));
x_test = log10(sum(s_band_test(cues_test) .^ 2, 2));

% class labels
y_train = (hGes_train.Classlabel)';
y_test = (hGes_test.Classlabel)';

% training
[w, b] = custom_LDA(x_train, y_train);

% compute scores on train and test set
score_train = custom_score(sign(w' * x_train' - b), y_train)
score_test = custom_score(sign(w' * x_test' - b), y_test)



% --
% same but with two features

% band pass filter params
filter_order = 4;
f_window_cue1 = [8, 13];
f_window_cue2 = [20, 25];
[b1, a1] = butter(filter_order, f_window_cue1 / (fs / 2));
[b2, a2] = butter(filter_order, f_window_cue2 / (fs / 2));

% apply filter
s_band_train1 = filter(b1, a1, sGes_train(:, ch));
s_band_train2 = filter(b2, a2, sGes_train(:, ch));
s_band_test1 = filter(b1, a1, sGes_test(:, ch));
s_band_test2 = filter(b2, a2, sGes_test(:, ch));

% determine band power of the signal
x_train = [log10(sum(s_band_train1(cues_train) .^ 2, 2)), log10(sum(s_band_train2(cues_train) .^ 2, 2))];
x_test = [log10(sum(s_band_test1(cues_test) .^ 2, 2)), log10(sum(s_band_test2(cues_test) .^ 2, 2))];

% class labels
y_train = (hGes_train.Classlabel)';
y_test = (hGes_test.Classlabel)';

% training
[w, b] = custom_LDA(x_train, y_train);

% compute scores on train and test set
score_train2 = custom_score(sign(w' * x_train' - b), y_train)
score_test2 = custom_score(sign(w' * x_test' - b), y_test)