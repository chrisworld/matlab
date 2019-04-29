T = 2;
N = 1024;
x = [zeros(1, N/4), ones(1, N/2), zeros(1, N/4)];
h = [zeros(1, N/4), ones(1, N/2), zeros(1, N/4)];

s = 2*T/N;
t_axis = -N/2*s : s : N/2*s - s;

figure 1
plot(t_axis, x)
title('signal x(t) and h(t) with periode T = 2s')
ylabel('x(t)')
xlabel('time in seconds')
ylim([0, 1.2])
grid on
print('fdc_signal','-dpng')

for ii = 1 : 1 : 3
	y = conv(x, h) * s;
	x = y;
	N = size(y, 2);
	t_axis = -N/2*s : s : N/2*s - s;
end

figure 2
plot(t_axis, y)
title('Convolution 2-times: y2(t) =  y(t)*h(t)')
ylabel('y2(t)')
xlabel('time in seconds')
grid on
print('fdc_conv2','-dpng')

%close all