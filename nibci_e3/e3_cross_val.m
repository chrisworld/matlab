% clear all
clear all;
close all;
clc


% -----
% LDA on artificial data set with k-fold cross-falidation
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
train_set_samples = [train_c1; train_c2];
train_labels_samples = [ones(n_train_c1, 1); -ones(n_train_c2, 1)];

test_c1 = mu_c1 + std_c1 .* randn(n_test_c1, 2); 
test_c2 = mu_c2 + std_c2 .* randn(n_test_c2, 2);
test_set_samples = [test_c1; test_c2]; 
test_labels_samples = [ones(n_test_c1, 1); -ones(n_test_c2, 1)];

% cross-validation params
n_repeat = 10;
k_fold = 10;
test_percent = 0.1;

score_pool = zeros(n_repeat, k_fold);
param_pool = zeros(n_repeat * k_fold, 3);

% cross-validation with repetition
score_text = ['--- Artificial Samples classification cross-val averaged:']
for n = 1 : n_repeat
  % cross-validation indices
  cross_val_indices = cvind('Kfold', length(train_set_samples), k_fold);

  for k = 1 : k_fold
    % test set for k-fold
    val_set = train_set_samples(cross_val_indices == k, :);
    val_labels = train_labels_samples(cross_val_indices == k)';

    % train set for k-fold
    train_set = train_set_samples(cross_val_indices != k, :);
    train_labels = train_labels_samples(cross_val_indices != k);

    % classify
    [w, b, mu_est] = custom_LDA(train_set, train_labels);
    param_pool((n - 1) * k_fold + k, :) = [w', b];

    % output 
    output_lda = sign(w' * val_set' - b)';

    % map to class labels
    class_labels = unique(train_labels);
    output_class = zeros(size(output_lda));
    output_class(output_lda == -1) = class_labels(1);
    output_class(output_lda == 1) = class_labels(2);

    % compute scores
    score_text = ['- Artificial Samples classification - cross val fold: ' int2str(k)];
    correct_pred = sum(output_class' == val_labels);
    false_pred = length(output_class) - correct_pred;
    accuracy = correct_pred / length(output_class);

    % fill the score pool
    score_pool(n, k) = accuracy;
  end
  % compute scores averaged over all k-folds
  score_pool_k_fold = sum(score_pool(n, :)) / k_fold
end

% compute averaged scores of all repetitions
score_text = ['----- Artificial Samples LDA classification cross-val averaged over all repetitions:']
score_averaged_total = sum(sum(score_pool)) / (n_repeat * k_fold)


% -----
% LDA on P300 data with k-fold cross-falidation
clear all;

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
      %wilcoxon(sample) = ranksum(squeeze(targets(ch, sample, :)), squeeze(non_targets(ch, sample, :)));
      % for octave
      wilcoxon(ch, sample) = wilcoxon_test(squeeze(targets(ch, sample, :)), squeeze(non_targets(ch, sample, 1:400)));
    end
end

% Cz electrode channel
ch = 2;

% find the two points with the most significance
sorted_wilcoxon = sort(wilcoxon(ch, :), 'ascend');
signi_idx = find(wilcoxon(ch, :) == sorted_wilcoxon(1) | wilcoxon(ch, :) == sorted_wilcoxon(2));

% cross-validation params
n_repeat = 10;
k_fold = 10;

score_pool = zeros(n_repeat, k_fold);
param_pool = zeros(n_repeat * k_fold, 3);

% cross-validation with repetition
score_text = ['--- P300 LDA classification cross-val averaged:']
for n = 1 : n_repeat
  % cross-validation indices
  cross_val_indices = cvind('Kfold', length(segments), k_fold);

  for k = 1 : k_fold
    % test set for k-fold
    val_set = squeeze(segments(ch, signi_idx, cross_val_indices == k))';
    val_labels = squeeze(classlabels(cross_val_indices == k))';

    % train set for k-fold
    train_set = squeeze(segments(ch, signi_idx, cross_val_indices != k))';
    train_labels = squeeze(classlabels(cross_val_indices != k));

    % classify
    [w, b, mu_est] = custom_LDA(train_set, train_labels);
    param_pool((n - 1) * k_fold + k, :) = [w', b];

    % output 
    output_lda = sign(w' * val_set' - b)';

    % map to class labels
    class_labels = unique(train_labels);
    output_class = zeros(size(output_lda));
    output_class(output_lda == -1) = class_labels(1);
    output_class(output_lda == 1) = class_labels(2);

    % compute scores
    score_text = ['- P300 LDA classification - cross val fold: ' int2str(k)];
    correct_pred = sum(output_class' == val_labels);
    false_pred = length(output_class) - correct_pred;
    accuracy = correct_pred / length(output_class);

    % fill the score pool
    score_pool(n, k) = accuracy;
  end
  % compute scores averaged over all k-folds
  score_pool_k_fold = sum(score_pool(n, :)) / k_fold
end

% compute averaged scores of all repetitions
score_text = ['----- P300 LDA classification cross-val averaged over all repetitions:']
score_averaged_total = sum(sum(score_pool)) / (n_repeat * k_fold)


% -----
% find best score parameter and test it with whole dataset
% this I did additional
best_score = max(max(score_pool))
best_param_idx = find(score_pool == best_score)(1)
best_param = param_pool(best_param_idx, :)

% compute score on whole dataset
test_set = squeeze(segments(ch, signi_idx, :))';
test_labels = squeeze(classlabels)';

% restore best parameters
w = [best_param(1) best_param(2)]';
b = best_param(3);

% output 
output_lda = sign(w' * test_set' - b)';

% map to class labels
class_labels = unique(test_labels);
output_class = zeros(size(output_lda));
output_class(output_lda == -1) = class_labels(1);
output_class(output_lda == 1) = class_labels(2);

% compute scores
score_text = ['------ P300 LDA classification - best params with whole dataset: ']
correct_pred = sum(output_class' == test_labels);
false_pred = length(output_class) - correct_pred;
accuracy = correct_pred / length(output_class)


% -----
% My previous computations (in Exercise 2) for comparison:
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
[w, b, mu_est] = custom_LDA(train_set, train_labels);

% output 
output_class = sign(w' * test_set' - b)';

% compute scores
score_text = ['----- P300 LDA classification without cross-val:']
correct_pred = sum(output_class == test_labels);
false_pred = length(output_class) - correct_pred;
accuracy = correct_pred / length(output_class)
