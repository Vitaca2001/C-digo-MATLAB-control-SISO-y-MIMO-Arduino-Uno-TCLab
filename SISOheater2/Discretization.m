% El objetivo del script es discretizar la función de transferencia de
% pimer orden

clear all
close all

%% Cargar respuesta escalón real
load StepResponse

%% Cargar sistema identificado
load IdentifiedSystem

%% discretización del sistema
% Usando ZoH
Ts =2;
sysd = c2d(sys,Ts,'zoh')
sysdmodel=c2d(sysmodel,Ts,'zoh')

%% Comparar tiempo continuo vs tiempo discreto
% Tiempo continuo
[ysim, tsim] = lsim(sys, heat,time);
figure(1)
%plot(time,ysim );
hold on
grid on


% Tiempo discreto
[ydsim, tdsim] = lsim(sysd,heat ,time);
ydsim=ydsim+23.74;
stairs( time,ydsim);
hold on
grid on
%% Obtain the discrete temporal expression from G(z)
% 
%                            Y(k)
%                  G(z) = --------------- 
%                            U(k)
%
%                       Y(k)=U(k)*G(Z)
%
%                                
%               Y(k)*(z-0.9888)=0.006474*u(k)*z^-3 
%
%               Y(k+1)-0.9888*Y(k)=0.006474*u(k-3)
%
%               Y(k+1)=0.006474*u(k-3)+0.9888*Y(k)
%
%               Y(k)=0.006474*u(k-4)+0.9888*Y(k-1) expresión con retardo
%               
%               Y(k)=0.006474*u(k-1)+0.9888*Y(k-1) expresión sin retardo
%




%% inicializar valores
nIter = 480; % Same than measured response
y = []; % Initialization of the output
u = [];

%% bucle de trabajo
for k = 1:1:nIter

    % valores en retardo
    if k == 1
        yd(k)=0;
        u(k)=0;
    end
    if k <= 4
      y(k)=0;
      u(k)=0;
    end
    % valores de la función discreta
    if k > 4
      u(k)=heat(k);
      y(k)=0.9868*y(k-1) + 0.007545*u(k-4);

    end
    if k > 1
      yd(k)=0.9868*yd(k-1) +0.007545*u(k-1);
    end


end

%% mostrar valores.
y=y+23.74;
plot(time,y)
 xlabel('Time [s]');
 ylabel('Temperature [ºC]')
hold on
grid on
%plot(time,yd)


