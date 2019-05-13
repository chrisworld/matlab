%
% -- 10x10 cross val function (custom)
%     typical call :
%       L = cross_val_10x10(X, Y);

function [L, K, w, b] = cross_val_10x10(X, Y, w, b)

% determine if train or test
is_train = 1;
if (nargin >= 3)  
  is_test = 0;  
end

n_repeat = 10;
k_fold = 10;

n_features = size(X, 2);

score_pool = zeros(n_repeat, k_fold);
param_pool = zeros(n_repeat * k_fold, n_features + 1);

% randomize data
RV = randperm(length(X));
X = X(RV, :);
Y = Y(RV);

for n = 1 : n_repeat
  % cross-validation indices
  cross_val_indices = cvind('Kfold', length(X), k_fold);

  for k = 1 : k_fold
    % validation set for k-fold
    val_set = X(cross_val_indices == k, :);
    val_labels = Y(cross_val_indices == k)';

    % train set for k-fold
    train_set = X(cross_val_indices != k, :);
    train_labels = Y(cross_val_indices != k);

    % classify
    if (is_train)
      [w, b] = custom_LDA(train_set, train_labels);
      param_pool((n - 1) * k_fold + k, :) = [w', b];
    end

    % output 
    output_lda = sign(w' * val_set' - b)';

    % compute score
    accuracy = custom_score(output_lda, val_labels);

    % fill the score pool
    score_pool(n, k) = accuracy;
  end
  % compute scores averaged over all k-folds
  score_pool_k_fold = sum(score_pool(n, :)) / k_fold;
end

K = score_pool;
L = sum(sum(score_pool)) / (n_repeat * k_fold);