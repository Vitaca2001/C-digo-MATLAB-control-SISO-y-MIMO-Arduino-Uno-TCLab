
close all
clear all

%% Load TCLab file
tclabULL

%% definición de variables
% Inicializar valores
temperature =[] ; 
heat =[] ;
time =[] ;
time_end = 960;
T = 2;


% Fixed variables
 % Sampling time in s

%% Definition of the loop for the iterations
figure(100)

for k = 1:1:time_end/T
    t_ini = tic();

    % Read the value of the output
if k <= 10
   aux = 0;
   h1(aux);
  
end
if k > 10
    aux = 50;
    h1(aux);
    
end
heat(k)=aux;
time(k)=2*k-T;
temperature11(k)=T1C();
temperature21(k)=T2C();


    % Set the value of the input


    % Update the variables (array)



    % Plot the results
    subplot(2,2,1)
    plot(time,temperature11);
    title('G11(s)');
    xlabel('Time [s]');
    ylabel('Temperature [ºC]')
    grid on
    hold on
    
    subplot(2,2,2)
    plot(time,temperature21);
    title('G21(s)');
    xlabel('Time [s]');
    ylabel('Temperature [ºC]')
    hold on
    grid on



    subplot(2,2,3)
    plot(time,heat);
    xlabel('Time [s]');
    ylabel('Input [%]')
    grid on
    hold on
    elapsed_time = toc(t_ini);
    pause(T - elapsed_time); % Sleep for T s


end

%% Turn-off the input of the system
h1(0);


%% Save the response of the system in StepRespone.mat
save StepResponse11 temperature11 temperature21 heat time
