function [ref,minIndexRef] = align_and_trim_ref(ref)
    'Reference Alignment'
    %% Trim data
    for i = 1:4
        %% Trim savedData to 0 --> 1.5 seconds lol
        ref(i).savedData(240001:end,:,:) = [];
        ref(i).time(240001:end,:) = [];
        ref(i).outputSignal1(240001:end,:) = [];
    end
    
    %% Calculate the delay between the first and any other angle's signal
    for i = 1:4
        ref(1).delayTimes(i) = finddelay(ref(i).savedData(:,2,1),ref(1).savedData(:,2,1));
    end
    [minDelayRef, minIndexRef] = min(ref(1).delayTimes)

    figure(1)
    for i = 1:4
        delayTime = ref(1).delayTimes(i)/150000; % seconds
        offsetTime = delayTime - (minDelayRef/150000);
        ref(i).adjusted(1).data(:,1) = ref(i).adjusted(1).data(:,1) + offsetTime;                
        plot(ref(i).adjusted(1).data(:,1),ref(i).adjusted(1).data(:,2));
        xlim([0 .1]);
        hold on;
    end
    figure(2)
        for i = 1:4              
        plot(ref(i).savedData(:,1,1),ref(i).savedData(:,2,1));
        xlim([0 .1]);
        hold on;
    end

end