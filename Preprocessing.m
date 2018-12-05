'Initializing Program'
%% Initialize Program, clear all 
clc
clear variables
pwd;

%% Loading Workspaces
% Load both reference and experimental workspaces from ProjectData folder
% Add parts to exp struct for preprocessing
for i = 1:4
ref(i) = load(strcat('..\Data\Project Data\reference_',num2str(i),'_workspace.mat'),...
    'measuredTheta', 'savedData');
exp(i) = load(strcat('..\Data\Project Data\run_',num2str(i),'_workspace.mat'),...
    'measuredTheta', 'savedData');
end

%% Trim data
for run = 1:4
    % Trim savedData to 0 --> 1.5 seconds lol
    ref(run).savedData(240001:end,:,:) = [];
    exp(run).savedData(240001:end,:,:) = [];
    
    % Create adjusted data struct
    ref(run).adjusted(1).data(:,1:2) = ref(run).savedData(:,1:2,1);
    for angle = 1:38
        exp(run).adjusted(angle).data(:,1:2) = exp(run).savedData(:,1:2,angle);
    end 
end
    
%% Apply Filters    
'Apply filters'
for run = 1:4
    ref(run).adjusted(1).data(:,2) = lowpass(ref(run).savedData(:,2,1),15500,150000);
    ref(run).adjusted(1).data(:,2) = highpass(ref(run).savedData(:,2,1),400,150000);
    for angle = 1:38
        exp(run).adjusted(angle).data(:,2) = lowpass(exp(run).savedData(:,2,angle),15500,150000);
        exp(run).adjusted(angle).data(:,2) = highpass(exp(run).savedData(:,2,angle),400,150000);
    end
end

%% Plots
for run = 1:4
    plot(ref(run).adjusted(1).data(:,1),ref(run).adjusted(1).data(:,2));
    hold on;
    plot(ref(run).savedData(:,1),ref(run).savedData(:,2));
%     for angle = 1:38
%         plot(exp(run).adjusted(angle).data(:,1),exp(run).adjusted(angle).data(:,2));
%         plot(exp(run).savedData(:,1,angle),exp(run).savedData(:,2,angle));
%     end
end
