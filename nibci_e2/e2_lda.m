%% clear all
clear all;
close all;
clc

% load data
load BI5_segments_HTS.mat

pkg load statistics

%% std
% separate in target and non-target tones
n_non_targets = sum(classlabels == 1);
n_targets = sum(classlabels == 2);

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
 %{
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
  ylabel('Volt [uV]')
  legend('target mean', 'target + std', 'target - std', 'non-target mean', 'non-target + std', 'non-target - std')
  %print(['P300_std_' char(ch_selection(i))],'-dpng')
end
%}

% wilcoxon params
alpha = 0.01 / size(targets, 3);
wilcoxon = zeros(size(targets, 1), size(targets, 2));

% wilcoxon for each channel
for ch = 1:length(ch_selection)
    
    % calculate wilcoxon test over all trials for each sample
    for sample = 1:size(mean_targets, 2)
      %wilcoxon(sample) = ranksum(squeeze(targets(ch, sample, :)), squeeze(non_targets(ch, sample, :)), 'alpha', alpha);
      % for octave
      wilcoxon(ch, sample) = wilcoxon_test(squeeze(targets(ch, sample, :)), squeeze(non_targets(ch, sample, 1:400)));
    end

    % significance of mean targets
    signi = zeros(size(targets, 2), 1);
    idx = find((wilcoxon(ch, :) <= alpha));
    signi(idx) = mean_targets(ch, idx);
    
     %{
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
    ylabel('Volt [uV]')
    legend('target mean', 'non-target mean', 'significance' )
    %print(['P300_signi_' char(ch_selection(ch))],'-dpng')
    %}
end



%% LDA testing
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
train_set = [train_c1; train_c2];
train_labels = [ones(n_train_c1, 1); -ones(n_train_c2, 1)];

test_c1 = mu_c1 + std_c1 .* randn(n_test_c1, 2); 
test_c2 = mu_c2 + std_c2 .* randn(n_test_c2, 2);
test_set = [test_c1; test_c2]; 
test_labels = [ones(n_test_c1, 1); -ones(n_test_c2, 1)];

%% lda classifier
[output_class, w, b, mu_est] = custom_LDA(train_set, train_labels, test_set);

W = LDA(train_set, train_labels)

% compute scores
correct_pred = sum(output_class == test_labels)
false_pred = length(output_class) - correct_pred
accuracy = correct_pred / length(output_class)

% plot the stuff
x = -2 : 1 : 5;
k = -w(1)/w(2);
d = mu_est(2) - k * mu_est(1);

 %{
figure(20)
scatter(test_c1(:, 1), test_c1(:, 2), 'b', 'x')
hold on
scatter(test_c2(:, 1), test_c2(:, 2), 'r', 'x')

% plot separating lines
plot(x, k * x + d, 'bk')

title('Distribution of data')
xlabel('x')
ylabel('y')
legend('class 1', 'class 2', 'decision boundary')
grid on
%print('c1c2_normal_samples','-dpng')
%}



%% LDA on P300 data
% Cz electrode
ch = 2;

% find the two points with the most significance
sorted_wilcoxon = sort(wilcoxon(ch, :), 'ascend');
signi_idx = find(wilcoxon(ch, :) == sorted_wilcoxon(1) | wilcoxon(ch, :) == sorted_wilcoxon(2));

 %{
% plot the two most significant points in the P300
figure(30)
hold on
plot(mean_targets(ch, :), '-b')
plot(mean_non_targets(ch,:), '-r')
scatter(signi_idx, mean_targets(ch, signi_idx), 'g')
hold off
ylim([-6 8])
title(ch_selection(ch))
xlabel('Samples')
ylabel('Volt [uV]')
legend('target mean', 'non-target mean', 'max significance points' )
%print(['P300_signi2_' char(ch_selection(ch))],'-dpng')
%}

% create train set
train_targets = squeeze(targets(ch, signi_idx, 1:200))';
train_non_targets = squeeze(non_targets(ch, signi_idx, 1:1000))';
train_set = [train_targets; train_non_targets];
train_labels = [ones(length(train_targets), 1); -ones(length(train_non_targets), 1)];

% create test set
test_targets = squeeze(targets(ch, signi_idx, 201:400))';
test_non_targets = squeeze(non_targets(ch, signi_idx, 1001:1800))';
test_set = [test_targets; test_non_targets];
test_labels = [ones(length(test_targets), 1); -ones(length(test_non_targets), 1)];

% check if data is normal distributed
dim_name = {"1.dim" "2.dim"};

 %{
for dim = 1:2
  figure(31 + dim)
  normplot(test_targets(:, dim))
  xlim([-30 40])
  legend(['targets, ' char(dim_name(dim))],'Location','southeast')
  %print(['normplot_targets_dim' int2str(dim)],'-dpng')
end

for dim = 1:2
  figure(33 + dim)
  normplot(test_non_targets(:, dim))
  xlim([-30 40])
  legend(['non-targets, ' char(dim_name(dim))],'Location','southeast')
  %print(['normplot_non-targets_dim' int2str(dim)],'-dpng')
end
%}

%% lda classifier
[output_class, w, b, mu_est] = custom_LDA(train_set, train_labels, test_set);

% compute scores
score_text = ['-- P300 LDA classification --']
correct_pred = sum(output_class == test_labels)
false_pred = length(output_class) - correct_pred
accuracy = correct_pred / length(output_class)

% plot the stuff
x = -20 : 1 : 25;
k = -w(1)/w(2);
d = mu_est(2) - k * mu_est(1);

 %{
% plot the stuff
figure(40)
scatter(test_targets(:, 1), test_targets(:, 2), 'b', 'x')
hold on
scatter(test_non_targets(:, 1), test_non_targets(:, 2), 'r', 'x')

% plot separating lines
plot(x, k * x + d, 'bk')

title('Distribution of P300 most significant points')
xlabel('point 1')
ylabel('point 2')
legend('targets', 'non-targets', 'decision boundary')
grid on
%print('P300_lda','-dpng')
%}