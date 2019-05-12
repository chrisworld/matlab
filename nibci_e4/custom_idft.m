%
% -- IDFT function (self defined)
%     
%     typical call :
%       y = custom_idft(x)

function y = custom_idft(x)

  % input care
  x = x(:);

  % signal length and init
  N = length(x);
  y = zeros(N, 1);
  l = 1 : N;

  % determine all time coeffs y_k
  % time for N = 10k: 8.0436s > better
  for k = 1 : N
    y(k) = exp((2 * pi * j) * (l * k / N)) * x(l) / N;
  end 

  % beloved one-liner is too slow
  % time for N = 10k: 9.09277s -> can maybe improved a bit
  %k = 1 : N;
  %y = exp((2 * pi * j) * (l' * k / N)) * x / N; 

end