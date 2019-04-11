% clear all
clear all;
close all;
clc

% load data
load BI5_segments_HTS.mat

% separate target and non-tragets
non_targets = segments(:, :, classlabels == 1);
targets = segments(:, :, classlabels == 2);

% wilcoxon params
alpha = 0.01 / size(targets, 3);
wilcoxon = zeros(size(targets, 1), size(targets, 2));

% wilcoxon for each channel
for ch = 1:length(ch_selection)
    % calculate wilcoxon test over all trials for each sample
    for sample = 1:size(targets, 2)
      wilcoxon(sample) = ranksum(squeeze(targets(ch, sample, :)), squeeze(non_targets(ch, sample, :)));
      % for octave
      %wilcoxon(ch, sample) = wilcoxon_test(squeeze(targets(ch, sample, :)), squeeze(non_targets(ch, sample, 1:400)));
    end
end

% LDA on P300 data
% Cz electrode
ch = 2;

% find the two points with the most significance
sorted_wilcoxon = sort(wilcoxon(ch, :), 'ascend');
signi_idx = find(wilcoxon(ch, :) == sorted_wilcoxon(1) | wilcoxon(ch, :) == sorted_wilcoxon(2));

% cross-validation
n_fold = 10;

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

% lda classifier
[w, b, mu_est] = custom_LDA(train_set, train_labels, test_set);

% output 
output_class = sign(w' * test_set' - b)';

% compute scores
score_text = ['-- P300 LDA classification ']
correct_pred = sum(output_class == test_labels)
false_pred = length(output_class) - correct_pred
accuracy = correct_pred / length(output_class)

% plot the stuff
x = -20 : 1 : 25;
k = -w(1)/w(2);
d = mu_est(2) - k * mu_est(1);

% %{
% plot the stuff
figure(40)
scatter(test_targets(:, 1), test_targets(:, 2), 'b', 'x')
hold on
scatter(test_non_targets(:, 1), test_non_targets(:, 2), 'r', 'x')

% plot separating lines
plot(x, k * x + d, 'k')

title('Distribution of P300 most significant points')
xlabel('point 1')
ylabel('point 2')
legend('targets', 'non-targets', 'decision boundary')
grid on
%print('P300_lda','-dpng')
%}