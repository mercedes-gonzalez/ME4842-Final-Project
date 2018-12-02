%% Initialize Program, clear all
clc
clear variables

%% Loading Workspaces
% Load sample workspace with stored data. The reference microphone is
% stored in the ref struct and one run of the experiment is stored in
% the exp struct. The format of data is (time, data)
load(strcat('sampleWorkspace.mat'),'ref','exp')

% Initialize array to store the delay times
exp(1).delayTimes(38) = 0;
ref(1).delayTimes(4) = 0;

% adjusted.data will be a struct for each angle with a 2D array inside it
% formatted as (time,data)
ref(1).adjusted.data(:,1:2) = ref(1).savedData(:,1:2,1); 
for angle = 1:38
    exp(1).adjusted(angle).data(:,1:2) = exp(1).savedData(:,1:2,angle); 
end

%% Aligning Data
% Trim savedData to 0 --> 1.5 seconds (Data runs were longer than necessary)
ref(1).savedData(240001:end,:,:) = [];
ref(1).time(240001:end,:) = [];
ref(1).outputSignal1(240001:end,:) = [];  
ref(1).adjusted.data(240001:end,:) = [];
exp(1).savedData(240001:end,:,:) = [];
exp(1).time(240001:end,:) = [];
exp(1).outputSignal1(240001:end,:) = [];
for angle = 1:38
    exp(1).adjusted(angle).data(240001:end,:) = [];
end

% Create array to compare all delays in experimental runs
compareDelayTimesArray = ones(38,4);

% Calculate the delay between the first reference signal and every
% other signal, including each angle from each experimental
ref(1).delayTimes(1) = finddelay(ref(1).savedData(:,2,1),ref(1).savedData(:,2,1));
for angle = 1:38
    exp(1).delayTimes(angle) = finddelay(exp(1).savedData(:,2,angle),ref(1).savedData(:,2,1));
    compareDelayTimesArray(angle,1) = exp(1).delayTimes(angle);
end

% Find minimum delay between reference 1 and every other signal
minDelayRef = min(ref(1).delayTimes);
minDelayExpRowVec = min(compareDelayTimesArray,[],1);
minDelayExp = min(minDelayExpRowVec);

% Store min delay in minDelayFinal
if minDelayRef < minDelayExp
    minDelayFinal = minDelayRef;
else
    minDelayFinal = minDelayExp;
end
    
% Align reference to experimentals
delayTime = ref(1).delayTimes(1)/150000; % seconds
offsetTime = delayTime - (minDelayFinal/150000);
ref(1).adjusted(1).data(:,1) = ref(1).adjusted(1).data(:,1) + offsetTime;   
lastTime = ref(1).adjusted(1).data(end,1);
timeStep = 1/150000;
endTime = lastTime + 22144/150000;
zeroData(:,1) = linspace(lastTime+timeStep,endTime,22144);
zeroData(:,2) = 0;
ref(1).adjusted(1).data = vertcat(ref(1).adjusted(1).data,zeroData);

for angle = 1:38
    delayTime = exp(1).delayTimes(angle)/150000; % seconds
    offsetTime = delayTime - (minDelayFinal/150000);
    exp(1).adjusted(angle).data(:,1) = exp(1).adjusted(angle).data(:,1) + offsetTime;  
    lastTime = exp(1).adjusted(angle).data(end,1);
    timeStep = 1/150000;
    endTime = lastTime + 22144/150000;
    zeroData(:,1) = linspace(lastTime+timeStep,endTime,22144);
    zeroData(:,2) = 0;
    exp(1).adjusted(angle).data = vertcat(exp(1).adjusted(angle).data,zeroData);
    figure(1)

end

minDelayTime = abs(minDelayFinal/150000);

ref(1).adjusted(1).data(:,1) = ref(1).adjusted(1).data(:,1) - minDelayTime;

for angle = 1:38
    exp(1).adjusted(1).data(:,1) = exp(1).adjusted(1).data(:,1) - minDelayTime;
    exp(1).adjusted(1).data(:,2) = lowpass(exp(1).adjusted(1).data(:,2),17000,150000);
    plot(exp(1).adjusted(angle).data(:,1),exp(1).adjusted(angle).data(:,2));
    hold on;
end

%% Pad outputsignal with zeros at the end to match matrix dimensions of data
t = 0:0.00000666666:1; 
outputSignal = chirp(t,50,1,15000)';
lastTime = exp(1).adjusted(1).data(end,1);
timeStep = 1/150000;
endTime = lastTime + 112143/150000;
zeroData_(:,1) = linspace(lastTime+timeStep,endTime,112143)';
zeroData_(:,2) = 0;
outputSignal = vertcat(outputSignal,zeroData_(:,2));
outputSignal = outputSignal.^-1;

ut = outputSignal.*exp(1).adjusted(1).data(:,2);
ht = ifft(ut).*outputSignal;

figure(2)
%% Fourier 
L=262144;
Fs=150000;
Y=fft(exp(1).adjusted(1).data(:,2));
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
