%
% -- DFT function (self defined)
%     
%     typical call :
%       y = custom_dft(x)

function y = custom_dft(x) 

  % signal length
  n_seg = size(x, 1)
  N = size(x, 2)

  % init
  y = zeros(size(x));
  l = 1 : N;

  % determine all frequency coeffs y_k for all segments
  for seg = 1 : n_seg
    for k = 0 : N - 1
      y(seg, k + 1) = exp((-2 * pi * j) * (l * k / N)) * x(seg, :)';
    end  
  end

end