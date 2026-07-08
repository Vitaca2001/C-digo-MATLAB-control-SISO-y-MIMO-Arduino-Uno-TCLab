

% El objetivo de este script es realizar el control de temperatura en una
% tclab mediante un controlador PI

close all

clear all


%% cargar librería
tclabULL;

%% Parámetros de el controlador

Kp = 7.3; 
Ti = 75;  
Ts = 2;


%% Consigna de temperatura ºC
setpoint =30 ;

%% Inicializar variables
nIter = 480; % 960s

e = []; % Error
u = []; % señal de control
y = []; % Medida
time = []; % Tiempo
%ponderación error establecimiento
ise=0;
itse=0;
iae=0;
itae=0;
%ponderación error en consigna
ise1=0;
itse1=0;
iae1=0;
itae1=0;

%% bucle de trabajo 16 min

for k = 1:1:nIter
    t_ini = tic();
    
    % Salida del sistema
    y(k)= T1C();

    % error de medida
    
    e(k) = setpoint-y(k);
       if k==150||k==300
       
       T1C()
       end

    % Controlador PI forward discreto  

     if k >1
      u(k) = u(k-1)+ e(k-1)*(((Kp*Ts)/Ti)-Kp)+Kp*e(k) ;
   
     end
     % Controlador PI forward discreto en el momento inicial

     if k==1
        u(k)=Kp*e(k);
         
     end

      if k>=150||k<300
       
       T1C()
       end
     
     if u(k)>= 50 
        u(k)= 50;
        h1(50);
     end
     if u(k)< 50    
        h1(u(k));
     end  
    if u(k)< 0
        u(k)=0;
        h1(0);
     end  
   % Ponderación de errores
     if k<=150
        
        ise=ise+e(k)^2;
        itse=itse+k*e(k)^2;
        iae= iae+ abs(e(k));
        itae=itae+ k*abs(e(k));

     end
     if k>150
        ise1=ise1+e(k)^2;
        itse1=itse1+k*e(k)^2;
        iae1= iae1+ abs(e(k));
        itae1=itae1+ k*abs(e(k));

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

%save RealControlLoopNoPertEstablecimiento itae iae itse ise e
%save RealControlLoopNoPertConsigna itae1 iae1 itse1 ise1 e