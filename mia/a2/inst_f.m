% --
% Instantaneous Frequency
% 
% usage: [f_i] = parabol_interp(Xbuff, p, s, R, N)
%
function f_i = inst_f(Xbuff, p, s, R, N, fs)

  phi = angle(Xbuff(p, :));
  
  omega_k = 2 * pi * (p - 1) / N;
  delta_phi = omega_k * R - princarg(phi(s+1) - phi(s) - omega_k * R);

  % instantaneous frequency at the next frame  
  f_i = delta_phi / (2 * pi * R) * fs;
  
end
