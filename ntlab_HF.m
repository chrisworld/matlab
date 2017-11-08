% Kurzschluss
z = -5 : 0.5 : -15;
AdB = -37.1;
Z0 = 50

Pmax = -33.9;
Pmin = -66.7;

Pmax_lin = 10^(Pmax/10) * 0.001
Pmin_lin = 10^(Pmin/10) * 0.001

m = sqrt(Pmin_lin) / sqrt(Pmax_lin)

r0 = (1-m) / (1+m)

c = 3*10^8
f = 2.8*10^9

lam = c / f 

z0 = 9.05 * 10^(-2) 	%m 
l0 = z0 - (lam/2)

lam_drehn = l0 / lam

Z_dreh = (0.01 + i * 1.5) * Z0

% Leistung
%Alin = 10^(AdB/10) * 0.001

% Anpassung
% Abstand von min und max
z_max = 9.95 * 10^(-2)
z_min = 7.26 * 10^(-2)

Adb_min_A = -29.63 
Adb_max_A = -39.1
Adb_A = -39 - [.24 ,  .14 , .11 , .16, .29 , .47, .51, .54, .47, .34, .19, .08, .02]

% Kurzschluss
z_max = 8.97 * 10^(-2)
z_min = 6.33 * 10^(-2)

Adb_max_K = -33.22
Adb_min_K = -63
Adb_K = -[47.49, 52.88, 41.5, 37.14, 34.84, 33.62, 33.22, 33.61, 34.8, 37.13, 41.39, 52.75, 47.35, 39.71, 36.16, 34.19, 33.29, 33.16, 33.82]
