%%
mean_r1 = 2;
std_r1 = 1;
mean_r2 = 4;
std_r2 = 2;

Y1 = normpdf(x, mean_r1, std_r1);
Y2 = normpdf(x, mean_r2, std_r2);

figure
p = plot(x, Y1)
set(p, 'Color', 'blue')
hold
p = plot(x, Y2)
set(p, 'Color', 'red')
grid on

%% Ass1.3
x = -5:0.1:10;
f = 2 ./ (2 + exp(x .* (3/8) .* (x - 8/3) ))

figure
plot(x, f)
grid on

%% whitening

% INITIALIZE SOME CONSTANTS
mu = [0 0];         % ZERO MEAN
S = [1 .9; .9 3];   % NON-DIAGONAL COV.
SDiag = [1 0; 0 3]; % DIAGONAL COV.
SId = eye(2);       % IDENTITY COV.
 
% SAMPLE SOME DATAPOINTS
nSamples = 1000;
samples = mvnrnd(mu,S,nSamples)';
samplesId = mvnrnd(mu,SId,nSamples)';
samplesDiag = mvnrnd(mu,SDiag,nSamples)';
 
% DISPLAY
subplot(321);
imagesc(SId); axis image,
caxis([0 1]), colormap hot, colorbar
title('Identity Covariance')
 
subplot(322)
plot(samplesId(1,:),samplesId(2,:),'ko'); axis square
xlim([-5 5]), ylim([-5 5])
grid
title('White Data')
 
subplot(323);
imagesc(SDiag); axis image,
caxis([0 3]), colormap hot, colorbar
title('Diagonal Covariance')
 
subplot(324)
plot(samplesDiag(1,:),samplesDiag(2,:),'r.'); axis square
xlim([-5 5]), ylim([-5 5])
grid
title('Uncorrelated Data')
 
subplot(325);
imagesc(S); axis image,
caxis([0 3]), colormap hot, colorbar
title('Non-diagonal Covariance')
 
subplot(326)
plot(samples(1,:),samples(2,:),'b.'); axis square
xlim([-5 5]), ylim([-5 5])
grid
title('Correlated Data')