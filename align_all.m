function [ref,exp] = align_all(ref,exp,min)
%% Deconstruct
minIndexRef = min.minIndexRef;
minRunExpFinal = min.minRunExpFinal;
minAngleExpFinal = min.minAngleExpFinal;
minDelayTimeExpFinal = min.minDelayTimeExpFinal;

%% Find delay time
masterDelayTime = finddelay(ref(minIndexRef).adjusted(1).data(:,2),exp(minRunExpFinal).adjusted(minAngleExpFinal).data(:,2))

%% Align Reference
    for i = 1:4
        delayTime = ref(1).delayTimes(i)/150000; % seconds
        offsetTime = delayTime - (masterDelayTime/150000);
        ref(i).adjusted.data(:,1) = ref(i).adjusted.data(:,1) - offsetTime;                
    end

%% Align Experimental
    for i = 1:4
        for angle = 1:38
            delayTime = exp(i).delayTimes(angle)/150000; % seconds
            offsetTime = delayTime - (masterDelayTime/150000);
            exp(i).adjusted(angle).data(:,1) = exp(i).adjusted(angle).data(:,1) - offsetTime;                
        end
    end

%     plot(exp(3).adjusted(9).data(:,1),exp(3).adjusted(9).data(:,2),'r');
%     hold on;
%     plot(exp(3).adjusted(29).data(:,1),exp(3).adjusted(29).data(:,2),'b');
end