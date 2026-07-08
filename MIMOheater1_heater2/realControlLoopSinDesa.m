
%
% El objetivo de este script es programar una simulción de un controlador
% PI con dos desacopladores para un sistema mimo 
% 

clear all
close all

%% Load TCLab file
tclabULL

%% Parámetros de el controlador
% considerar valores PI forward
Kp1 =7.3; 
Ti = 75;   
Ts = 2;
Kp2 =6.3;

%% Consigna de temperatura ºC
setpoint1 = 32;
setpoint2 = 30;
%% Inicializar variables
% Temperatura ambiente


% líneas de error
errorabs=0.02;
errorsup=[];
errorinf=[];


 
e = []; 
u = []; 


nIter = 480; 

time = [];

%% bucle de trabajo
for k = 1:1:nIter
  t_ini = tic();
  ypreal1(k) = T1C() ;
  ypreal2(k) = T2C();
  % error de consigna

  e1(k) = setpoint1-ypreal1(k) ;
  e2(k) = setpoint2-ypreal2(k) ;

   
  if k >1
      % controladores
      u1(k) = u1(k-1)+ e1(k-1)*(((Kp1*Ts)/Ti)-Kp1)+Kp1*e1(k) ;
      u2(k) = u2(k-1)+ e2(k-1)*(((Kp2*Ts)/Ti)-Kp2)+Kp2*e2(k) ;
      % desacopladores
      yd12(k)=0.9917*yd12(k-1)-0.2427 *u2(k)+0.2395*u2(k-1);
      yd21(k)=0.9917*yd21(k-1)-0.2927 *u1(k)+0.2888*u1(k-1);
 end
 
  if k==1
      % Controlador PI forward discreto en el momento inicial
      u1(k)=Kp1*e1(k);
      u2(k)=Kp2*e2(k);
      % desacopladores discreto en el momento inicial
      yd12(k)=-0.2518 *u2(k);
      yd21(k)=-0.2892 *u1(k);
  end


 u1s(k)= u1(k)+0;
 u2s(k)= u2(k)+0;

    if u1s(k)>= 50 
        u1s(k)= 50;
        h1(50);
     end
     if u1s(k)< 50    
        h1(u1s(k));
     end  
     if u1s(k)< 0 
        u1s(k)=0;
        h1(0);
     end  
     if u2s(k)>= 50 
        u2s(k)= 50;
        h2(50);
     end
     if u2s(k)< 50    
        h2(u2s(k));
     end  
     if u2s(k)< 0 
        u2s(k)=0;
        h2(0);
     end  
   time(k)=2*k-Ts;
    
    % mostrar valores
    subplot(2,2,1)
    plot(time,ypreal1);
    xlabel('Time [s]');
    ylabel('Temperature [ºC]')
    grid on
    hold on

    subplot(2,2,2)
    plot(time,ypreal2);
    xlabel('Time [s]');
    ylabel('Temperature [ºC]')
    grid on
    hold on
    %plot de la entrada
    subplot(2,2,3)
    plot(time,u1s)
    xlabel('Time [s]');
    ylabel('Input [%]')
    hold on
    grid on

    subplot(2,2,4)
    plot(time,u2s)
    xlabel('Time [s]');
    ylabel('Input [%]')
    hold on
    grid on

    elapsed_time = toc(t_ini);
    pause(Ts - elapsed_time); 

end

% apagar heater
h1(0);
h2(0);
