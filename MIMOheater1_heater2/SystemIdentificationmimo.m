
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
load StepResponse11
load StepResponse22


%% Definir parámetros de la función de tranferencia
kp11 = (temperature11(480)-temperature11(1))/heat(20); % [ºC/%]
kp12 = (temperature12(480)-temperature12(2))/heat(20); % [ºC/%]
kp21 = (temperature21(480)-temperature21(1))/heat(20); % [ºC/%]
kp21=0.2705;
kp22 = (temperature22(462)-temperature22(1))/heat(20); % [ºC/%]


i=2;


while temperature11(i) < ((temperature11(480)-temperature11(1))*0.632)+temperature11(1)
    i = i+2;
end
tau11 = 150; % [s] 
i=2;
while temperature12(i) < ((temperature12(480)-temperature12(1))*0.632)+temperature12(1)
    i = i+2;
end
tau12 = 240; % [s] 
i=2;
while temperature21(i) < ((temperature21(480)-temperature21(1))*0.632)+temperature21(1)
    i = i+2;
end
tau21 = 260; % [s] 
i=2;
while temperature22(i) < ((temperature22(480)-temperature22(1))*0.632)+temperature22(1)
    i = i+2;
end
tau22 = 150; % [s] 


delay11 = 24-18; % [s]
delay12 = 36-18; % [s]
delay21 = 50-18; % [s]
delay22 = 24-18; % [s]

% mostrar sistema con retardo
sys11 = tf( kp11,[tau11, 1] ,'OutputDelay',delay11)
sys12 = tf( kp12,[tau12, 1] ,'OutputDelay',delay12)
sys21 = tf( kp21,[tau21, 1] ,'OutputDelay',delay21)
sys22 = tf( kp22,[tau22, 1] ,'OutputDelay',delay22)

sys11p = tf( kp11,[tau11, 1]);
sys12p = tf( kp12,[tau12, 1]);
sys21p= tf( kp21,[tau21, 1]);
sys22p = tf( kp22,[tau22, 1]);

%% Comparar valores reales con función de tranferencia
[ysim11,tsim11] = lsim(sys11,heat,time );
[ysim12,tsim12] = lsim(sys12,heat,time );
[ysim21,tsim21] = lsim(sys21,heat,time );
[ysim22,tsim22] = lsim(sys22,heat,time );

% Adaptar función de transferencia a la temperatura ambiente
ysim11=ysim11+temperature11(1);
ysim12=ysim12+temperature12(2);
ysim21=ysim21+temperature21(1);
ysim22=ysim22+temperature22(1);

% Mostrar valores reales vs los modelados

    subplot(2,2,1)
    plot(time,temperature11);
    hold on
    plot(time,ysim11)
    title('G11(s)');
    xlabel('Time [s]');
    ylabel('Temperature [ºC]')
    grid on
    hold on
    
    subplot(2,2,2)
    plot(time,temperature12);
    hold on
    plot(time,ysim12)
    title('G12(s)');
    xlabel('Time [s]');
    ylabel('Temperature [ºC]')
    hold on
    grid on

    subplot(2,2,3)
    plot(time,temperature21);
    hold on
    plot(time,ysim21)
    title('G21(s)');
    xlabel('Time [s]');
    ylabel('Temperature [ºC]')
    grid on
    hold on
    
    subplot(2,2,4)
    plot(time,temperature22);
    hold on
    plot(time,ysim22)
    title('G22(s)');
    xlabel('Time [s]');
    ylabel('Temperature [ºC]')
    hold on
    grid on



   

  
%% Guardar sistema identificado
save IdentifiedSystem sys11 sys12 sys21 sys22 sys11p sys12p sys21p sys22p
