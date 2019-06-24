%
% -- LDA function (self defines)
%     only tested 2-dimensional data
%     no fancy safety stuff done
%     typical call :
%       [output_class, w, b, mu_est] = custom_LDA(train_set, train_labels, test_set);

function [output_class, w, b, mu_est] = custom_LDA(train_set, train_labels, test_set)

% split in the two classes
train_c1 = train_set(train_labels == 1, :);
train_c2 = train_set(train_labels == -1, :);

%% lda classifier parameters
w = zeros(2, 1);
b = 0;

% calculate the parameters of LDA
% common co-Variance matrix
covM_c = 1 / 2 * ( diag(std(train_c1)).^2 + diag(std(train_c2)).^2 );

% weights
%w = inv(covM_c) * (mu_c1 - mu_c2)'
w = inv(covM_c) * (mean(train_c1) - mean(train_c2))';

% estimated mean
mu_est = (mean(train_c1) + mean(train_c2))' / 2;

% biases
b = w' * mu_est;

% output 
output_class = sign(w' * test_set' - b)';

end