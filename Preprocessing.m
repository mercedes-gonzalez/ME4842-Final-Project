'Initializing Program'
%% Initialize Program, clear all 
clc
clear variables

pwd;

'Loading Workspaces'
%% Load both reference and experimental workspaces from ProjectData folder
%% Add parts to exp struct for preprocessing
for i = 4:-1:1
ref(i) = load(strcat('..\Data\Project Data\reference_',num2str(i),'_workspace.mat'),...
    'measuredTheta', 'outputSignal1', 'savedData', 'time', 'triggerTime');
end;

for i = 4:-1:1
exp(i) = load(strcat('..\Data\Project Data\run_',num2str(i),'_workspace.mat'),...
    'measuredTheta', 'outputSignal1', 'savedData', 'time', 'triggerTime');
end;

exp(1).delayTimes(38) = 0;
ref(1).delayTimes(4) = 0;
for i = 1:4
    for angle = 1:38
        % adjustedData will be a struct for each angle with a 2D array inside it
        exp(i).adjusted(angle).data(:,1:2) = exp(i).savedData(:,1:2,angle); 
    end
end

for i = 1:4
    % adjustedData will be a struct for each angle with a 2D array inside it
    ref(i).adjusted.data(:,1:2) = ref(i).savedData(:,1:2,1); 
end

'Aligning Data'
%% Align data by finding minimum delay between first and any other angle
%% and trimming off the excess data at the beginning. (for each run)
[ref,minIndexRef] = align_and_trim_ref(ref);
[exp,minDelayTimeExpFinal,minRunExpFinal,minAngleExpFinal] = align_and_trim_exp(exp);

% %% Construct min
% min.minIndexRef = minIndexRef;
% min.minDelayTimeExpFinal = minDelayTimeExpFinal;
% min.minRunExpFinal = minRunExpFinal;
% min.minAngleExpFinal = minAngleExpFinal;

% [ref,exp] = align_all(ref,exp,min);

% 'Removing Spikes'

%% Define Fourier Parameters
% L = 40001;
% Fs = 40000;
% P2 = abs(fourierData/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;
% plot(f,P1)
% 
% title('Single-Sided Amplitude Spectrum of S(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
% 
% spectrogram(data,128,120,128,150000,'yaxis')

% startindex =  find(f == 50);
% finishindex = find(f == 15000);
% 
% 
% fTrimmed = f(startindex:finishindex)
% P1Trimmed = P1(startindex:finishindex);
% plot(fTrimmed,P1Trimmed)


%% Ref preprocessing
% %%
% plot(r(1).savedData)
% hold on;
% plot(r(1).outputSignal1)
% hold off;
% 
% % I think we need to swap columns 1 and 2 of all the data.savedData or specify column 2 somehow;
% % fft may be operating on first column - MR
% Y=fft(r(2).savedData(:,2))
% L=40001
% Fs=40000
% 
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;
% plot(f,P1)
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')