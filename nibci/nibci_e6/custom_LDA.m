%
% -- LDA function (self defined)
%     only tested 2-dimensional data
%     no fancy safety stuff done
%     typical call :
%       [output_class, w, b, mu_est] = custom_LDA(train_set, train_labels);

function [w, b, mu_est] = custom_LDA(train_set, train_labels)

% find class labels
class_labels = unique(train_labels);

% split into the two classes for training
train_c1 = train_set(train_labels == class_labels(1), :);
train_c2 = train_set(train_labels == class_labels(2), :);

%% lda classifier parameters
w = zeros(2, 1);
b = 0;

% calculate the parameters of LDA
% common co-Variance matrix
covM_c = 0.5 * ( diag(std(train_c1)).^2 + diag(std(train_c2)).^2 );

% weights
w = inv(covM_c) * (mean(train_c1) - mean(train_c2))';

% estimated mean
mu_est = (mean(train_c1) + mean(train_c2))' / 2;

% biases
b = w' * mu_est;

end
