clc
clear variables
for i = 4:-1:1
ref(i) = load(strcat('Data\Project Data\reference_',num2str(i),'_workspace.mat'),...
    'measuredTheta', 'outputSignal1', 'savedData', 'time', 'triggerTime');
end;

for i = 4:-1:1
exp(i) = load(strcat('Data\Project Data\run_',num2str(i),'_workspace.mat'),...
    'measuredTheta', 'outputSignal1', 'savedData', 'time', 'triggerTime');
end;

%%
plot(data(1).savedData)
hold on;
plot(data(1).outputSignal1)
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