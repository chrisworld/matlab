% --
% phase
function phase = princarg(phasein) 
  % phase => ]-pi,pi]
  phase = mod(phasein + pi, -2 * pi) + pi;
  % see DAFX Book, Zölzer, p.262
end