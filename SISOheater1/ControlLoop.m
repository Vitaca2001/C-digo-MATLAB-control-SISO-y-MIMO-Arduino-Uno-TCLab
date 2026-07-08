
%
% El objetivo de este script es programar una simulción de un controlador
% PI para el sistema
% 

clear all
close all



%% Parámetros de el controlador
% considerar valores PI forward
Kp =7.3; 
Ti = 75;   
Ts = 2;


%% Consigna de temperatura ºC
setpoint = 30;

%% Inicializar variables
% Temperatura ambiente
tamb=23.74;

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
    
% errorsup(k)= setpoint+(setpoint-tamb)*errorabs;
 %errorinf(k)= setpoint-(setpoint-tamb)*errorabs;

 % valores de simulación en retardo
  if k <= 4
      yp(k)=0;
      
  end
% valores de simulación postretardo
  if k > 4
      
     yp(k)=0.9868*yp(k-1) + 0.008557*u(k-4);

  end

  ypreal(k) = yp(k)+tamb ;

  % error de consigna

  e(k) = 30-ypreal(k) ;

   % Controlador PI forward discreto 
  if k >1
      u(k) = u(k-1)+ e(k-1)*(((Kp*Ts)/Ti)-Kp)+Kp*e(k) ;
     
  end
  % Controlador PI forward discreto en el momento inicial
  if k==1
      u(k)=Kp*e(k);
  end


end

%% Mostrar valores 
time=time;
subplot(2,1,1)
plot(time,ypreal)
hold on
%plot(time,errorinf)
hold on
%plot(time,errorsup)
hold on
xlabel('Tiempo [s]');
ylabel('Temperatura [ºC]')
grid on
axis tight
subplot(2,1,2)
plot(time,u)
xlabel('Tiempo [s]');
ylabel('Entrada [%]')
hold on
grid on
axis tight
%subplot(2,2,3)
%plot(time,yp)
%xlabel('Time [s]');
%ylabel('Incremento Temperature [ºC]')
%hold on
%grid on

save controlloop Kp Ti
