%% Start
function white()
close all
clear all
clc
% Load data
load H7_data.mat
X_features = X(:, 2:end);
X_classes = X(:,1);
patternReqSystem(X_features, X_classes, 1)
end

%% Pattern Recognition
function patternReqSystem(X_features, X_classes, k)
%
% Pattern recognition system
% OUTPUTS:
% INPUTS:
% X_features       matrix containing the data
% X_classes        correct labels for the data

%% Data extraction
N = size(X_features,1);
num_features = size(X_features,2);

%% Whitening the data
X_stand = standardize(X_features); 

%% Select training and validation sets
% Forward search implements leave-one-out cross validation 
% therefore a separate test set is included in training
% 2/3 for training and 1/3 for validation. 
%selection = randperm(N);
selection = 1:N;
training_data = X_stand(selection(1:floor(2*N/3)), :);
training_class = X_classes(selection(1:floor(2*N/3)), :);
validation_data = X_stand(selection((floor(2*N/3)+1):N), :);
validation_class = X_classes(selection((floor(2*N/3)+1):N), :);

%% Train feature vector
fvector = zeros(num_features,1);
best_result = 0;
for in = 1:num_features
    [best_result_add, best_feature_add] = ...
        forwardsearch(training_data, training_class, fvector, k);
    % Update the feature vector  
    fvector(best_feature_add) = 1;
  
    % Save best result
    if(best_result < best_result_add)
        best_result = best_result_add;
        best_fvector = fvector;
    end
end

best_result
best_fvector

%% Test results. Train the system and evaluate the accuracy.
valid_res = knnclass(validation_data, training_data, ...
    best_fvector, training_class, k);
correct = sum(valid_res == validation_class);
validation_result = correct / length(validation_class)
end

%% Standardize
function [feat_out] = standardize(feat_in)
%Be careful with this function
N = length(feat_in); 

% centering
feat_cent = feat_in - repmat(mean(feat_in), N, 1);

% Method 1: Standardization
feat_stand = feat_cent ./ repmat(std(feat_cent), N, 1);

% Method 2: Whiten with eigenvalue decomposition
% covar_mat = feat_cent * feat_cent'
[A, B] = eig(cov(feat_in));
Y1 = sqrt(inv(B)) * A' * feat_in';
feat_white = Y1';
%cov(feat_white);

% Method 3: Whiten with SVD
[U, S, V] = svd(cov(feat_cent), 0);
Y2 = sqrt(inv(S)) * V' * feat_cent';
feat_white2 = Y2';
cov(feat_white2);

[U, S, V] = svd(feat_cent, 0);
%Y3 = sqrt(inv(S)) * V' * feat_cent';
%feat_white3 = Y3';
%cov(feat_white3)

% output
%feat_out = feat_stand;
feat_out = feat_white;
%feat_out = feat_white2;
end

%% KNN
function [predictedLabels] = knnclass(dat1, dat2, fvec, classes, k)

    p1 = pdist2( dat1(:,logical(fvec)), dat2(:,logical(fvec)) );
    % Here we aim in finding k-smallest elements
    [D, I] = sort(p1', 1);

    I = I(1:k+1, :);
    labels = classes( : )';
    % this is for k-NN, k = 1
    if k == 1 
        predictedLabels = labels( I(2, : ) )';
    % this is for k-NN, other odd k larger than 1
    else 
        predictedLabels = mode( labels( I( 1+(1:k), : ) ), 1)';
    end
end

%% SFS
function [best, feature] = forwardsearch(data, data_c, fvector, k)
    % SFS, from previous lesson.
    num_samples = length(data);
    best = 0;
    feature = 0;
    
    for in = 1:length(fvector)
        if (fvector(in) == 0)
            fvector(in) = 1;
            % Classify using k-NN
	        predictedLabels = knnclass(data, data, fvector, data_c, k);
            % the number of correct predictions
            correct = sum(predictedLabels == data_c); 
            result = correct/num_samples; % accuracy
            if(result > best)
                best = result; 
                feature = in; 
            end
            fvector(in) = 0;
        end
    end
end

