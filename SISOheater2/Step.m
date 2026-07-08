%% El objetivo de este script es crear una señal escalón y ver como el 
%% sistema interactúa ante ella
close all
clear all

%% cargar librería
tclabULL

%% definición de variables
%% Inicializar valores
temperature =[] ; 
heat =[] ;
time =[] ;
time_end = 960;
T = 2;
figure(100)

%%bucle de trabajo 16 minutos
for k = 1:1:time_end/T
    t_ini = tic();

   %% valor del escalon = 0
if k <= 10
   aux = 0;
   h2(aux);
  
end
    %% valor del escalon = 50%
if k > 10
    aux = 50;
    h2(aux);
    
end

%% lectura de los valores de temperatura
heat(k)=aux;
time(k)=2*k-T;
temperature(k)=T2C();


   %% mostrar resultados en cada interacción
    subplot(2,1,1)
    plot(time,temperature);
    xlabel('Time [s]');
    ylabel('Temperature [ºC]')
    grid on
    hold on

    subplot(2,1,2)
    plot(time,heat);
    xlabel('Time [s]');
    ylabel('Input [%]')
    grid on
    hold on
    elapsed_time = toc(t_ini);
    pause(T - elapsed_time); % Sleep for T s


end

%% apagar el heater
h2(0);


%% guardar respuesta en StepRespone.mat
save StepResponse temperature heat time
