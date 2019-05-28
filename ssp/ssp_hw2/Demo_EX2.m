% Statistical Signal Processing 
%
%  Demo code for source localization
%
%
%
%  
%
% Neumayer 2015
clear all, close all, clc

% Microphone positions [x y] in meter
XYmic = [100,45;...
         -75 75;...
         60 -60;...
         60 90];

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
%Time of Flight computation and time difference computation

c = 343;%  Speed of Sound

vd = XYmic - repmat(PS,size(XYmic,1),1);  
d = sqrt(sum(vd.^2,2));                             % Distances 
toF = d/c;                                          % Time of Flight

% Assemby matrix to measure differenc times
N_mic  = size(XYmic,1);
N_meas =  N_mic*(N_mic-1)/2;
M = zeros(N_meas,N_mic);
cnt = 1;
for ii = 1:N_mic-1    
    for jj =  ii+1:N_mic
     M(cnt,ii)   = 1;
     M(cnt,jj)   = -1;
     cnt = cnt+1;
    end    
end

dt = M*toF      % difference times


[dt] = func_soundlocalization_HW3(XYmic,5);


