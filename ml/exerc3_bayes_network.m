close all
clear all
clc

%load data matrix from file (contains 1000x3 matrix X)
load bnetdata.mat

%%
% Look at the data (rows correspond to samples and the three columns A, B, 
% and C contain feature values)
% See what values are possible for each feature and construct the three 
% dimensional count matrix C_ABC and
% the corresponding probability matrix P_ABC for the data.

Na = length(unique(X(:,1)));
Nb = length(unique(X(:,2)));
Nc = length(unique(X(:,3)));

C_ABC = zeros(Na, Nb, Nc);
N = size(X,1);

for in = 1:N
    C_ABC(X(in,1), X(in,2), X(in,3)) = C_ABC(X(in,1), X(in,2), X(in,3))+1;
end

P_ABC = C_ABC / N;

%%
% Assume that there can be correlation and causality between features!
% Look at bayesnet.png for two prospective network structures. 
% Form the marginalized counts indicated by the network 
% structure in both cases. Construct bayesian formulas for 
% the networks and calculate the corresponding probability distributions.

% For the first net the conditional probability is:
% P( C=c | A=a , B=b ) = C_ABC( a, b, c ) / C_AB( a, b )
%

% Counts
C_AB = sum(C_ABC, 3);
C_A = sum(C_AB, 2);
C_B = sum(C_AB, 1);

% Probabiltities
P_A = C_A / N;
P_B = C_B / N;

for a = 1:Na,
    for b = 1:Nb
        for c = 1:Nc
            P_C_AB_bayes(a, b, c) = C_ABC(a, b, c) / C_AB(a, b);
        end
    end
end

%%
% and using Bayes networks the predicted posteriori probability
% distribution is:
%  P( a, b, c ) = P( c | a , b ) * P_A(a) * P_B(b)
%   = C_ABC( a, b, c ) / C_AB( a, b ) * P_A(a) * P_B(b)  

P_ABC_bayes = zeros(Na, Nb, Nc);

for a = 1:Na,
    for b = 1:Nb
        for c = 1:Nc
            P_ABC_bayes(a, b, c) = C_ABC(a, b, c) / C_AB(a, b)...
            * P_A(a) * P_B(b);  
        end
    end
end

%%
% Observe the results for both networks and compare with the matrix P_ABC 
% calculated directly from the observed data.

result1 = P_ABC - P_ABC_bayes

C_BC = sum(C_ABC, 1);
P_C = sum(C_BC, 2)/N;

P_ABC_bayes2 = zeros(Na, Nb, Nc);

for a = 1:Na,
    for b = 1:Nb
        for c = 1:Nc
            P_ABC_bayes2(a, b, c) = C_ABC(a, b, c) / C_BC(1, b, c)...
            * P_B(b) * P_C(c);  
        end
    end
end

%% Which network is the better assumption? Is it the correct one?

P_ABC_bayes2(isnan(P_ABC_bayes2)) = 0;

result2 = P_ABC - P_ABC_bayes2


