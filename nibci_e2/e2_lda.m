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

% wilcoxon
alpha = 0.01;
wilcoxon = [0 0 0];
for i = 1:length(ch_selection)
  wilcoxon(i) = ranksum(mean_targets(i,:), mean_non_targets(i,:), 'alpha', alpha);
end
% print wilcoxon
ch_selection
wilcoxon


% print everything
for i = 1:length(ch_selection)
  figure(1+i)
  hold on 
  plot(t, mean_targets(i,:), '-b')
  plot(t, mean_non_targets(i,:), '--r')
  plot(t, std_targets(i,:), '-g')
  plot(t, std_non_targets(i,:), '--y')
  title(ch_selection(i))
  xlabel('time [s]')
  ylabel('Volt [µV]')
  legend('target mean', 'non-target mean', 'target std',  'non-target std')
  %print(['P300_' char(ch_selection(i))],'-dpng')
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
w = zeros(2, 1)
b = 0
covM = [[std_c1] [0 0]; [0 0] [std_c2]]
w =  (mu_c1 - mu_c2)
%b = w * [mu_c1 mu_c2]


