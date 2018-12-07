%% GENERATE COOL AF POLAR PLOTS
warning('off','all')

% for run = 4:-1:1
    inputTheta = exp(run).inputTheta;
    inputTheta(end+1) = pi;
    inputTheta(1:2) = [];
    inputTheta = abs(inputTheta);
    run = 1;
    fdesired = 500;    
    for f = 59:-1:1
        % Create amplitude array of 36 angles
        for angle = 38:-1:1
            amplitude(angle) = interp1(exp(run).freq(angle).reg,exp(run).power(angle).reg,fdesired);
        end
        amplitude(end+1) = .5*(amplitude(end-1)+amplitude(end));
        amplitude(1:2) = [];

        
        % Create full 360 degree array for theta
        rTheta = pi + inputTheta;
        totalTheta = horzcat(inputTheta, rTheta);

        % Create full 360 degree array for amplitude
        rAmplitude = fliplr(amplitude);
        totalAmplitude = horzcat(amplitude,rAmplitude);

        % Smoooothhhhhh
        asmooth = smooth(totalTheta,totalAmplitude,9);

        % Plot
        polarplot(totalTheta,totalAmplitude);
        hold on;
        polarplot(totalTheta,asmooth,'linewidth',3);
        hold on;
%         polarplot(totalTheta,asmooth);
        title(fdesired);
        rlim([-60 5]); 
        fdesired = fdesired + 250;
        pause(.1);
        shg;
        
        hold off;
        % Store it in workspace
        polar(run).data(f).theta = totalTheta;
        polar(run).data(f).amplitude = totalAmplitude;
        polar(run).data(f).asmooth = asmooth;
    end
% end


