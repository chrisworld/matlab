% ================================
% Athor:    Christian walter
% Problem:  Uebung_0
% ================================

clear all;

% Messwerte
Ur = [0.0 2.31 4.67 7.10 9.44];
Ia = [0.0 42.1 64.2 82.5 98.0];
R = Ur./Ia


% Ausgleichsgerade R(Polynom 1.Ordnung)

p = polyfit(Ia, Ur, 2);
fextrap = (10:0.5:150);
finterp = (42.1:0.5:98.0);    % Stützstellen für Ausgleichskurve
R_extrap = polyval(p, fextrap);
R_interp = polyval(p, finterp);


% --- Figure
figure(1)
hold on

plot(Ia,Ur,'b*','LineWidth',1)       % Messwerte ()
%plot(Ia,Ur)
plot(finterp, R_interp,  'g')
plot(fextrap, R_extrap, 'g--')

xlabel('Ia / mA')
ylabel('Ur / V')
