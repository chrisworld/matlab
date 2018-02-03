%---------------------
% fdc hw3 e)
% Christian Walter, 01431717
%---------------------

% params
% ---
% realizations
N = 10^(2);

% snr
snr = -4 : 0.5 : 12;
snr_lin = 10.^(snr/10);

% noise vector
n = randn(3, N);
% check normal distribution
mean(n);
var(n);
figure 1;
hist(n, 100);

% signals params
e_av = 1;
Pm1 = 0.05;
Pm2 = 0.35;
Pm3 = 0.60;
Nm1 = Pm1 * N;
Nm2 = Pm2 * N;
Nm3 = Pm3 * N;
% create the signal vectors
sm1 = [e_av*ones(1, Nm1); zeros(2, Nm1)];
sm2 = [zeros(1, Nm2); e_av*ones(1, Nm2); zeros(1,Nm2)];
sm3 = [zeros(2, Nm3); e_av*ones(1, Nm3)];
% permut the signal vectors
sm = [sm1, sm2, sm3];
rsm = randperm(N);
sm = sm(:, rsm);

% signal space model
r = sm + n;
size(r)

for k = 1 : 1 : N
  sm(:, k)
end


% calc. approx. error probability
% nearest neighbors Ne
Ne = 2;
Papx = Ne * qfunc(sqrt(snr_lin));

% plot
figure 2;
plot(snr, 10*log(Papx));
grid on;
title('Error probabilities');

figure 3;
semilogy(snr, Papx);
grid on;
title('Error Probabilities P_e');
xlabel('e_{av}/N_0 / [dB]');
ylabel('P_e');
legend('approx. P_e')

