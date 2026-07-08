% connect to Arduino

    com_port = input('Specify port (e.g. COM4 for Windows or /dev/ttyUSB0 for Linux): ','s');
     a = arduino(com_port,'Uno','BaudRate',9600);
    disp(a)


% a = arduino('COM6','uno','BaudRate',9600);
% disp(a)

% voltage read functions
v1a = @(x) readVoltage(a, 'A0');
v2a = @(x) readVoltage(a, 'A2');

v1 = @(n) mean(arrayfun(v1a,ones(n,1)));
v2 = @(n) mean(arrayfun(v2a,ones(n,1)));

% temperature calculations as a function of voltage for TMP36
% TC = @(V) (V - 0.5)*100.0;          % Celsius
% TK = @(V) TC(V) + 273.15;           % Kelvin
% TF = @(V) TK(V) * 9.0/5.0 - 459.67; % Fahrenhiet

% temperature calculations as a function of voltage for LMT86 (SE-ULL)
TC = @(V) -50 - (V - 2.6)*(200/2.2);          % Celsius
TK = @(V) TC(V) + 273.15;           % Kelvin
TF = @(V) TK(V) * 9.0/5.0 - 459.67; % Fahrenhiet

% temperature read functions
T1C = @() TC(v1(10));
T2C = @() TC(v2(10));

% LED function (0 <= level <= 1)
led = @(level) writePWMDutyCycle(a,'D9',max(0,min(1,level)));  % ON

% heater output (0 <= heater <= 100)
% limit to 0-0.9 (0-100%)
h1 = @(level) writePWMDutyCycle(a,'D3',max(0,min(100,level))*0.95/100);
% limit to 0-0.5 (0-100%)
h2 = @(level) writePWMDutyCycle(a,'D5',max(0,min(100,level))*0.95/100);
