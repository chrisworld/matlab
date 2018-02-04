%---------------------
% fdc hw3 e)
% Christian Walter, 01431717
%---------------------

%clc
%close all
clear all

% packages for octave
pkg load communications		% for qfunc

run_time = tic;

% params
% ---
% realizations
N = 10^(6);

% signals params
e_av = 1;
Pm1 = 0.05;
Pm2 = 0.35;
Pm3 = 0.60;
Pm = [Pm1, Pm2, Pm3];
% create the signal vectors
sm1 = e_av*[1; 0; 0];
sm2 = e_av*[0; 1; 0];
sm3 = e_av*[0; 0; 1];
sm123 = [sm1, sm2, sm3];
% samples of the signal signal
sm = [repmat(sm1, 1, Pm1*N), repmat(sm2, 1, Pm2*N), repmat(sm3, 1, Pm3*N)];
% permut the signal vectors
rsm = randperm(N);
sm = sm(:, rsm);

% labels
labels = [repmat(1, 1, Pm1*N), repmat(2, 1, Pm2*N), repmat(3, 1, Pm3*N)];
labels = labels(:, rsm);

% loop the power
for snr = -4 : 1 : 12;
  snr_lin = 10.^(snr/10);

  % Power spectral density of noise
  N0 = e_av./snr_lin;

  % noise vector
  n = N0 .* randn(3, N);

  % signal space model
  r = sm + n;

  % min distance algorithm
  err_ml = 0;
  err_map = 0;
  for sample = 1 : 1 : N
    d = sum((repmat(r(:,sample), 1, 3) - sm123).^2, 1);
    [v_ml m_ml] = min(d);
    [v_map m_map] = max(d .* log(Pm));
    if m_ml == labels(sample);
    else err_ml++;
    end
    if m_map == labels(sample);
    else err_map++;
    end
  end
  Pe_ml(end + 1) = err_ml / N;
  Pe_map(end + 1) = err_map / N;
end
Pe_ml
Pe_map

% calc. approx. error probability
% nearest neighbors Ne
Ne = 2;

snr = -4 : 1 : 12;
snr_lin = 10.^(snr/10);
Pe_apx = Ne * qfunc(sqrt(snr_lin));

figure 2;
semilogy(snr, Pe_apx, 'k--');
hold on;
semilogy(snr, Pe_ml, 'r');
hold on;
semilogy(snr, Pe_map, 'b');
hold off;
grid on;
title('Error Probabilities P_e');
xlabel('e_{av}/N_0 / [dB]');
ylabel('P_e');
legend('approx.', 'ML', 'MAP');

toc(run_time)


%---------------------
% useful stuff
%---------------------
% check normal distribution
%mean_val = mean(n(1,:))
%variance = var(n(1,:))
%figure 1;
%hist(n(1,:), 100);
