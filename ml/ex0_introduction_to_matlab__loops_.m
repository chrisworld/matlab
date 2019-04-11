function [t1, t2, t3]=looping(r) % This function has on input and three outputs
%% Loops are discouraged in Matlab. Especially old versions are bad at
%%optimizing code with loops
% Call the function e.g. [t1, t2, t3]=looping(1000000);

r1 = rand(r, 1);
r2 = rand(r, 1);

% In the following we want to do element-wise multiplication of the two
% vectors r1 and r2
% However, in this example we are not interested in the answer of the
% multiplication but processing times with loops vs. vectorizations.

% Let's try to use for-loops.
tic;
for in = 1:1:length(r1)
    for_out(in) = r1(in)*r2(in);
end
t1=toc % Tic-toc returns the time that the calculations took from tic to toc.

clear for_out % In this example we don't really need the output. 
%It's important to preallocate, i.e., initialize and allocate memory for an
%array
tic;
for_out = zeros(length(r1), 1); 
for in = 1:1:length(r1)
    for_out(in) = r1(in)*r2(in);
end
t2=toc

clear for_out
% and even more important to use vectorizations
tic;
for_out = r1.*r2;
t3=toc

% Here we see that vectorization is the fastest of all. In Matlab, it is
% important to vectorize where ever you can. It is not always possible but
% can save tremendous amount of time when it is possible.

%Matlab is pretty slow in processing stuff but it is great for
%visualizations and quick testing of algorithms which is why we are using it. 

end