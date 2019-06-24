%
% -- score function (custom)

%     typical call :
%       [output_class, w, b, mu_est] = custom_LDA(train_set, train_labels);

function [L] = custom_score(X, Y)

% input care
X = X(:);
Y = Y(:);

% map to class labels
class_labels = unique(Y);
output_class = zeros(size(X));

output_class(X == 1) = class_labels(1);
output_class(X == -1) = class_labels(2);

% compute scores

output = output_class';
targets = Y';

correct_pred = sum(output_class == Y);
false_pred = length(output_class) - correct_pred;
accuracy = correct_pred / length(output_class);

L = accuracy;

end
