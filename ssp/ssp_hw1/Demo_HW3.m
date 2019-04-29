% Statistical Signal Processing 
%
%  Demo code for source localization
%
%  This demo file is the exact implementation used in 
%  
%  [S,t] = func_soundlocalization(XYmic,ID)  (see below)
%
%
%  
%
% Neumayer 2015
clear all, close all, clc

% Microphone positions [x y] in meter
XYmic = [100,45;...
         -75 75;...
         60 -60];

%Position of Sound Source
PS = [-60 30];


figure, hold on, set(gca,'FontSize',26),set(gcf,'Color','White');  
plot(PS(:,1),PS(:,2),'or','LineWidth',2)
plot(XYmic(:,1),XYmic(:,2),'ok','LineWidth',2)
TMP = 100*exp(1i*linspace(0,2*pi));
plot(real(TMP),imag(TMP),'--k','LineWidth',1)
axis(120*[-1 1 -1 1 ])
grid on
axis equal
xlabel('x (m)')
ylabel('y (m)')
legend('Source','Microphone') 
title('Geometry')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Time of Flight computation

c = 343;%  Speed of Sound

vd = XYmic - repmat(PS,size(XYmic,1),1);
d = sqrt(sum(vd.^2,2));
toF = d/c;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Signal Generation
 
 
f_S = 20E3; % Sampling Frequency

% Signal Pattern
u   = @(t) 0.5*(sign(t) + 1);
sig = @(t) sin(2*pi*500*t).*exp(-t/0.01).*u(t);

% Generation of time signals
t = -(1000+floor(1000*rand))/f_S:1/f_S:max(toF)*1.5 + 1000/f_S; t = t(:);
S = zeros(length(t),size(toF,1));
 for ii = 1:length(toF)
 
   S(:,ii) = sig(t-toF(ii));
   
 end
t = t-t(1);
%Noise
S = S+0.1*randn(size(S));
 
figure, hold on, set(gca,'FontSize',26),set(gcf,'Color','White');  
plot(t,S,'LineWidth',2)
xlabel('t (s)')
ylabel('d (1)')
grid on
title('Signals')
legend('Mic 1: t_1','Mic 2: t_2','Mic 3: t_3')
axis tight

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[S2,t2] = func_soundlocalization(XYmic,6);

figure, hold on, set(gca,'FontSize',26),set(gcf,'Color','White');  
plot(t2,S2,'LineWidth',2)
xlabel('t (s)')
ylabel('d (1)')
grid on
title('Signals')
legend('Mic 1: t_1','Mic 2: t_2','Mic 3: t_3')
axis tight
