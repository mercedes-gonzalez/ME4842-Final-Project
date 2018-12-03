function plot_things(ref,exp)
    %% Align references
    figure(1)
    for i = 1:4
        plot(ref(i).adjusted(1).data(:,1),ref(i).adjusted(1).data(:,2));
        title('Reference Aligned');
        hold on;
        xlim([0 .1]);
    end
    figure(2)
    for i = 1:4              
        plot(ref(i).savedData(:,1,1),ref(i).savedData(:,2,1));
        title('Reference Saved');
        hold on;
        xlim([0 .1]);
    end
    
    %% Align Experimentals
    figure(3)
    for i = 1:4
        for angle = 2:38
            plot(exp(i).savedData(:,1,angle),exp(i).savedData(:,2,angle));
            hold on
            title('Experimental Saved');
            xlim([0 .1]);
        end
    end

    figure(4)
    for i = 1:4
        plot(ref(i).adjusted(1).data(:,1),ref(i).adjusted(1).data(:,2))
        hold on
        for angle = 2:38
            plot(exp(i).adjusted(angle).data(:,1),exp(i).adjusted(angle).data(:,2))
            xlim([0 .1]);
            title('All Adjusted Data');
        end
    end
end