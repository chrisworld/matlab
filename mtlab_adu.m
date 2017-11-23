% ADU Flash

U_ideal = [-2.344, -2.031, -1.719, -1.406, -1.094, -0.781, -0.469, -0.156, 0.156, 0.469, 0.781, 1.094, 1.406, 1.719, 2.031];
U_real = 	[-2.458, -2.406, -1.719, -1.406, -1.094, -0.781, -0.469, -0.156, 0.156, 0.469, 0.781, 1.094, 1.406, 1.719, 2.031];
%	U_real = 	[];

% calculated
U_diff = U_real - U_ideal

% put BEWF
neg_BEWF = -0.114;
pos_BEWF = 0.309;
ii = 0 : 1 : 14;

% correct
U_korr = U_real - (14-ii)/14 * neg_BEWF - ii/14 * pos_BEWF

% step width
for s = 1 : 1 : 13
	Us_real(s) = U_korr(s+1) - U_korr(s);
end
Us_real

Us_ideal = ones(1, 13) * 0.313;
Us_diff = Us_real - Us_ideal

% step middle point
Usm_real = U_korr + 0.5*Us_real

Usm_ideal = [-2.188, -1.875, -1.563, -1.250, -0.938, -0.625, -0.313, 0, 0.313, 0.625, 0.938, 1.250, 1.563, 1.875];
Usm_diff = Usm_real - Usm_ideal 

