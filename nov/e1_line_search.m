clear all
close all
clc

x = 0 : 0.01 : 5;
fx = @(x) sin(x) - sin(10/3 * x);

%figure
%plot(x, fx)

% starting point
x0 = 0

% step size
s = 0.01

a = x0
b = x0 + s

% change direction
%if fx(b) > fx(a)
%    b = x0 - s;
%end

% eval positions
fa = fx(a);
fb = fx(b);

if fb > fa
    disp('no min in this dir')
end

% step size factor
k = 2

stop = 0;
% line search
while stop == 0
    
    % step
    c = b + s
    fc = fx(c);
    
    % brackets found
    if fc > fb
        disp('brackets found')
        b = c;
        fb = fc;
        stop = 1;
    
    % brackets not found
    else
        if s > 100
            stop = 1;
        end
        
        disp('no brackets')
        a = b;
        b = c;
        fa = fb;
        fb = fc;
        s = s * k;
        %b = b + s
    end
end

% print brackets
figure
plot(x, fx(x))
xlim([a, b])

% --
% sectioning

gold = (1 + sqrt(5)) / 2

% sectioning process
while abs(b - a) > 1e-3
    
    s_sec = (gold - 1) * (b - a);
    c = b - s_sec;
    d = a + s_sec;
    
    % new section
    disp('new section')
    a = c;
    b = d;
end

