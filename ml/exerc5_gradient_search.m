%Perceptron gradient search
close all
clear all
clc

% two sets of data representing logical ports (OR and XOR)
% x OR y
data = [0 0 0; 0 1 1; 1 0 1; 1 1 1];

% x XOR y
%data = [0 0 0; 0 1 1; 1 0 1; 1 1 0];

% Classes
C = data(:,3);

%Features
X = data(:,1:2);

% Plot data
figure, plot(X(C == 1,1),X(C == 1,2), 'kx');
hold
plot(X(C == 0,1),X(C == 0,2), 'ko');
set(gca,'XLim',[-1 2]);
set(gca,'YLim',[-1 2]);

%Use the OR port and construct a linear perceptron to learn the data.

% Initialize a normal vector 
dist_from_origin = -0.5;
direction_x = 1;
direction_y = -1.2;

% initial guess
a = [dist_from_origin direction_x direction_y]';
a(2:3) = a(2:3)/norm(a(2:3));

% Draw the corresponding decision boundary
offset = a(1)*a(2:3);
linex = -a(3) * [-10:0.1:10]' - offset(1);
liney = a(2) * [-10:0.1:10]' - offset(2);
lineh = plot(linex, liney);

%%
% Perceptron gradient search algorithm (batch version)
Y = [ones(length(C), 1) X];
Y2 = Y;
% Invert, change the signs for class 2
Y2(C == 1, :) = Y2(C == 1, :) .* -1;

% optimal
%b = ones(4, 1)
%a = inv(Y2'*Y2) * Y2'*b

% Initialize parameters:
omega = 0; % end condition
step = 0.2; % learning parameter
threshold = 9999; % initial threshold
k = 1;

% Search until suitable solution (use e.g. a while loop)
while threshold > omega
    % calculate projections, when we dont have yet the solution
    % and some samples are still missclassified, then for those samples
    % a*y_i<0 and when we have found the solution all a*y_i>0
    Z = Y2*a;
    
    % Adjust according to the sum of negative projections
    adjust = step * sum(Y2(Z<=0,:), 1)';
    a = a + adjust
    a(2:3) = a(2:3)/norm(a(2:3));
    
    % calculate new threshold
    threshold = sum(norm(adjust));
    k = k + 1;
    
    % update decision boundary
    pause(0.25)
    delete(lineh)
    offset = a(1)*a(2:3);
    linex = -a(3) * [-10:0.1:10]' - offset(1);
    liney = a(2) * [-10:0.1:10]' - offset(2);
    lineh = plot(linex, liney); 
end

% How to modify the code for variable learning speed and marginal?

% Try to solve the XOR port data.
