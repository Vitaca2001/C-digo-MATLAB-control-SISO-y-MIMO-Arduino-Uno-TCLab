% El objetivo de este script es realizar simulación del control de 
% temperatura en una tclab mediante un controlador PI y un predictor de Smith

close all
clear all





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

for k = 1:1:nIter
  
    
    % Salida de un sistema
   
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
    yl(k)=yp(k)+23.74;
    
    ya(k)=ym(k)+23.74;
    e(k)=setpoint-ya(k);
   


     
   % Controlador PI capado a un máximo de u(k)=50
     if k >1
        u(k) = u(k-1)+ e(k-1)*(((Kp*Ts)/Ti)-Kp)+Kp*e(k) ;
     end
     if k==1
        u(k)=Kp*e(k);
         
     end
    
   
    time(k)=2*k-Ts;

   

     end

subplot(2,1,1)
plot(time,yl)
hold on
xlabel('Tiempo [s]');
ylabel('Temperatura [ºC]')
grid on
axis tight
subplot(2,1,2)
plot(time,u)
xlabel('Tiempo [s]');
ylabel('Entrada [%]')
grid on
axis tight
