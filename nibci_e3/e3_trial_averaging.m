% clear all
clear all;
close all;
clc

% load data
load BI5_segments_HTS.mat

% separate target and non-tragets
targets = segments(:, :, classlabels == 2);
non_targets = segments(:, :, classlabels == 1);

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


% create trial datasets
n_trials = [3, 5, 10];

% cross-validation params
n_repeat = 10;
k_fold = 10;

% run all trial sets
for t = 1 : length(n_trials)

  % determine if residual in trials
  residual_t = mod(length(targets), n_trials(t))
  residual_n = mod(length(non_targets), n_trials(t))

  % crazy one liners to average the trials
  trial_targets = [mean(reshape(squeeze(targets(ch, signi_idx, 1:end-residual_t))(1,:), n_trials(t), [])); mean(reshape(squeeze(targets(ch, signi_idx, 1:end-residual_t))(2,:), n_trials(t), []))]';
  trial_non_targets = [mean(reshape(squeeze(non_targets(ch, signi_idx, 1:end-residual_n))(1,:), n_trials(t), [])); mean(reshape(squeeze(non_targets(ch, signi_idx, 1:end-residual_n))(2,:), n_trials(t), []))]';
  trial_set = [trial_targets; trial_non_targets];
  trial_labels = [ones(length(trial_targets), 1) * 2; ones(length(trial_non_targets), 1)];

  score_pool = zeros(n_repeat, k_fold);

  % cross-validation with repetition
  score_text = ['--- P300 LDA classification cross-val averaged with trial size: ' int2str(n_trials(t))]
  for n = 1 : n_repeat
    % cross-validation indices
    cross_val_indices = cvind('Kfold', length(trial_set), k_fold);

    for k = 1 : k_fold
      % test set for k-fold
      val_set = squeeze(trial_set(cross_val_indices == k, :));
      val_labels = squeeze(trial_labels(cross_val_indices == k));

      % train set for k-fold
      train_set = squeeze(trial_set(cross_val_indices != k, :));
      train_labels = squeeze(trial_labels(cross_val_indices != k));

      % classify
      [w, b, mu_est] = custom_LDA(train_set, train_labels);

      % output 
      output_lda = sign(w' * val_set' - b)';

      % map to class labels
      class_labels = unique(train_labels);
      output_class = zeros(size(output_lda));
      output_class(output_lda == -1) = class_labels(1);
      output_class(output_lda == 1) = class_labels(2);

      % compute scores
      score_text = ['- P300 LDA classification - cross val fold: ' int2str(k)];
      correct_pred = sum(output_class == val_labels);
      false_pred = length(output_class) - correct_pred;
      accuracy = correct_pred / length(output_class);

      % fill the score pool
      score_pool(n, k) = accuracy;
    end
    % compute scores averaged over all k-folds
    score_pool_k_fold = sum(score_pool(n, :)) / k_fold
  end
  % compute averaged scores of all repetitions
  score_text = ['----- P300 LDA classification cross-val averaged over all repetitions with trial size: ' int2str(n_trials(t))]
  score_averaged_total = sum(sum(score_pool)) / (n_repeat * k_fold)
end






