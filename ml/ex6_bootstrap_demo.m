% Evaluation of parameter estimation performance using bootstrapping. 
% 
% Bootstrapping is used when you cannot sample the data anymore for some
% reason but the amount of readily available data is too small.
%
% With bootstrapping, you "generate" more data by sampling with
% replacement form the data you already have. This works, because most 
% samples will, if they're randomly chosen, look quite like the population 
% they came from. The result of bootstrapping will depend on how
% descriptive the initial sample was.

% set seed of the random number generator to always 
% produce the same random numbers
rng(100); 

num_samples = 50;

%mean_parameter = 5; % normal distribution parameters
%std_parameter = 2;

shape_k = 2; % Gamma distribution parameters
scale_omega = 2;


%X = mean_parameter+std_parameter*randn(num_samples,1); % normal distributed signal
X = gamrnd(shape_k,scale_omega,num_samples,1); % Gamma distributed signal
X(num_samples+1) = 100000; % Large outlier
X(num_samples+2) = 100000000000; % Huge outlier

figure % data histogram 
histogram(X,15)

%%
figure % oops! some outliers, let's try again
histogram(X(X<15),[0:15])
hold on
Y = gampdf(0:0.1:15, shape_k, scale_omega);
plot(0:0.1:15,Y*num_samples,'r')


%% Form 1000000 bootstraps of the data size to evaluate the mean parameter
bootstrap_size = 52; %length of X
bootstrap_num = 1000000; %number if bootstraps

%random bootstrap samples with replacement
bootstrap_indexes = randi(num_samples+2, bootstrap_num, bootstrap_size); 
bootstrap_samples = zeros(bootstrap_num,bootstrap_size);
for i = 1:bootstrap_num,
bootstrap_samples(i,:) =  X(bootstrap_indexes(i,:));
end

% Write here programs trying to estimate the mean_parameter 
% (these are tested using the generated bootstraps)
% Try mean and median. Filter the outliers and try again.

prog_1 = mean(bootstrap_samples,2); % program 1 (mean) 

prog_2 = median(bootstrap_samples,2); % program 2 (median)
% remove outliers
bootstrap_samples_without_outliers = bootstrap_samples;
bootstrap_samples_without_outliers(bootstrap_samples>1000) = NaN; 

% program 4 (outlier filtered mean)
prog_4 = nanmean(bootstrap_samples_without_outliers,2);
% program 5 (outlier filtered median)
prog_5 = nanmedian(bootstrap_samples_without_outliers,2); 

% The programs could be basically anything. 
% Evaluate the parameters using the whole original data with the programs

% true_mean_X = mean_parameter % true parameter 
% (not really known, but for illustrative purposes)

% true mean for the gamma distribution 
%(only really known for simulated data)
true_mean_X = scale_omega*shape_k; 
mean_X = mean(X) % prog 1
median_X = median(X) % prog 2
outlier_filtered_mean_X = mean(X(X<1000)) % prog 4 (crude outlier filtering)
outlier_filtered_median_X = median(X(X<1000)) % prog 5

% Evaluate the generated bootstraps with the programs (bias and variance)
% bias and variance of prog 1 (mean)
bootstrap_mean_prog_1 = mean(prog_1)
bias_prog_1 = mean(prog_1-mean_X)
var_prog_1 = var(prog_1)
mean_X_unbiased = mean_X+bias_prog_1
error_prog_1 = bootstrap_mean_prog_1-true_mean_X
unbiased_error_prog_1 = mean_X_unbiased - true_mean_X

% bias and variance of prog 2 (median)
bootstrap_mean_prog_2 = mean(prog_2)
bias_prog_2 = mean(prog_2-median_X)
var_prog_2 = var(prog_2)
median_X_unbiased = median_X+bias_prog_2
error_prog_2 = bootstrap_mean_prog_2-true_mean_X
unbiased_error_prog_2 = median_X_unbiased - true_mean_X

% bias and variance of prog 4 (mean with outliers removed)
bootstrap_mean_prog_4 = mean(prog_4)
bias_prog_4 = mean(prog_4-outlier_filtered_mean_X)
var_prog_4 = var(prog_4)
outlier_filtered_mean_X_unbiased = outlier_filtered_mean_X+bias_prog_4
error_prog_4 = bootstrap_mean_prog_4-true_mean_X
unbiased_error_prog_4 = outlier_filtered_mean_X_unbiased - true_mean_X

% bias and variance of prog 5 (median with outliers removed)
bootstrap_mean_prog_5 = mean(prog_5)
bias_prog_5 = mean(prog_5-outlier_filtered_median_X)
var_prog_5 = var(prog_5)
outlier_filtered_median_X_unbiased = outlier_filtered_median_X+bias_prog_5
error_prog_5 = bootstrap_mean_prog_5-true_mean_X
unbiased_error_prog_5 = outlier_filtered_median_X_unbiased - true_mean_X

% test one of the algorithm with more data 
%(use the shorter num_samples length for the algorithm)

test_size = 5000;
X2 = gamrnd(shape_k,scale_omega,test_size,1); % new bigger test data
X2(test_size+1:test_size+floor(test_size/100)) = randi([900 1000000000000000],floor(test_size/100),1); % 1% random outliers

num_tests = 10000;
for i = 1:1:num_tests
    %random permutation sample of data
    test_X2 = X2(randperm(length(X2), bootstrap_size)); 
    test_X2(test_X2>1000) = NaN; % remove outliers
    % program 4 (outlier filtered mean) + bias4
    test_mean(i) = nanmean(test_X2)+bias_prog_4; 
end
test_mean_result = mean(test_mean) % mean result
figure
histogram(X2,15)
figure
histogram(X2(X2<15),[0:15])
hold on
Y2 = gampdf(0:0.1:15, shape_k, scale_omega);
plot(0:0.1:15,Y2*test_size,'r')

