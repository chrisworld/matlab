%% clear all
clear all;
close all;
clc

% load data
load BI5_segments_HTS.mat

%% std
% separate in target and non-target tones
n_non_targets = sum(classlabels==1);
n_targets = sum(classlabels==2);

%target and non-tragets
non_targets = segments(:, :, classlabels == 1);
targets = segments(:, :, classlabels == 2);

% mean
mean_non_targets = mean(non_targets, 3);
mean_targets = mean(targets, 3);

% std
std_non_targets = std(non_targets, 0, 3);
std_targets = std(targets, 0, 3);

% print everything
%%{
for i = 1:length(ch_selection)
  figure(1+i)
  hold on 
  plot(mean_targets(i,:), '-b', 'LineWidth', 1.5)
  plot(mean_targets(i,:) + std_targets(i,:), '--b')
  plot(mean_targets(i,:) - std_targets(i,:), '--b')
  plot(mean_non_targets(i,:), '-r', 'LineWidth', 1.5)
  plot(mean_non_targets(i,:) + std_non_targets(i,:), '--r')
  plot(mean_non_targets(i,:) - std_non_targets(i,:), '--r')
  hold off
  ylim([-15 20])
  title(ch_selection(i))
  xlabel('Samples')
  ylabel('Volt [µV]')
  legend('target mean', 'target + std', 'target - std', 'non-target mean', 'non-target + std', 'non-target - std')
  print(['P300_std_' char(ch_selection(i))],'-dpng')
end
%}

% wilcoxon params
alpha = 0.01 / size(targets, 3);
wilcoxon = zeros(size(targets, 2), 1);

% wilcoxon for each channel
for ch = 1:length(ch_selection)
    
    % calculate wilcoxon test over all trials for each sample
    for sample = 1:size(mean_targets, 2)
      wilcoxon(sample) = ranksum(squeeze(targets(ch, sample, :)), squeeze(non_targets(ch, sample, :)), 'alpha', alpha);
    end

    % significance of mean targets
    signi = zeros(size(targets, 2), 1);
    idx = find((wilcoxon <= alpha));
    signi(idx) = mean_targets(ch, idx);
    
    % plot
    figure(10 + ch)
    hold on
    plot(mean_targets(ch, :), '-b')
    plot(mean_non_targets(ch,:), '-r')
    stem(signi, '-g', 'MarkerSize', 4)
    hold off
    ylim([-6 8])
    title(ch_selection(ch))
    xlabel('Samples')
    ylabel('Volt [µV]')
    legend('target mean', 'non-target mean', 'significance' )
    print(['P300_signi_' char(ch_selection(ch))],'-dpng')
end



%% LDA
% number of samples
n_train_c1 = 1100;
n_train_c2 = 800;

n_test_c1 = 500;
n_test_c2 = 400;

% normal distribution params
mu_c1 = [0.4 0.6];
std_c1 = [0.9 0.7];

mu_c2 = [2.5 3.0];
std_c2 = [0.9 0.7];


% create samples
train_c1 = mu_c1 + std_c1 .* randn(n_train_c1, 2); 
train_c2 = mu_c2 + std_c2 .* randn(n_train_c2, 2); 
test_c1 = mu_c1 + std_c1 .* randn(n_test_c1, 2); 
test_c2 = mu_c2 + std_c2 .* randn(n_test_c2, 2); 

% plot the stuff
figure(20)
scatter(test_c1(:, 1), test_c1(:, 2), 'b', 'x')
hold on
scatter(test_c2(:, 1), test_c2(:, 2), 'r', 'x')
title('Distribution of data')
xlabel('x')
ylabel('y')
legend('class 1', 'class2')
grid on

%% lda classifier
w = zeros(2, 1);
b = 0;
covM = [std_c1 [0 0]; [0 0] std_c2];
w =  (mu_c1 - mu_c2);

output_class = sign(w' * test_c1(1,:) - b)
%b = w * [mu_c1 mu_c2]


