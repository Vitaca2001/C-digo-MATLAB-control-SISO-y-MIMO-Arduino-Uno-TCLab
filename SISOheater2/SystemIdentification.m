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

i=2;
l=0;
while i<480

    l = l + temperature(i);
    i=i+2;
end


i=2
%% Definir parámetros de la función de tranferencia
kp = (51.2885-temperature(1))/heat(11); % [ºC/%]

while temperature(i)<((temperature(480)-temperature(1))*0.632)+temperature(1)

    i=i+2;
end
tau = 150; % [s] 
delay = 24-18; % [s]

% mostrar sistema con retardo
sys = tf( kp,[tau, 1] ,'OutputDelay',delay)

% mostrar sistema sin retardo
sysmodel= tf( kp,[tau, 1] )

%% Comparar valores reales con función de tranferencia
% respuesta del modelo ante la entrada escalon
[ysim,tsim] = lsim(sys,heat,time );
[ysimmodel,tsimmodel] = lsim(sysmodel,heat,time );

% Adaptar función de transferencia a la temperatura ambiente
ysim=ysim+22.8;
ysimmodel=ysimmodel+22.8;
% Mostrar valores reales vs los modelados
  figure(1)

    plot(time,temperature);
     xlabel('Time [s]');
    ylabel('Temperature [ºC]')
    grid on
    hold on

    
    plot(tsim,ysim);
   
    grid on
    hold on
   
   % plot(tsimmodel,ysimmodel);
   
    grid on
    hold on

    
%% Guardar sistema identificado

save IdentifiedSystem sys sysmodel kp tau

