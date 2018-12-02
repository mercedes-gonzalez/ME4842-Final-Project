function [ref,exp] = align_data(ref,exp)
    'Reference Alignment'
    %% Trim data
    for run = 1:1
        %% Trim savedData to 0 --> 1.5 seconds lol
        ref(run).savedData(240001:end,:,:) = [];
        ref(run).outputSignal1(240001:end,:) = [];  
        ref(run).adjusted.data(240001:end,:) = [];
        exp(run).savedData(240001:end,:,:) = [];
        exp(run).outputSignal1(240001:end,:) = [];
        for angle = 1:38
            exp(run).adjusted(angle).data(240001:end,:) = [];
        end
    end
    
    %% Create array to compare all delays in experimental runs
    compareDelayTimesArray = ones(38,4);
    
    %% Calculate the delay between the first reference signal and every
    %% other signal, including each angle from each experimental
    for run = 1:1 %4 
        % Delay times for references will be stored in ref(1).delayTimes
        ref(1).delayTimes(run) = finddelay(ref(run).savedData(:,2,1),ref(1).savedData(:,2,1));
        for angle = 1:38
            exp(run).delayTimes(angle) = finddelay(exp(run).savedData(:,2,angle),ref(1).savedData(:,2,1));
            compareDelayTimesArray(angle,run) = exp(run).delayTimes(angle);
        end
    end
    
    %% Find minimum delay between reference 1 and every other signal
    minDelayRef = min(ref(1).delayTimes);
    minDelayExpRowVec = min(compareDelayTimesArray,[],1);
    minDelayExp = min(minDelayExpRowVec);
    
    %% Store min delay in minDelayFinal
    if minDelayRef < minDelayExp
        minDelayFinal = minDelayRef;
    else
        minDelayFinal = minDelayExp;
    end
    
    %% Align references
    for run = 1:1
        delayTime = ref(1).delayTimes(run)/150000; % seconds
        offsetTime = delayTime - (minDelayFinal/150000);
        ref(run).adjusted(1).data(:,1) = ref(run).adjusted(1).data(:,1) + offsetTime;   
        lastTime = ref(run).adjusted(1).data(end,1);
        timeStep = 1/150000;
        endTime = lastTime + 22144/150000;
        zeroData(:,1) = linspace(lastTime+timeStep,endTime,22144);
        zeroData(:,2) = 0;
        ref(run).adjusted(1).data = vertcat(ref(run).adjusted(1).data,zeroData);
    end
    
    %% Align Experimentals
    for run = 1:1
        for angle = 1:38
            delayTime = exp(run).delayTimes(angle)/150000; % seconds
            offsetTime = delayTime - (minDelayFinal/150000);
            exp(run).adjusted(angle).data(:,1) = exp(run).adjusted(angle).data(:,1) + offsetTime;  
            lastTime = exp(run).adjusted(angle).data(end,1);
            timeStep = 1/150000;
            endTime = lastTime + 22144/150000;
            zeroData(:,1) = linspace(lastTime+timeStep,endTime,22144);
            zeroData(:,2) = 0;
            exp(run).adjusted(angle).data = vertcat(exp(run).adjusted(angle).data,zeroData);
        end
    end
    
    minDelayTime = abs(minDelayFinal/150000);

    for run = 1:1
        ref(run).adjusted(1).data(:,1) = ref(run).adjusted(1).data(:,1) - minDelayTime;
        for angle = 1:38
            exp(run).adjusted(1).data(:,1) = exp(run).adjusted(1).data(:,1) - minDelayTime;
        end
    end
    
end