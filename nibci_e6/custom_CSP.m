%
% -- CSP function custom
%     no fancy safety stuff done
%     typical call :
%       [output_class, w, b, mu_est] = custom_LDA(train_set, train_labels);

function [V_s, D_s] = custom_CSP(X)

  n_trial = size(X, 1);
  n_ch = size(X, 2);

  % calculate separate spatial normalized covariance
  sigm = zeros(n_trial, n_ch, n_ch);
  for trial = 1 : n_trial
    XX_t = squeeze(X(trial, :, :)) * transpose(squeeze(X(trial, :, :)));
    sigm(trial, :, :) = XX_t / trace(XX_t);
  end

  % average covariance matrices
  sigm1 = squeeze(mean(sigm(1 : n_trial / 2, :, :), 1));
  sigm2 = squeeze(mean(sigm(n_trial / 2 + 1 : n_trial, :, :), 1));

  % calculate eigenvalues
  %[V, D] = eig(sigm1, sigm1 + sigm2, 'qz');
  [V, D] = eig(sigm1, sigm1 + sigm2);

  % sort eigenvalues according to magnitude in D
  [D_s, D_si] = sort(D * ones(n_ch, 1));
  V_s = V(:, D_si);

end