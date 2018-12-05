%% GENERATE COOL AF POLAR PLOTS
warning('off','all')
for run = 4:-1:1
    inputTheta = exp(run).inputTheta;
    % inputTheta(39) = pi;
    inputTheta(1:2) = [];

    fdesired = 500;    
    for f = 50:-1:1
        % Create amplitude array of 36 angles
        for angle = 38:-1:1
            amplitude(angle) = interp1(exp(run).freq(angle).reg,exp(run).power(angle).reg,fdesired);
        end
    %     amplitude(39) = .5*(amplitude(end-1)+amplitude(end));
        amplitude(1:2) = [];

        % Create full 360 degree array for theta
        rTheta = abs(fliplr(inputTheta));
        totalTheta = horzcat(rTheta,inputTheta);

        % Create full 360 degree array for amplitude
        rAmplitude = fliplr(amplitude);
        totalAmplitude = horzcat(rAmplitude,amplitude);

        % Smoooothhhhhh
        asmooth = smooth(totalTheta,totalAmplitude,11);

        % Plot
        polarplot(totalTheta,totalAmplitude,'-o');
        hold on;
        polarplot(totalTheta,asmooth,'r-o');
        legend('og data','smoothed');
        rlim([-100 0]);
        fdesired = fdesired + 250;
        hold off;
        fdesired
        pause(.1)

        % Store it in workspace
        polar(run).data(f).theta = totalTheta;
        polar(run).data(f).amplitude = totalAmplitude;
    end
end



