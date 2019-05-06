clear all;
close all;
clc;

n_samples = 1000;
x = 2 * rand(n_samples, 1);

y1 = exp(x);
y2 = x .+ x.^2;
y3 = sqrt(x);

n_bins = 100;

% calculate pdf 
hist(x, n_bins, n_samples)
%hist(x, n_bins)

means_y = [mean(y1) mean(y2) mean(y3)]
std_y = [std(y1) std(y2) std(y3)]