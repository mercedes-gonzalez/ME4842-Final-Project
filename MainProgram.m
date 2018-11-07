%% Call Set Up Function to load workspace
setup_srv02_exp02_pos();

%% Rebuild Simulink model
inputAngle = 100
%rtwbuild('Simulate_it3');

%% Define myDAQ session and channel
devices = daq.getDevices;
s = daq.createSession('ni');
addAnalogInputChannel(s, 'myDAQ2',0,'Voltage');
addAnalogOutputChannel(s, 'myDAQ2',0,'Voltage');
addAnalogOutputChannel(s, 'myDAQ2',1,'Voltage');
s.Rate = 150000; %scans per second
outputSignalValue = 0.5; % Volts per channel

%% Set plot parameters
xlim([0 15]);
xlabel('Time (s)');
ylabel('Amplitude (V)');
legend(['Measured','Output']);

%% Move servo to 100 degrees
set_param(gcs,'SimulationMode','external');
set_param(gcs,'SimulationCommand','connect');
set_param(gcs,'SimulationCommand','start');
pause(15);
set_param(gcs,'SimulationCommand','stop');

%% Signal generation and reading
t = 0:0.00000666666:3; % Seconds
outputSignal1 = chirp(t,50,1,15000)';
outputSignal2 = -chirp(t,50,1,15000)';
zeroData = zeros(15000,1);
outputSignal1 = vertcat(zeroData,outputSignal1,zeroData);
outputSignal2 = vertcat(zeroData,outputSignal2,zeroData);


for i = 1:38
    inputAngle = 100-5*i %degrees
    set_param('Simulate_it3/inputAngle','Value',num2str(inputAngle));
    set_param(gcs,'SimulationCommand','connect');
    set_param(gcs,'SimulationCommand','start');
    pause(3);
    %% Store theta information for later on
    measuredTheta(i) = theta_l(end);
    inputTheta(i) = inputAngle;

    set_param(gcs,'SimulationCommand','stop');
    pause(2);
    
    %% Send output signal
    queueOutputData(s,[outputSignal1, outputSignal2]);
    %s.DurationInSeconds = 1;

    %% Read signal
    [data,time,triggerTime] = s.startForeground;
    triggerArray(i) = triggerTime;
    
    savedData(:,1,i) = time;
    savedData(:,2,i) = data;
    
    %% Plot measured data and output signals. 
    plot(time,data,'r');
end


