function [exp,minDelayTimeExpFinal,minRunExpFinal,minAngleExpFinal] = align_and_trim(exp)
    for i = 1:4
        %% Trim savedData to 0 --> 1.5 seconds lol
        exp(i).savedData(240001:end,:,:) = [];
        exp(i).time(240001:end,:) = [];
        exp(i).outputSignal1(240001:end,:) = [];
    end
    
    for i = 1:4
        %% Calculate the delay between the first and any other angle's signal
        for angle = 1:38
            exp(i).delayTimes(angle) = finddelay(exp(i).savedData(:,2,angle),exp(i).savedData(:,2,1));
        end
    [minDelayTimeperRun(i), angleofMinDelayperRun(i)] = min(exp(i).delayTimes)
    end
    [minDelayTimeExpFinal,minRunExpFinal] = min(minDelayTimeperRun)
    minAngleExpFinal = min(angleofMinDelayperRun)
    for i = 1:4
        for angle = 1:38
            delayTime = exp(i).delayTimes(angle)/150000; % seconds
            offsetTime = delayTime - (minDelayTimeExpFinal/150000);
            exp(i).adjusted(angle).data(:,1) = exp(i).adjusted(angle).data(:,1) - offsetTime;                
        end
    end
%     i = 2;
%     angle = 29;
%     plot(exp(i).adjusted(angle).data(:,1),exp(i).adjusted(angle).data(:,2),'r')
%     hold on
%     plot(exp(i).adjusted(2).data(:,1),exp(i).adjusted(2).data(:,2),'b')

%     scatter(exp(i).savedData(:,1,angle),exp(i).savedData(:,2,angle),'b','.');
%     title('angle 29');

end