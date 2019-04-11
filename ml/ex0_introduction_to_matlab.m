%% Introduction to Matlab

%% Interpreted vectored language 
% - percentage is used for comments
% - block comments used to not exist but on the newest versions of Matlab
% (Matlab 7 R14) you can use: 
%{
  This is a block comment
%}

%% Variables and basic expressions

% Works like a calculator
1+2
2*2
2^3

% Complex numbers
sqrt(-1) %be careful of using 'i' as a variable name for indices. 
i
% However, if you're using i as a variable name, matlab moves to use j as
%complex number. If you use both i and j, you'll calculations might become
%wrong.

% You don't need to give type for new variables
a = 2 % Matlab just assumes all the numbers are doubles
b = 3.14
c = a + b
% You need to specify with e.g. unit8(.) or logical(.) that you want something
%else than double.

d='Hello world!' % Strings are made with single quotation marks. Using " will give an error.

% Output can be suppressed with semicolon
c = a*b;

%% Matrices, arrays and vectors

% Everything is a matrix
size(1) % size() function will return the size of the matrix
        % length() works for vectors but you need to be careful with it as
        % it returns the longest side of a matrix which might not be what
        % you want

% A row vector can be defined with
v = [1 2 3]
v =  1:1:3 %in this case you can also write v = 1:3

% A column vector
v'
v = [1; 2; 3]

% A Matrix is just vectors after vectors
m = [1 2 3; 4 5 6; 6 7 8]

% Initializing simple matrices
m = zeros(3,3)
m = ones(3,3)
m = eye(3,3) % I matrix

% Another handy function for creating matrices is 'repmat'
m = repmat(5,3,4)
m = repmat(1:9, 5, 1) % It just repeats matrix.

% And reshape
m = reshape(1:9, 3, 3)

% Transpose works on matrices too
m'

% Everything becomes a matrix operation
A = eye(3,3);
B = m;

C = A*B;
C = A+B;
C_inv = pinv(C); %pseudo inverse. Using ^-1 works too but it tries to create the real inverse of a matrix which might not be possible

% Element-wise operations are also possible just remember the dot
C = A.*B; % element-wise multiplication
C = A./B; % element-wise division

%% Accessing matrix elements
a = [1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16]
a(3:end, :)
a(15)
a(1,1)=16; % Be super careful with matlab indices: They start from 1. !!!!!!!!!!!!!!
diag(a)
b=a>7
a(b) % b is used here as a mask

%% Important functions
r = randn(500,1); % random number generator for normally distributed pseudorandom numbers
histogram(r) % In old Matlab versions you need to use hist command. It's nearly the same as histogram.

mean(r) % mean
std(r) % standard deviation
[val,ind] = max(abs(r)) % functions can output multiple variables
max(a) % this shows the maximum values on each column as a row vector
a==max(max(a)) % Here we want to know the maximum value of the matrix and that is why we need to caal max twice

disp('Hello world')

clear % clears the work space
clc % clears all the text from command window
close all % closes all the figures

%% NaN, Not-a-Number
c = [2 NaN 1000 432 54]
max(c) % this works fine
min(c) % this one too
mean(c) % now, that's probably not what we want

lookfor nan 
help nanmean 

nanmean(c) % This ignores the NaNs in the vector.

%% Matlab stuff

eye(3,3);
zeros(3,3);
ones(3,3);
repmat(5,3,4)
repmat(1:9, 5, 1)

c = [1,2,3;4,5,6]
%inv = pinv(c);
c(1,1) = 7
diag(c)
b = c>5
a = max(c)
c = [1, NaN, 1000, 2]'
max(c)
min(c)
nanmean(c)
mean(c)
a = 1:1:10
b = 1:1:10
for out = a.*b

histogram(r1)
mean_r1 = mean(r1)
std_r1 = std(r1)

%{
%% Simple example and plotting
% Let's create a harmonic signal x(t)=A*sin(2*pi*f*t+ph)
T = 2; % 2 seconds length
fs = 300; % 300 Hz
f = 10; % the frequency of oscillations is 30 Hz 
ph = 0;
A = 1;

% Array of time points
dt = 1/fs;
t = 0:dt:T; 

% The signal
x = A*sin(2*pi*f*t+ph);

% We can save figure handle so that we can access the figure later from
% code
fig_handle = figure;

plot(t, x);
title('Harmonic signal');
xlabel('Time [s]');
ylabel('Amplitude');

set(fig_handle,  'Position', [100, 100, 1000, 300]);

%Let's generate another signal with half frequency
% We will generate a second signal with twice smaller frequency
x2 = A*sin(2*pi*f/2*t+ph);

% and plot it to the same figure
hold on
plot(t, x2, 'r--');
hold off
%}






