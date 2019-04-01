%% Filters

% clear all
clear all;
close all;
clc

% load data
load artefacts.mat;
%%

% data
fs = 500;
n_channels = 120;

% number of samples
n_samples = 23501;
n_plot_samples = n_samples/1;

% x-axis in samples
samples = 1 : n_samples;
samples_plot = 1 : n_plot_samples;

% x-axis in time domain
t = 0 : 1/fs : (n_samples-1)/fs;
t_plot = 0 : 1/fs : (n_plot_samples-1)/fs;

n_plot_samples = int16(n_plot_samples);


% Electrode indices
% Fz 
AFz_index = 7;  % anterior
Fz_index = 12;  % main
FC2_index = 18; % posterior
F2_index = 13;% dexter
F1_index = 11;% sinister

% Cz 
%FC2_index = 18; % anterior
Cz_index = 22;  % main
CPz_index = 27; % posterior
C2_index = 23;% dexter
C1_index = 21;% sinister

%Oz
POz_index = 37; % anterior
Oz_index = 42;  % main
Iz_index = 47; % posterior
O2_index = 43;% dexter
O1_index = 41;% sinister

% bipolar filter (anterior - posterior)
Fz_art_bip = art(Fz_index, :) - art(AFz_index, :);
Cz_art_bip = art(Cz_index, :) - art(FC2_index, :);
Oz_art_bip = art(Oz_index, :) - art(POz_index, :);

% laplace filter 
Fz_art_lap = art(Fz_index, :) - 1/4 * ( art(AFz_index, :) + art(FC2_index, :) + art(F2_index, :) + art(F1_index, :) );
Cz_art_lap = art(Cz_index, :) - 1/4 * ( art(FC2_index, :) + art(CPz_index, :) + art(C2_index, :) + art(C1_index, :) );
Oz_art_lap = art(Oz_index, :) - 1/4 * ( art(POz_index, :) + art(Iz_index, :) + art(O2_index, :) + art(O1_index, :) );

% CAR filter
% laplace filter 
mean_artefacts = mean(art);
Fz_art_car = art(Fz_index, :) - mean_artefacts;
Cz_art_car = art(Cz_index, :) - mean_artefacts;
Oz_art_car = art(Oz_index, :) - mean_artefacts;

% plot to compare between artefacts and
figure(1)
plot(t_plot, art(Fz_index, 1:n_plot_samples), '-b')
hold on 
%plot(t_plot, art(AFz_index, 1:n_plot_samples), '-g')
plot(t_plot, Fz_art_bip(1:n_plot_samples), '-r')
title('Bipolar filter on Fz electrode')
xlabel('time [s]')
ylabel('Volt [mV]')
legend('non-filtered', 'filtered')
xlim([17 19])
ylim([-80 90])
print('filter_bipolar','-dpng')

% plot to compare between artefacts and
figure(2)
plot(t_plot, art(Fz_index, 1:n_plot_samples), '-b')
hold on 
%plot(t_plot, art(AFz_index, 1:n_plot_samples), '-g')
plot(t_plot, Fz_art_lap(1:n_plot_samples), '-r')
title('Laplacian filter on Fz electrode')
xlabel('time [s]')
ylabel('Volt [mV]')
legend('non-filtered', 'filtered')
xlim([17 19])
ylim([-80 90])
print('filter_laplacian','-dpng')

% plot to compare between artefacts and
figure(3)
plot(t_plot, art(Fz_index, 1:n_plot_samples), '-b')
hold on 
%plot(t_plot, art(AFz_index, 1:n_plot_samples), '-g')
plot(t_plot, Fz_art_car(1:n_plot_samples), '-r')
title('CAR filter on Fz electrode')
xlabel('time [s]')
ylabel('Volt [mV]')
legend('non-filtered', 'filtered')
xlim([17 19])
ylim([-80 90])
print('filter_car','-dpng')



%% P300
clear all
clc

% load data
load BI5_segments_HTS.mat

%%
% separate in target and non-target tones
n_non_targets = sum(classlabels==1);
n_targets = sum(classlabels==2);

%target and non-tragets
non_targets = segments(:, :, classlabels == 1);
targets = segments(:, :, classlabels == 2);

mean_non_targets = mean(non_targets, 3);
mean_targets = mean(targets, 3);

% print everything
for i = 1:length(ch_selection)
    figure(10+i)
    plot(t, mean_targets(i,:), '-b')
    hold on 
    plot(t, mean_non_targets(i,:), '--r')
    title(ch_selection(i))
    xlabel('time [s]')
    ylabel('Volt [uV]')
    legend('target', 'non-target')
    ylim([-6 8])
    print(['P300_' char(ch_selection(i))],'-dpng')
end





