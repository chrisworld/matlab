
% --
% tips
% box plots -> boxplot() for cross-val scores
% use save function to store data .mat

t_len = 100;
fs = 256;
dt = 1/fs;

t = 0 : dt : t_len;

% --
% 4.1 generate an artificial SSVEP

% class 1 signal
f = [8 16];
A = [1 0.5];
s1 = A(1) * sin(2*pi*f(1)*t) + A(2) * sin(2*pi*f(2)*t);

% class 2 signal
f = [13 26];
A = [1 0.5];
s2 = A(1) * sin(2*pi*f(1)*t) + A(2) * sin(2*pi*f(2)*t);

% noise
v = 3 * randn(1, length(t));

% signals + noise -> measurements d
d1 = s1 + v;
d2 = s2 + v;
d = [d1; d2];
d_index = [1 2];

%{
for idx = 1:length(d_index)
    figure(0 + idx) 
    plot(t, d(idx, :))
    xlabel('Time [s]')
    ylabel('Amplitude')
end
%}

% SNR
p_s1 = sqrt(mean(s1 .* s1))
p_s2 = sqrt(mean(s2 .* s2))
p_v = sqrt(mean(v .* v))

snr_d1 = 10 * log(p_s1 / p_v)
snr_d2 = 10 * log(p_s2 / p_v)

% --
% 4.2 extract feature from artificial SSVEP

n_segment_time_len = 1;
n_segment = 1 / dt;












