function [ref,exp] = align_data(ref,exp)
    'Reference Alignment'
    %% Trim data
    for run = 1:4
        %% Trim savedData to 0 --> 1.5 seconds lol
        ref(run).savedData(240001:end,:,:) = [];
        ref(run).time(240001:end,:) = [];
        ref(run).outputSignal1(240001:end,:) = [];        
        exp(run).savedData(240001:end,:,:) = [];
        exp(run).time(240001:end,:) = [];
        exp(run).outputSignal1(240001:end,:) = [];
    end
    
    %% Create array to compare all delays in experimental runs
    compareDelayTimesArray = ones(38,4);
    
    %% Calculate the delay between the first reference signal and every
    %% other signal, including each angle from each experimental
    for run = 1:4
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
    figure(1)
    for i = 1:4
        delayTime = ref(1).delayTimes(i)/150000; % seconds
        offsetTime = delayTime - (minDelayFinal/150000);
        ref(i).adjusted(1).data(:,1) = ref(i).adjusted(1).data(:,1) + offsetTime;                
        plot(ref(i).adjusted(1).data(:,1),ref(i).adjusted(1).data(:,2));
        xlim([0 .1]);
        title('Reference Aligned');
        hold on;
    end
%     figure(2)
    for i = 1:4              
        plot(ref(i).savedData(:,1,1),ref(i).savedData(:,2,1));
        xlim([0 .1]);
        title('Reference Saved');
        hold on;
    end
    
    %% Align Experimentals
%     figure(3)
    for i = 1:4
        for angle = 1:38
            delayTime = exp(i).delayTimes(angle)/150000; % seconds
            offsetTime = delayTime - (minDelayFinal/150000);
            exp(i).adjusted(angle).data(:,1) = exp(i).adjusted(angle).data(:,1) + offsetTime;       
            plot(exp(i).adjusted(angle).data(:,1),exp(i).adjusted(angle).data(:,2))
            hold on;
            plot(exp(i).adjusted(angle).data(:,1),exp(i).adjusted(angle).data(:,2));
            xlim([0 .1]);
            title('Experimental Aligned');
        end
    end
    
%     figure(4)
    for i = 1:4
        for angle = 1:38
            plot(exp(i).savedData(:,1,angle),exp(i).savedData(:,2,angle));
            hold on
            xlim([0 .1])
            title('Experimental Saved');
        end
    end

end