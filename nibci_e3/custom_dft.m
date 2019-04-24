%
% -- DFT function (self defined)
%     
%     typical call :
%       y = custom_dft(x)

function y = custom_dft(x) 

  % input care
  x = x(:);

  % signal length and init
  N = length(x);
  y = zeros(N, 1);
  l = 1 : N;

  % determine all frequency coeffs y_k
  % time for N = 10k: 8.49617s -> better
  for k = 1 : N
    y(k) = exp((-2 * pi * j) * (l * k / N)) * x;
  end  

  % beloved one-liner is too slow
  % time for N = 10k: 9.27046s -> can maybe improved a bit
  %k = 1 : N;
  %y = exp((-2 * pi * j) * (l' * k / N)) * x;

end