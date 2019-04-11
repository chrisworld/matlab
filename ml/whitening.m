% INITIALIZE SOME CONSTANTS
mu = [0 0];
S = [1 .9; .9 3];
 
% SAMPLE SOME DATAPOINTS
nSamples = 1000;
samples = mvnrnd(mu,S,nSamples)';
 
% WHITEN THE DATA POINTS...
[E,D] = eig(S);
 
% ROTATE THE DATA
samplesRotated = E*samples;
 
% TAKE D^(-1/2)
D = diag(diag(D).^-.5);
 
% SCALE DATA BY D
samplesRotatedScaled = D*samplesRotated;
 
% DISPLAY
figure;
 
subplot(311);
plot(samples(1,:),samples(2,:),'b.')
axis square, grid
xlim([-5 5]);ylim([-5 5]);
title('Original Data');
 
subplot(312);
plot(samplesRotated(1,:),samplesRotated(2,:),'r.'),
axis square, grid
xlim([-5 5]);ylim([-5 5]);
title('Decorrelate: Rotate by V');
 
subplot(313);
plot(samplesRotatedScaled(1,:),samplesRotatedScaled(2,:),'ko')
axis square, grid
xlim([-5 5]);ylim([-5 5]);
title('Whiten: scale by D^{-1/2}');