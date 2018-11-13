function exp = align_and_trim(exp)
    %% Trim savedData to 0 --> 1.5 seconds lol
    exp.savedData(240001:end,:,:) = []
    exp.time(240001:end,:) = []
    exp.outputSignal1(240001:end,:) = []

    
    %% Calculate the delay between the first and any other angle's signal
    for angle = 1:38
        exp.delayTimes(angle) = finddelay(exp.savedData(:,2,angle),exp.savedData(:,2,1));
    end
    [minDelay, minIndex] = min(exp.delayTimes)
        
    for angle = 1:38
        offsetTime = exp.delayTimes(angle)/150000; % seconds
        exp.adjusted(angle).data(:,1) = exp.adjusted(angle).data(:,1) - offsetTime;                
        plot(exp.adjusted(angle).data(:,1),exp.adjusted(angle).data(:,2),'r');
        hold on
        scatter(exp.savedData(:,1,angle),exp.savedData(:,2,angle),'b','.');
    end
end