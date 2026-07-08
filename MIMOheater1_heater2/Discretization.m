
% El objetivo del script es discretizar la función de transferencia de
% pimer orden


clear all
close all

%% Cargar respuesta escalón real
load StepResponse11
load StepResponse22

%% Cargar sistema identificado
load IdentifiedSystem

%% Cargar desacoplador
load interacciones
%% discretización del sistema
% Usando ZoH
D12=D(1,2);
D21=D(2,1);

Ts =2;
sysd11 = c2d(sys11,Ts,'zoh')
sysd12 = c2d(sys12,Ts,'zoh')
sysd21 = c2d(sys21,Ts,'zoh')
sysd22 = c2d(sys22,Ts,'zoh')

desad12=c2d(D12,Ts,'zoh')
desad21=c2d(D21,Ts,'zoh')

sysdmodel11=c2d(sys11p,Ts,'zoh');
sysdmodel12=c2d(sys12p,Ts,'zoh');
sysdmodel21=c2d(sys21p,Ts,'zoh');
sysdmodel22=c2d(sys22p,Ts,'zoh');

%% Comparar tiempo continuo vs tiempo discreto
% Tiempo continuo
[ysim11, tsim11] = lsim(sys11, heat,time);
[ydsim11, tdsim11] = lsim(sysd11,heat ,time);
[ysim12, tsim12] = lsim(sys12, heat,time);
[ydsim12, tdsim12] = lsim(sysd12,heat ,time);
[ysim21, tsim21] = lsim(sys21, heat,time);
[ydsim21, tdsim21] = lsim(sysd21,heat ,time);
[ysim22, tsim22] = lsim(sys22, heat,time);
[ydsim22, tdsim22] = lsim(sysd22,heat ,time);



%% obtener exoresión temporal discreta
% 
%                            Y(k)
%                  G(z) = --------------- 
%                            U(k)
%
%                       Y(k)=U(k)*G(Z)
%
%                                
%               Y(k)*(z-0.988)=0.00737*u(k)*z^-3 
%
%               Y(k+1)-0.988Y(k)=0.00737*u(k-3)
%
%               Y(k+1)=0.00737*u(k-3)+0.988*Y(k)
%
%               Y(k)=0.00737*u(k-4)+0.988*Y(k-1) expresión con retardo
%               
%               Y(k)=0.00737*u(k-1)+0.988*Y(k-1) expresión sin retardo
%



%% inicializar valores
nIter = 480; 
y = []; 
u = [];
yd =[];

%% bucles de trabajo
% G11
for k = 1:1:nIter
    
    if k <= 4
      y11(k)=0;
      u(k)=0;
    end
    
    if k > 4
      u(k)=heat(k);
      y11(k)=0.9868*y11(k-1) + 0.008274*u(k-4);

    end


end

% G12
for k = 1:1:nIter
    
    if k <= 10
      y12(k)=0;
      u(k)=0;
    end
    
    if k > 10
      u(k)=heat(k);
      y12(k)=0.9917*y12(k-1) + 0.002013*u(k-10);

    end


end

% G21
for k = 1:1:nIter
    
    if k <= 17
      y21(k)=0;
      u(k)=0;
    end
    
    if k > 17
      u(k)=heat(k);
      y21(k)=0.9917*y21(k-1) + 0.002176*u(k-17);

    end


end

% G22
for k = 1:1:nIter
    
    if k <= 4
      y22(k)=0;
      u(k)=0;
    end
    
    if k > 4
      u(k)=heat(k);
      y22(k)=0.9868*y22(k-1) + 0.007415*u(k-4);

    end


end
%% mostrar valores.
subplot(2,2,1)
plot(time,ysim11);
hold on
title('G11(Z)');
xlabel('Time [s]');
ylabel('Temperature [ºC]')
grid on
hold on
% Tiempo discreto
stairs( time,ydsim11);
hold on
grid on

subplot(2,2,2)
plot(time,ysim12);
hold on
title('G12(Z)');
xlabel('Time [s]');
ylabel('Temperature [ºC]')
grid on
hold on
% Tiempo discreto
stairs( time,ydsim12);
hold on
grid on

subplot(2,2,3)
plot(time,ysim21);
hold on
title('G21(Z)');
xlabel('Time [s]');
ylabel('Temperature [ºC]')
grid on
hold on
% Tiempo discreto
stairs( time,ydsim21);
hold on
grid on

subplot(2,2,4)
plot(time,ysim22);
hold on
title('G22(Z)');
xlabel('Time [s]');
ylabel('Temperature [ºC]')
grid on
hold on
% Tiempo discreto
stairs( time,ydsim22);
hold on
grid on