% El objetivo de este scrip es crear un control lqr en combinación con un
% PI para llegar a consigna. Sin tener en cuenta los retardos

clear all
close all

% cargar librería
load IdentifiedSystem

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
Q1=0.11;
Q2=0.12;
Q3=0.13;
Q4=0.09;
Q5=0.08;
Q6=0.07;


%Cálculo de valor de ganancia
[K,S,P] = dlqr(Aco,Bco,Q,R);
[K1,S1,P1] = dlqr(Aco,Bco,Q1,R);
[K2,S2,P2] = dlqr(Aco,Bco,Q2,R);
[K3,S3,P3] = dlqr(Aco,Bco,Q3,R);
[K4,S4,P4] = dlqr(Aco,Bco,Q4,R);
[K5,S5,P5] = dlqr(Aco,Bco,Q5,R);
[K6,S6,P6] = dlqr(Aco,Bco,Q6,R);
%inicializar valores
nIter = 480; % 960s


x=[];
u=[];

tamb=23.74;
Uref=10,7777;
U=[];
setpoint=30;
Kp = 7.3; 
Ti = 75;  
Ts = 2;

for k = 1:1:nIter
  %Controlador PI que lleva a la consigna
  if k<150
    % Control de error
     % valores de simulación en retardo
  if k <= 4
      yp(k)=0;
      
  end
% valores de simulación post retardo
  if k > 4
      
     yp(k)=0.9868*yp(k-1) + 0.007545*u(k-4);

  end

  ypreal(k) = yp(k);
  % ypreal1(k) = yp(k);
  % ypreal2(k) = yp(k);
  % ypreal3(k) = yp(k);
  % ypreal4(k) = yp(k);
  % ypreal5(k) = yp(k);
  % ypreal6(k) = yp(k);

  yreal(k)=ypreal(k)+tamb;
  % yreal1(k)=ypreal1(k)+tamb;
  % yreal2(k)=ypreal2(k)+tamb;
  % yreal3(k)=ypreal3(k)+tamb;
  % yreal4(k)=ypreal4(k)+tamb;
  % yreal5(k)=ypreal5(k)+tamb;
  % yreal6(k)=ypreal6(k)+tamb;
  % error de consigna

  e(k) = setpoint-ypreal(k)-tamb ;

   % Controlador PI forward discreto 
  if k >1
      u(k) = u(k-1)+ e(k-1)*(((Kp*Ts)/Ti)-Kp)+Kp*e(k) ;
      u1(k)=u(k);
      u2(k)=u(k);
      u3(k)=u(k);
      u4(k)=u(k);
      u5(k)=u(k);
      u6(k)=u(k);
  end
  % Controlador PI forward discreto en el momento inicial
  if k==1
      u(k)=Kp*e(k);
      % u1(k)=u(k);
      % u2(k)=u(k);
      % u3(k)=u(k);
      % u4(k)=u(k);
      % u5(k)=u(k);
      % u6(k)=u(k);
  end
   
  end
   
  
  if k>=150
  if k>200 && k<400
 
    ULQ(k)=-K*(ypreal(k-1)-ypreal(149)) ; 
    u(k)=ULQ(k)+Uref;
    ypreal(k)=Aco*(ypreal(k-1))+Bco*u(k);
    yreal(k)=ypreal(k-1)+tamb;
  
    % ULQ1(k)=-K1*(ypreal1(k-1)-ypreal1(149)-2) ; 
    % u1(k)=ULQ1(k)+Uref;
    % ypreal1(k)=Aco*(ypreal1(k-1))+Bco*u1(k);
    % yreal1(k)=ypreal1(k-1)-2+tamb;
    % 
    % ULQ2(k)=-K2*(ypreal2(k-1)-ypreal2(149)-2) ; 
    % u2(k)=ULQ2(k)+Uref;
    % ypreal2(k)=Aco*(ypreal2(k-1))+Bco*u2(k);
    % yreal2(k)=ypreal2(k-1)-2+tamb;
    % 
    % ULQ3(k)=-K3*(ypreal3(k-1)-ypreal3(149)-2) ; 
    % u3(k)=ULQ3(k)+Uref;
    % ypreal3(k)=Aco*(ypreal3(k-1))+Bco*u3(k);
    % yreal3(k)=ypreal3(k-1)-2+tamb;
    % 
    % ULQ4(k)=-K4*(ypreal4(k-1)-ypreal4(149)-2) ; 
    % u4(k)=ULQ4(k)+Uref;
    % ypreal4(k)=Aco*(ypreal4(k-1))+Bco*u4(k);
    % yreal4(k)=ypreal4(k-1)-2+tamb;
    % 
    % ULQ5(k)=-K5*(ypreal5(k-1)-ypreal5(149)-2) ; 
    % u5(k)=ULQ5(k)+Uref;
    % ypreal5(k)=Aco*(ypreal5(k-1))+Bco*u5(k);
    % yreal5(k)=ypreal5(k-1)-2+tamb;
    % 
    % ULQ6(k)=-K6*(ypreal6(k-1)-ypreal6(149)-2) ; 
    % u6(k)=ULQ6(k)+Uref;
    % ypreal6(k)=Aco*(ypreal6(k-1))+Bco*u6(k);
    % yreal6(k)=ypreal6(k-1)-2+tamb;



