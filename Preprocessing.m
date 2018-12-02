'Initializing Program'
%% Initialize Program, clear all 
clc
clear variables
pwd;

%% Loading Workspaces
% Load both reference and experimental workspaces from ProjectData folder
% Add parts to exp struct for preprocessing
for i = 4:-1:1
ref(i) = load(strcat('..\Data\Project Data\reference_',num2str(i),'_workspace.mat'),...
    'measuredTheta', 'outputSignal1', 'savedData', 'time', 'triggerTime');
end;

for i = 4:-1:1
exp(i) = load(strcat('..\Data\Project Data\run_',num2str(i),'_workspace.mat'),...
    'measuredTheta', 'outputSignal1', 'savedData', 'time', 'triggerTime');
end;

exp(4).delayTimes(38) = 0;
ref(4).delayTimes(4) = 0;

for i = 1:4
% adjustedData will be a struct for each angle with a 2D array inside it
% formatted as (time,data)
    ref(i).adjusted.data(:,1:2) = ref(i).savedData(:,1:2,1); 
    for angle = 1:38
        exp(i).adjusted(angle).data(:,1:2) = exp(i).savedData(:,1:2,angle); 
    end
end


'Apply low pass filters'
for run = 1:4
    ref(run).adjusted(1).data(:,2) = lowpass(ref(run).adjusted(1).data(:,2),15500,150000);
    ref(run).adjusted(1).data(:,2) = highpass(ref(run).adjusted(1).data(:,2),400,150000);
    for angle = 1:38
        'run' 
        run
        'angle' 
        angle
        exp(run).adjusted(angle).data(:,2) = lowpass(exp(run).adjusted(angle).data(:,2),15500,150000);
        exp(run).adjusted(angle).data(:,2) = highpass(exp(run).adjusted(angle).data(:,2),400,150000);

%         plot(exp(run).adjusted(angle).data(:,1),exp(run).adjusted(angle).data(:,2));
%         xlim([0 .1]);
%         pause
    end
end


'Align Data'
%% Aligning Data
[ref,exp] = align_data(ref, exp);

%% Plot
'Plot things'
plot_things(ref,exp)
