clc
clear variables

f_samp = 150000; %sampling rate
f_min = 20; %high pass
f_min_n = f_min/(f_samp/2); %normalized
f_max = 20000; %low pass
f_max_n = f_max/(f_samp/2); %normalized

for i = 4:-1:1
ref(i) = load(strcat('Data\Project Data\reference_',num2str(i),'_workspace.mat'),...
    'measuredTheta', 'outputSignal1', 'savedData', 'time', 'triggerTime');
end;

for i = 4:-1:1
exp(i) = load(strcat('Data\Project Data\run_',num2str(i),'_workspace.mat'),...
    'measuredTheta', 'outputSignal1', 'savedData', 'time', 'triggerTime');
end;

%%
%Lowpass = l
for i = 1:4
exp_l(i).savedData=lowpass(exp(i).savedData,f_max,f_samp);
end


smoothed = medfilt1(ref(1).savedData)
for i = 1:1000
    smoothed = medfilt1(smoothed);
end

plot(smoothed)
hold on;
plot(ref(1).savedData)
hold off;

% I think we need to swap columns 1 and 2 of all the data.savedData or specify column 2 somehow;
% fft may be operating on first column - MR
Y=fft(data(2).savedData(:,2)) 
L=40001
Fs=40000

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')