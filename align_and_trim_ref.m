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

    for i = 1:4
        delayTime = ref(1).delayTimes(i)/150000; % seconds
        offsetTime = delayTime - (minDelayRef/150000);
        ref(i).adjusted(1).data(:,1) = ref(i).adjusted(1).data(:,1) - offsetTime;                
    end
%     figure
%     plot(ref(minIndexRef).adjusted(1).data(:,1),ref(minIndexRef).adjusted(1).data(:,2),'r');
%     hold on
%     plot(ref(minIndexRef).savedData(:,1,1),ref(minIndexRef).savedData(:,2,1),'b');
%     plot(ref(1).adjusted(1).data(:,1),ref(1).adjusted(1).data(:,2));
%     plot(ref(1).savedData(:,1,1),ref(1).savedData(:,2,1),'k');
% 
%     legend('Reference Adjusted','Saved Adjusted','Adjusted 1','Saved 1');
%     xlim([0 1]);

end