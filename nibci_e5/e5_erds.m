% desynchronize: neurons stop firing, power of freq will decrease
% look at power levels
% calculate band power

%close all;
%clear all;
%clc;

% add library path
addpath('./ERDS-Maps');

% load data
load('sGes.mat')
load('hGes.mat')

size(sGes);
size(hGes);

% calculate ERDs maps
t = [-3, 0, 5];
f_borders = [4, 30];
t_ref = [-2.5, -0.5];


ch = 1;

% erds_maps
%erds_maps_c1 = calcErdsMap(sGes, hGes, t, f_borders, 'ref', t_ref, 'sig', 'boot', 'alpha', 0.01, 'class', 1);
%erds_maps_c2 = calcErdsMap(sGes, hGes, t, f_borders, 'ref', t_ref, 'sig', 'boot', 'alpha', 0.01, 'class', 2);
%save('erds_maps.mat', 'erds_maps_c1', 'erds_maps_c2');

load('erds_maps.mat')

plotErdsMap(erds_maps_c1)
plotErdsMap(erds_maps_c2)


% --
% Exercise 5.2: BCI Simulation

% band pass filtering
f_window_cue = [8, 13];
filter_order = 4;
h_bp = butter(filter_order, f_window_cue / hGes.SampleRate);
%y = filter(x, h_bp)

% choose interesting time segments
t_cue = [1, 3];

% training
x_train = 0;
y_train = 0;

% testing


