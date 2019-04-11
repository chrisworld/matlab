clear all;
close all;
clc;

% Generate values from a normal distribution with mean 1 and 
% standard deviation 2.
r1 = 1 + 2.*randn(10000,1);

%Generate values from a normal distribution with mean 12 and standard 
% deviation 4.
r2 = 12 + 4.*randn(10000,1);

%% Draw a figure in order to illustrate the density probability functions 
% of the distributions. Use histcouts command.

% steps
stepsize = 0.1;
x = min(min(r1), min(r2)):stepsize:max(max(r1),max(r2));

% 1.histogramm
h1 = histcounts(r1, x);
h1 = h1/sum(h1)/stepsize;

% plot 1.histogramm
bincenters = x(1:end-1) + diff(x)/2;
figure; plot(bincenters, h1)
hold on

% 2.histogramm
h2 = histcounts(r2, x);
h2 = h2/sum(h2)/stepsize;
plot(bincenters, h2)
hold off


%% Search the intersection of the distributions. Use solve (see help solve)
% with equations for normal distributions. 
% Plot the evaluated solution(s) 
% (use normpdf to generate the distributions).

mean_r1 = 1;
std_r1 = 2;
mean_r2 = 12;
std_r2 = 4;

syms y;
norm_r1 = (1/(sqrt(2*(std_r1^2)*pi)))*exp(-(((y-mean_r1)^2))/(2*(std_r1^2)))
norm_r2 = (1/(sqrt(2*(std_r2^2)*pi)))*exp(-(((y-mean_r2)^2))/(2*(std_r2^2)))

solutions = solve(norm_r1 == norm_r2)
sola = eval(solutions(1))
solb = eval(solutions(2))

% grabing current figure
gca
hold
plot([sola sola],[0 max([h1 h2])],'k--')
plot([solb solb],[0 max([h1 h2])],'k--')

%% plot the evaluated solution
Y1 = normpdf(x, mean_r1, std_r1);
p = plot(x, Y1)
set(p, 'Color', 'red')

Y2 = normpdf(x, mean_r2, std_r2);
p = plot(x, Y2)
set(p, 'Color', 'red')

%If Priori probabilities are 2/5 and 3/5 respectively, apply Bayes
%formula to draw posterior probabilities.

% priori probabilities
P_r1 = 2/5;
P_r2 = 3/5;

% bayers
Pw1 = h1.*P_r1./(h1.*P_r1+h2.*P_r2);
Pw2 = h2.*P_r2./(h1.*P_r1+h2.*P_r2);

% plot the posterior prob in new figure
figure, plot(bincenters, Pw1)
hold
plot(bincenters, Pw2)

% exact data
C1 = normpdf(x, mean_r1, std_r1);
C2 = normpdf(x, mean_r2, std_r2);

% bayers
CPw1 = C1.*P_r1./(C1.*P_r1+C2.*P_r2);
CPw2 = C2.*P_r2./(C1.*P_r1+C2.*P_r2);

% plott
p = plot(x, CPw1)
set(p, 'Color', 'red')
p = plot(x, CPw2)
set(p, 'Color', 'red')

hold



