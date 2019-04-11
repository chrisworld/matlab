clear all;
close all;
clc;

%% Form a vector x
x = -2:0.1:22;
%Use normpdf function to calculate two distributions 
%(means of 8 and 12, both with the std of 2)
P1 = normpdf(x, 8, 2);
P2 = normpdf(x, 12, 2);

 
%Plot the distributions
figure, plot(x, P1)
hold
plot(x, P2)
hold

%% Calculate the respective cumulative functions with normcdf
CP1 = normcdf(x, 8, 2);
CP2 = normcdf(x, 12, 2);

%Plot the cumulative functions
figure, plot(x, CP1)
hold
plot(x, CP2)
hold

%% Plot ROC curve using the cumulative functions
figure, plot(CP2, CP1)
hold

%Calculate another set of cumulative functions using the same means as
%before but now with std of 4
CP3 = normcdf(x, 8, 4);
CP4 = normcdf(x, 12, 4);

%Plot the respective ROC curve
plot(CP4, CP3)

%What happens if the distributions are equal? (plot the curve)
plot(CP3, CP3)

%% Use the following more complex distributions 

x = -5:0.1:20;
P5 = (normpdf(x, 8, 1.5) + normpdf(x, 4, 2))/2;
P6 = (0.2*normpdf(x, 6, 1) + normpdf(x, 15, 2) + normpdf(x, 9, 0.5))/2.2;

%Plot the resulting ROC curve
fig_handle1 = figure
plot(x, P5)
hold
plot(x, P6)
hold

%Plot the resulting ROC curve
TP = (normcdf(x, 8, 1.5) + normcdf(x, 4, 2))/2;
FP = (0.2*normcdf(x, 6, 1) + normcdf(x, 15, 2) + normcdf(x, 9, 0.5))/2.2;

fig_handle2 = figure
plot(FP, TP) 
xlabel('False positive rate')
ylabel('True positive rate')
 
%The cost of a false negative (postive beign the first distribution P5) 
%is 10 and the cost of a false positive (the second distribution P6 is 
%negative) is 2. Costs for true positives
%and true negatives are both 1. Assume equal prior probabilities. 
%Use the ROC curve to choose the optimal
%single decision boundary operating point using these costs 
%(plot the corresponding decision boundary)

cost_tp = 1;
cost_tn = 1;
cost_fp = 2;
cost_fn = 10;

FN = 1-TP;
TN = 1-FP;

%conditional risk R
cost = (TP*cost_tp + FN*cost_fn + FP*cost_fp + TN*cost_tn); 

[min_cost index] = min(cost)
boundary = x(index);

figure, plot(cost)
hold
plot([index index], [0, max(cost)], 'k--');
title('cost')
legend('cost', 'cost min')

figure(fig_handle1)
hold
plot([boundary boundary], [0 0.4], 'k--');
legend('P1', 'P2', 'baundary')

figure(fig_handle2)
hold
plot(FP(index), TP(index), 'ko')
legend('ROC', 'cost min')



