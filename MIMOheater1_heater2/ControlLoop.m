
%
% El objetivo de este script es programar una simulción de un controlador
% PI con dos desacopladores para un sistema mimo 
% 

clear all
close all



%% Parámetros de el controlador
% considerar valores PI forward
Kp1 =7.3; 
Ti = 75;   
Ts = 2;
Kp2 =7.3;

%% Consigna de temperatura ºC
setpoint1 = 32;
setpoint2 = 30;
%% Inicializar variables
% Temperatura ambiente
tamb=22.3;

% líneas de error
errorabs=0.02;
errorsup=[];
errorinf=[];

yp = [];
ypreal = []; 
e = []; 
u = []; 


nIter = 480; 

time = [0:Ts:(nIter-1)*Ts]; % Tiempo

%% bucle de trabajo
for k = 1:1:nIter
    
 %errorsup1(k)= setpoint1+(setpoint1-tamb)*errorabs;
% errorinf1(k)= setpoint1-(setpoint1-tamb)*errorabs;
 %errorsup2(k)= setpoint2+(setpoint2-tamb)*errorabs;
 %errorinf2(k)= setpoint2-(setpoint2-tamb)*errorabs;

 
   % valores de simulación en retardo G11
  if k <= 4
      y11(k)=0;
      
  end
  % valores de simulación postretardo G11
  if k > 4
      
     y11(k)=0.9888*y11(k-1) + 0.006911*u1s(k-4);

  end
  % valores de simulación en retardo G12
  if k <= 9
      y12(k)=0;
      
  end
  % valores de simulación postretardo G12
  if k > 9
      
     y12(k)=0.9912*y12(k-1) + 0.001934*u1s(k-9);

  end
  % valores de simulación en retardo G21
  if k <= 15
       y21(k)=0;
      
  end
  % valores de simulación postretardo G21
  if k > 15
      
     y21(k)=0.9924*y21(k-1) + 0.001683*u2s(k-15);

  end
  % valores de simulación en retardo G22
  if k <= 5
       y22(k)=0;
      
  end
  % valores de simulación postretardo G22
  if k > 5
      
     y22(k)=0.9874*y22(k-1) + 0.006606*u2s(k-5);

  end
  ypreal1(k) = y11(k)+y12(k)+tamb ;
  ypreal2(k) = y21(k)+y22(k)+tamb ;
  % error de consigna

  e1(k) = setpoint1-ypreal1(k) ;
  e2(k) = setpoint2-ypreal2(k) ;
   if k >1
      % controladores
      u1(k) = u1(k-1)+ e1(k-1)*(((Kp1*Ts)/Ti)-Kp1)+Kp1*e1(k) ;
      u2(k) = u2(k-1)+ e2(k-1)*(((Kp2*Ts)/Ti)-Kp2)+Kp2*e2(k) ;
      % desacopladores
      yd12(k)=0.991*yd12(k-1)-0.2518 *u2(k)+0.2485*u2(k-1);
      yd21(k)=0.991*yd21(k-1)-0.2892 *u1(k)+0.2855*u1(k-1);
 end
 
  if k==1
      % Controlador PI forward discreto en el momento inicial
      u1(k)=Kp1*e1(k);
      u2(k)=Kp2*e2(k);
      % desacopladores discreto en el momento inicial
      yd12(k)=-0.2518 *u2(k);
      yd21(k)=-0.2892 *u1(k);
  end


 u1s(k)= u1(k)+yd12(k);
 u2s(k)= u2(k)+yd21(k);


end

%% Mostrar valores 

subplot(2,1,1)
plot(time,ypreal1)
hold on
plot(time,ypreal2)

xlabel('Tiempo [s]');
ylabel('Temperatura [ºC]')
grid on
axis tight 

subplot(2,1,2)
plot(time,u1s)
xlabel('Tiempo [s]');
ylabel('Entrada [%]')
hold on
plot(time,u2s)
grid on
axis tight