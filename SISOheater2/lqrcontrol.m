% El objetivo de este scrip es crear un control lqr en combinación con un
% PI para llegar a consigna. Sin tener en cuenta los retardos

clear all
close all


% cargar librería
tclabULL;

%%calculo de la forma canónica 

sysmodel=tf( 0.5696,[150, 1]);
sysmodel=c2d(sysmodel,2,'zoh');
state = canon(sysmodel,'companion');


%matrices de forma canónica observable
A=state.A;
B=state.B;
C=state.C;
D=state.D;

%matrices de forma canónica controlable
Aco=A';
Bco=C';
Cco=B';
Dco=D;

%valores de integral de gasto
Q=0.1;
R=0.001;

%Cálculo de valor de ganancia
[K,S,P] = dlqr(Aco,Bco,Q,R);


%inicializar valores
nIter = 480; % 600s

x=[];
u=[];

u0=10.43;
U=[];
setpoint=30.00;
Kp = 7.3; 
Ti = 75;  
Ts = 2;
ise1=0;
itse1=0;
iae1=0;
itae1=0;



for k = 1:1:nIter
    t_ini = tic();
  y(k)= T2C();
  %Controlador PI que lleva a la consigna
  if k<150
    % Control de error
    e(k) = setpoint-y(k);
    % Controlador PI forward 
     if k >1
      u(k) = u(k-1)+ e(k-1)*(((Kp*Ts)/Ti)-Kp)+Kp*e(k) ;
     end
     % Controlador PI forward en valor inicial
     if k==1
        u(k)=Kp*e(k);  
     end
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
   % Controlador lqr
  if k>=150
       if k==150
            m=0;
            n=0;
        for x= 1:1:20
            m=m+y(k-x);
            n=n+u(k-x-1);
        end
        m=m/x
        n=n/x
       end
    e(k) = m-y(k);
    if k==150||k==300
        T2C()
    end
  %cálculo de la entrada
    U(k)=-K*(y(k)-m);
    u(k)=U(k)+n;
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

   ise1=ise1+e(k)^2;
   itse1=itse1+k*e(k)^2;
   iae1= iae1+ abs(e(k));
   itae1=itae1+ k*abs(e(k));
  end

    time(k)=2*k-Ts;
    %mostrar resultados en cada iteración
    subplot(2,1,1)
    plot(time,y);
    xlabel('Tiempo [s]');
    ylabel('Temperatura [ºC]')
    grid on
    hold on
    %plot de la entrada
    subplot(2,1,2)
    plot(time,u)
    xlabel('Tiempo [s]');
    ylabel('Entrada [%]')
    hold on
    grid on

   
     
     
     elapsed_time = toc(t_ini);
    pause(Ts - elapsed_time);
end
%apagar heater
h2(0)

save lqrcontrol itae1 iae1 itse1 ise1 e