else
  ULQ(k)=-K*(ypreal(k-1)-ypreal(149)) ; 
  u(k)=ULQ(k)+Uref;
  ypreal(k)=Aco*ypreal(k-1)+Bco*u(k);
  yreal(k)=ypreal(k)+tamb;

   % ULQ1(k)=-K1*(ypreal1(k-1)-ypreal1(149)) ; 
   % u1(k)=ULQ1(k)+Uref;
   % ypreal1(k)=Aco*(ypreal1(k-1))+Bco*u(k);
   % yreal1(k)=ypreal1(k-1)+tamb;
   % 
   % ULQ2(k)=-K2*(ypreal2(k-1)-ypreal2(149)) ; 
   %  u2(k)=ULQ2(k)+Uref;
   %  ypreal2(k)=Aco*(ypreal2(k-1))+Bco*u2(k);
   %  yreal2(k)=ypreal2(k-1)+tamb;
   % 
   %  ULQ3(k)=-K3*(ypreal3(k-1)-ypreal3(149)) ; 
   %  u3(k)=ULQ3(k)+Uref;
   %  ypreal3(k)=Aco*(ypreal3(k-1))+Bco*u3(k);
   %  yreal3(k)=ypreal3(k-1)+tamb;
   % 
   %  ULQ4(k)=-K4*(ypreal4(k-1)-ypreal4(149)) ; 
   %  u4(k)=ULQ4(k)+Uref;
   %  ypreal4(k)=Aco*(ypreal4(k-1))+Bco*u4(k);
   %  yreal4(k)=ypreal4(k-1)+tamb;
   % 
   %  ULQ5(k)=-K5*(ypreal5(k-1)-ypreal5(149)) ; 
   %  u5(k)=ULQ5(k)+Uref;
   %  ypreal5(k)=Aco*(ypreal5(k-1))+Bco*u5(k);
   %  yreal5(k)=ypreal5(k-1)+tamb;
   % 
   %  ULQ6(k)=-K6*(ypreal6(k-1)-ypreal6(149)) ; 
   %  u6(k)=ULQ6(k)+Uref;
   %  ypreal6(k)=Aco*(ypreal6(k-1))+Bco*u6(k);
   %  yreal6(k)=ypreal6(k-1)+tamb;
end
  
  end
  
    time(k)=(2*k);
 end  
    


subplot(2,1,1)
% plot(time,yreal3,'c')
% hold on
% plot(time,yreal2,'b')
% hold on
% plot(time,yreal1,'g')
% hold on
plot(time,yreal,'r')
hold on
% plot(time,yreal4,'m')
% hold on
% plot(time,yreal5,'y')
% hold on
% plot(time,yreal6,'k')
% hold on
% legend('Q=0.13 R=0.001','Q=0.12 R=0.001','Q=0.11 R=0.001','Q=0.1 R=0.001', ...
%     'Q=0.09 R=0.001','Q=0.08 R=0.001','Q=0.07R=0.001')
xlabel('Tiempo [s]');
ylabel('Temperatura [ºC]')
grid on
axis tight

subplot(2,1,2)
% plot(time,u3,'c')
% hold on
% plot(time,u2,'b')
% hold on
% plot(time,u1,'g')
% hold on
plot(time,u,'r')
hold on
% plot(time,u4,'m')
% hold on
% plot(time,u5,'y')
% hold on
% plot(time,u6,'k')
% hold on
% legend('Q=0.13 R=0.001','Q=0.12 R=0.001','Q=0.11 R=0.001','Q=0.1 R=0.001', ...
%     'Q=0.09 R=0.001','Q=0.08 R=0.001','Q=0.07R=0.001')
xlabel('Tiempo [s]');
ylabel('Entrada [%]')
grid on
axis tight

