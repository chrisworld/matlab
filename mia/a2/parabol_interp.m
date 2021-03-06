% --
% parabol interpolation
% 
% usage: [_alpha, _beta, _gamma, _k] = parabol_interp(X, p)
%
function [_alpha, _beta, _gamma, _k] = parabol_interp(X, p)

  % gamma
  _gamma = 0.5 * (X(p-1) - X(p+1)) / (X(p-1) - 2 * X(p) + X(p+1));
  
  % lin
  %_gamma = 0.5 * (abs(X(p-1)) - abs(X(p+1))) / (abs(X(p-1)) - 2 * abs(X(p)) + abs(X(p+1)));

  % middle point
  _k = p - 1 + _gamma;

  % correction
  _alpha = (X(p-1) - X(p)) / ( 1 + 2 * _gamma);
  _beta = X(p) - _alpha * _gamma^2;

end