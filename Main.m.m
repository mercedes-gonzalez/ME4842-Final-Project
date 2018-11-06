%% Call Set Up Function to load workspace
setup_srv02_exp02_pos();

%% Rebuild Simulink model
inputAngle = 100;
%rtwbuild('Simulate_it3');

%% Define myDAQ session and channel
devices = daq.getDevices;
s = daq.createSession('ni');
addAnalogInputChannel(s, 'myDAQ1',0,'Voltage');
addAnalogOutputChannel(s, 'myDAQ1',0,'Voltage');
addAnalogOutputChannel(s, 'myDAQ1',1,'Voltage');
s.Rate = 10000; %scans per second
%s.DurationInSeconds = 1;
outputSignalValue = 1; % Volts per channel
xlim([0 10]);

%% Start at 100 degrees 
set_param(gcs,'SimulationMode','external');
set_param(gcs,'SimulationCommand','connect');
set_param(gcs,'SimulationCommand','start');
pause(15);

set_param(gcs,'SimulationCommand','stop');

%% Signal generation and reading
t = 0:0.000015:1; % Seconds
outputSignal1 = chirp(t,50,1,15000)';
outputSignal2 = -chirp(t,50,1,15000)';

for i = 1:37
    inputAngle = 100-5*i
    set_param('Simulate_it3/inputAngle','Value',num2str(inputAngle));
    set_param(gcs,'SimulationCommand','connect');
    set_param(gcs,'SimulationCommand','start');
    pause(3);
    measuredTheta(i) = theta_l(end)
    inputTheta(i) = inputAngle;
    set_param(gcs,'SimulationCommand','stop');
    pause(1);
    queueOutputData(s,[outputSignal1, outputSignal2]);
    [data,time] = s.startForeground;
    plot(time,data)
end

%outputSignal = sin(linspace(0,pi*2,s.Rate)');

