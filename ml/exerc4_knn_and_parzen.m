close all
clear all
clc

% Lets generate some 2-dimensional normal distributed data clusters 
% with different means and stds.
r_11 = 5+3*randn(100, 1);
r_12 = 3+3*randn(100, 1);

fig_handle1 = figure
plot(r_11, r_12, 'kx')
hold

r_21 = 15+2*randn(100, 1);
r_22 = 10+2*randn(100, 1);
plot(r_21, r_22, 'k+')

r_31 = 3+1*randn(100, 1);
r_32 = 13+3*randn(100, 1); %Notice the larger std in one direction
plot(r_31, r_32, 'k*')

% In this exercise, we are not interested in classes of the data. 
% All are the same.
% Join the distributions into a one data matrix.
R = [ r_11 r_12; r_21 r_22; r_31 r_32];
n = length(R);

% Create a two dimensional grid for density estimations 
% (use e.g. the ndgrid function)

grid_lim_x1 = -10;
grid_lim_x2 = 30;
grid_lim_y1 = -10;
grid_lim_y2 = 30;
grid_step = 0.5;

[X1,X2] = ndgrid(grid_lim_x1:grid_step:grid_lim_x2, ...
    grid_lim_y1:grid_step:grid_lim_y2);

[gridx, gridy] = size(X1);
figure(fig_handle1)
plot(X1, X2, 'k')
plot(X2, X1, 'k')
hold


%% KNN
% Calculate an estimate of density using a k-nearest neighbor 
%(KNN) estimator. Use the abovecreated data and grid. Assume 
% Euclidean distance metric and choose a suitable k value for the data.

Pn_knn = zeros(gridx, gridy);

% odd kn
kn = (round(sqrt(n)/2)-1/2)*2; 

for in = 1:gridx
    for jn = 1:gridy
        d = sqrt((R(:,1) - X1(in, jn)).^2 + (R(:,2) - X2(in, jn)).^2);
        d_sorted = sort(d);
        d_kn = d_sorted(kn);   
        Vn = pi * (d_kn)^2;
        Pn_knn(jn, in) = (kn / n) / Vn;
    end
end

% Draw the knn estimate (use mesh function)
figure, mesh(Pn_knn)
sum_knn = sum(sum(Pn_knn))


%% Parzen
% Construct a parzen window estimate using square kernel 
% (choose a suitable size)

Pn_parzen = zeros(gridx, gridy);
h = 1;
Vn = (2*h)^2;

% Euclidean Parzen (wrong)
for in = 1:gridx
    for jn = 1:gridy
        d = sqrt((R(:,1) - X1(in, jn)).^2 + (R(:,2) - X2(in, jn)).^2);
        d_n = d <= h;
        kn = sum(d_n);
        Pn_parzen(jn, in) = (kn / n) / Vn;
    end
end

figure, mesh(Pn_parzen)
sum_parzen1 = sum(sum(Pn_parzen))

% Manhattan Parzen, cubes (right)
for in = 1:gridx
    for jn = 1:gridy
        d1 = abs(R(:,1) - X1(in, jn));
        d2 = abs(R(:,2) - X2(in, jn));
        dn = ((d1/h)<1 & (d2/h)<1);
        kn = sum(dn);
        Pn_parzen(jn, in) = (kn / n) / Vn;
    end
end

% Draw the parzen estimate (use mesh function)
figure, mesh(Pn_parzen)
sum_parzen2 = sum(sum(Pn_parzen))


% Extra: Try different k values for the KNN estimate and/or use 
% different box size/kernel for the parzen estimation.


