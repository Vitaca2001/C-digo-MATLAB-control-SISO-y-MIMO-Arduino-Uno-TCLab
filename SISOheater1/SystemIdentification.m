
% El objetivo es identificar la respuesta del proceso ante una entrada 
% escalon y plantear una función de transfereancia de primer orden con 
% forma:                      Kp
%                  G = --------------- exp(-tm ·s)
%                        tau · s + 1
% La función de transferenciaempieza en 0 pero el proceso real en
% temperatura ambiente.


clear all
close all

%% Cargar respuesta escalón real
load StepResponse

%% Mostrar valores reales para identificar función

plot(time,temperature)



%% Definir parámetros de la función de tranferencia
kp = (temperature(480)-temperature(1))/heat(20); % [ºC/%]

i=2;
x=((temperature(480)-temperature(1))*0.632)+temperature(1);
while temperature(i) < ((temperature(480)-temperature(1))*0.632)+temperature(1)
    i = i+2;
end
tau = 150; % [s] 

delay = 6; % [s]

% mostrar sistema con retardo
sys = tf( kp,[tau, 1] ,'OutputDelay',delay)

% mostrar sistema sin retardo
sysmodel= tf( kp,[tau, 1] )

%% Comparar valores reales con función de tranferencia
[ysim,tsim] = lsim(sys,heat,time );
[ysimmodel,tsimmodel] = lsim(sysmodel,heat,time );

% Adaptar función de transferencia a la temperatura ambiente
ysim=ysim+23.74;
ysimmodel=ysimmodel+23.74;
% Mostrar valores reales vs los modelados
  
    figure (1)

    plot(time,temperature);
    xlabel('Tiempo [s]');
    ylabel('Temperatura [ºC]')
    grid on
    hold on

    
    plot(tsim,ysim);
   
    grid on
    hold on

    %%plot(tsimmodel,ysimmodel);
   
    grid on
    hold on


    figure(2)

    [mag,phase,wout] = bode(sys);
    bode(sys);
    hold on
    yline(-180,'-','inestable');

    grid on
    axis tight

%% Guardar sistema identificado
save IdentifiedSystem sys tsim ysim sysmodel
