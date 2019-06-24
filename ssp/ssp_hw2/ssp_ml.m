clear all;
close all;
clc;

% packages for octave
%pkg load signal
pkg load statistics

% create samples for monte carlo analysis
n_runs = 100;

% constant sample
x = 1;

% --
% vary M

% normal distribution params of A
mu_a = 1;
sigm_a = 1;

% samples for evaluation variation
M_vec = [1E1 1E2 1E3 1E4];

% score pools
x_ml_bias_pool = zeros(length(M_vec), 1);
x_ml_var_pool = zeros(length(M_vec), 1);
x_ml_mse_pool = zeros(length(M_vec), 1);
x_mean_bias_pool = zeros(length(M_vec), 1);
x_mean_var_pool = zeros(length(M_vec), 1);
x_mean_mse_pool = zeros(length(M_vec), 1);

for m = 1 : length(M_vec)

  % get amount of samples
  M = M_vec(m);

  % set up vectors
  mu_a_vec = mu_a * ones(M, 1);
  x_ml_pool = zeros(n_runs, 1);
  x_mean_pool = zeros(n_runs, 1);

  % monte carlo runs
  for n = 1 : n_runs

    % samples of random variable A
    a_n = sigm_a * (rand(M, 1) + mu_a);

    % measurements
    d_n = a_n .* x;

    % ML estimator
    x_ml_pool(n) = ( -d_n' * mu_a_vec + sqrt( (d_n' * mu_a_vec)^2 + 4 * M * sigm_a^2 * d_n' * d_n ) ) / (2 * M * sigm_a^2);

    % modified mean estimator
    x_mean_pool(n) = mean(d_n) / mu_a;

  end

  % box plot
  figure(m)
  boxplot([x_ml_pool, x_mean_pool]);
  grid on
  ylim([0.8 1.8])
  print(['box_' num2str(M)],'-dpng')

  % evaluate scores
  % bias
  x_ml_bias_pool(m) = mean(x_ml_pool) - x;
  x_mean_bias_pool(m) = mean(x_mean_pool) - x;

  % variance
  x_ml_var_pool(m) = var(x_ml_pool);
  x_mean_var_pool(m) = var(x_mean_pool);

  % MSE
  x_ml_mse_pool(m) = mean( (x_ml_pool - x) .^ 2 );
  x_mean_mse_pool(m) = mean( (x_mean_pool - x) .^ 2 );

end

% plot scores
figure(11)
hold on
loglog(M_vec, x_ml_mse_pool, 'r', 'LineWidth', 2)
loglog(M_vec, x_mean_mse_pool, 'LineWidth', 2)
xlabel('Amount of samples', 'fontsize', 16)
ylabel('MSE', 'fontsize', 16)
grid on
lgd = legend('ml', 'mean');
set(lgd, 'FontSize', 12);
print('mse','-dpng')


% --
% vary sigma

% normal distribution params of A
mu_a = 1;
sigm_a_vec = [1, 2, 4, 8];

% samples for evaluation variation
M = 1000;

% score pools
x_ml_bias_pool = zeros(length(M_vec), 1);
x_ml_var_pool = zeros(length(M_vec), 1);
x_ml_mse_pool = zeros(length(M_vec), 1);
x_mean_bias_pool = zeros(length(M_vec), 1);
x_mean_var_pool = zeros(length(M_vec), 1);
x_mean_mse_pool = zeros(length(M_vec), 1);

for m = 1 : length(sigm_a_vec)

  % get sigma
  sigm_a = sigm_a_vec(m);

  % set up vectors
  mu_a_vec = mu_a * ones(M, 1);
  x_ml_pool = zeros(n_runs, 1);
  x_mean_pool = zeros(n_runs, 1);

  % monte carlo runs
  for n = 1 : n_runs

    % samples of random variable A
    a_n = sigm_a * (rand(M, 1) + mu_a);

    % measurements
    d_n = a_n .* x;

    % ML estimator
    x_ml_pool(n) = ( -d_n' * mu_a_vec + sqrt( (d_n' * mu_a_vec)^2 + 4 * M * sigm_a^2 * d_n' * d_n ) ) / (2 * M * sigm_a^2);

    % modified mean estimator
    x_mean_pool(n) = mean(d_n) / mu_a;

  end

  % box plot
  figure(20 + m)
  boxplot([x_ml_pool, x_mean_pool]);
  grid on
  %ylim([0.8 1.8])
  print(['box_sigma_' num2str(sigm_a)],'-dpng')

  % evaluate scores
  % bias
  x_ml_bias_pool(m) = mean(x_ml_pool) - x;
  x_mean_bias_pool(m) = mean(x_mean_pool) - x;

  % variance
  x_ml_var_pool(m) = var(x_ml_pool);
  x_mean_var_pool(m) = var(x_mean_pool);

  % MSE
  x_ml_mse_pool(m) = mean( (x_ml_pool - x) .^ 2 );
  x_mean_mse_pool(m) = mean( (x_mean_pool - x) .^ 2 );

end

% plot scores
figure(31)
hold on
loglog(sigm_a_vec, x_ml_mse_pool, 'r', 'LineWidth', 2)
loglog(sigm_a_vec, x_mean_mse_pool, 'LineWidth', 2)
xlabel('Variance of A', 'fontsize', 16)
ylabel('MSE', 'fontsize', 16)
grid on
lgd = legend('ml', 'mean');
set(lgd, 'FontSize', 12);
print('mse_sigma','-dpng')
