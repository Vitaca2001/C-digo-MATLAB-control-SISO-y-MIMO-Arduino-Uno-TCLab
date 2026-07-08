% El objetivo de este script es realizar el control de temperatura en una
% tclab mediante un controlador PI y un predictor de Smith

close all
clear all



%% cargar librería
tclabULL;

%% Parámetros de el controlador
Kp = 7.3; 
Ti = 75;  
Ts = 2;

%% Setpoint
setpoint =30 ;

%% Inicializar variables
nIter = 480; % 960s

e = []; % Error
u = []; % señal de control
yp = []; %salida del sistema modelado con retardo
ep= []; %error de medida
ya=[]; % salida smith
time = []; % Tiempo
ym=[]; %salida del sistema modelado sin retardo
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
for k = 1:1:nIter
  t_ini = tic();
    
    % Salida de un sistema
    temp(k)= T2C();
    if k <= 4
      yp(k)=0;
      
    end
    % sistema con retardo
    if k > 4
      
     yp(k)=0.9868*yp(k-1) + 0.007545*u(k-4);

    end
    % Sistema sin retardo
    if k == 1
      ym(k)=0;
      
    end
    if k > 1
      
     ym(k)=0.9868*ym(k-1) +0.007545*u(k-1);

    end

     % Control  de error
    
    ep(k)=temp(k)-yp(k);
    ya(k)=ep(k)+ym(k);
    e(k)=setpoint-ya(k);
    ea(k)=setpoint-T2C();


     if k==150||k==300
        T2C()
    end
   % Controlador PI capado a un máximo de u(k)=50
     if k >1
        u(k) = u(k-1)+ e(k-1)*(((Kp*Ts)/Ti)-Kp)+Kp*e(k) ;
        if u(k)>= 50 
            u(k)=50;   
            h2(50);
        end
        if u(k)< 50
           
            h2(u(k));
        end
        if u(k)< 0  
            u(k)=0;
            h2(0);
        end
     end
     if k==1
        u(k)=Kp*e(k);
         if u(k)>= 50 
            u(k)=50;   
            h2(50);
         end
         if u(k)< 0  
            u(k)=0;
            h2(0);
         end
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
    plot(time,temp);
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
    pause(Ts - elapsed_time); % Sleep for T s

end

% apagar heater
h2(0)

save ControlSmithNoPertEstablecimiento itae iae itse ise ea
save ControlSmithNoPertConsigna itae1 iae1 itse1 ise1 ea