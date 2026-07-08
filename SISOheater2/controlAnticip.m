

% El objetivo de este script es realizar el control de temperatura en una
% tclab mediante un controlador anticipativo

close all

clear all


%% cargar librería
tclabULL;

%% Parámetros de el controlador

Kp = 7.3; 
Ti = 75;  
Ts = 2;
ku=tf([0.5696*220, 0.5696],1);
kq=tf([0.2191*150, 0.2191],1);

%% Consigna de temperatura ºC
setpoint =30 ;

%% Inicializar variables
nIter = 480; % 960s

e = []; % Error
u = []; % señal de control
y = []; % Medida
time = []; % Tiempo

%% bucle de trabajo 16 min

for k = 1:1:nIter
    t_ini = tic();
    
    % Salida del sistema
    y(k)= T2C();

    % error de medida
    
    e(k) = setpoint-y(k);

      


% perturbación
     if k>=150
       u2(k)=25;
       h1(u2(k));
       up(k)=(0.2623*u2(k)-0.2588*u2(k-1)+0.991*up(k-1));
     end
     % fin de perturbación
     if k>=300 || k<150
       u2(k)=0;
       h1(u2(k));
       up(k)=0;
       if k==1
        up(k)=0;
       end
     end
   % Controlador PI forward discreto en el momento inicial
  
     if k==1
        ur(k)=Kp*e(k); 
       
     end

     % Controlador PI forward discreto 
  
     if k >1
      ur(k) = ur(k-1)+ e(k-1)*(((Kp*Ts)/Ti)-Kp)+Kp*e(k) ;
     end

     if ur(k)< 0
        ur(k)= 0;
     end  
   
     
     
     u(k)= ur(k)-up(k);

     if u(k)>= 50 
        u(k)= 50;
        h2(50);
     end
     if u(k)< 50    
        h2(u(k));
     end  
    if u(k)< 0
        u(k)= 0;
        h2(0);
     end  
   
    time(k)=2*k-Ts;

    % mostrar valores
    subplot(2,1,1)
    plot(time,y);
    xlabel('Time [s]');
    ylabel('Temperature [ºC]')
    grid on
    hold on
    %plot de la entrada
    subplot(2,1,2)
    plot(time,u)
    xlabel('Time [s]');
    ylabel('Input [%]')
    hold on
    grid on

    elapsed_time = toc(t_ini);
    pause(Ts - elapsed_time); 
end

% apagar heater
h1(0)
h2(0)

ise=0;
itse=0;
iae=0;
itae=0;

for k=1:1:nIter
ise=ise+e(k)^2;
itse=itse+k*e(k)^2;
iae= iae+ abs(e(k));
itae=itae+ k*abs(e(k));
end

save controlAnticip itae iae itse ise e