N = 100;
x = [zeros(1, N/4), ones(1, N/2), zeros(1, N/4)];
h = [zeros(1, N/4), ones(1, N/2), zeros(1, N/4)];

%y = conv(x, h);

for ii = 1 : 1 : 10
	y = conv(x, h);
	x = y;
end

figure 1
plot(y)
grid on