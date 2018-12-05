%% FREQUENCY RESPONSE GENERATION
warning('off','all')

% %% REFERENCE
% for run = 4:-1:1
%     % Extract frequency response from spectrogram
%     [s,f,t,p] = spectrogram(ref(run).adjusted(1).data(:,2),tukeywin(1024,0.1),60,1024,150000);
%     [q,nd] = max(10*log10(p));
%     fmax = f(nd);
% 
%     % Grab two data points to generate line of best fit
%     x1 = t(60);
%     y1 = fmax(60);
% 
%     x2 = t(170);
%     y2 = fmax(170);
% 
%     % Calculate line of best fit
%     xreg = [ x1 x2 ];
%     yreg = [ y1 y2 ];
%     C = polyfit(xreg,yreg,1);
%     timeReg = linspace(0,1.6,2000);
%     freqReg = polyval(C,timeReg);
% 
%     % Interpolate the power along the line of best fit
%     f = f';
%     p = p';
%     [timeGrid,frequencyGrid] = ndgrid(t,f);
% 
%     pInterp = griddedInterpolant(timeGrid,frequencyGrid,p);
%     powerReg = pInterp(timeReg,freqReg);
%     powerReg = 10*log10(powerReg);
% 
%     % Smooooooothhhhhhhh 
%     % 3rd argument increases amount of smoothing 
%     psmooth = smooth(freqReg,powerReg,75);
%     psmooth = psmooth'; 
% 
%     % Plot frequency reponse on subplots
%     subplot(4,1,run);
%     plot3(timeReg,freqReg,psmooth,'linewidth',4,'color','k');
%     hold on; grid on; view(90,0); ylim([20 20000]);
%     plot3(timeReg,freqReg,powerReg);
%     xlabel('time');
%     zlabel('amplitude');
%     if run == 4
%         ylabel('frequency');
%     end
%     legend({'Smoothed Data','Raw Data'},'Location','southwest');
%     set(gca,'Yscale','log'); 
%     hold off;
% 
%     pause(0.25)
% 
%     % Save data to workspace
%     ref(run).time(1).reg = timeReg;
%     ref(run).freq(1).reg = freqReg;
%     ref(run).power(1).smooth = psmooth;
%     ref(run).power(1).reg = powerReg;
% end

% %% Averaging of Reference Data
% timeArray = ref(1).power(1).reg + ref(2).power(1).reg + ref(3).power(1).reg + ref(4).power(1).reg;
% ref(5).time(1).reg = mean(timeArray)

%% EXPERIMENTAL find max line and use the same line for each run
angle = 1;
run = 1;
% [s,f,t,p] = spectrogram(x,window,noverlap,f,fs)
%         [s,f,t,p] = spectrogram(exp(run).adjusted(angle).data(:,2),tukeywin(256,.1),30,linspace(500,15000,256),150000);
    [s,f,t,p] = spectrogram(exp(run).savedData(:,2,angle),tukeywin(512,.1),60,512,150000);
    [q,nd] = max(10*log10(p));
    
    % Remove undesired data
    fmax = f(nd);
    rm1 = fmax(:,1) > 30000;
    rm2 = fmax(:,1) < 50;
    rm3 = or(rm1,rm2);
    fmax(rm3) = [];
    t(rm3) = [];
    q(rm3) = [];
    p(:,rm3) = [];

    % Grab two data points to generate line of best fit
    x1 = t(60);
    y1 = fmax(60);

    x2 = t(170);
    y2 = fmax(170);

    % Calculate line of best fit
    xreg = [ x1 x2 ];
    yreg = [ y1 y2 ];
    C = polyfit(xreg,yreg,1);
    timeReg = linspace(0,1.6,1500);
    freqReg = polyval(C,timeReg);

    % Interpolate the power along the line of best fit
    f = f';
    p = p';
    [timeGrid,frequencyGrid] = ndgrid(t,f);

    pInterp = griddedInterpolant(timeGrid,frequencyGrid,p);
    powerReg = pInterp(timeReg,freqReg);
    powerReg = 10*log10(powerReg);

    % Smooooooothhhhhhhh 
    % 3rd argument increases amount of smoothing 
    psmooth = smooth(freqReg,powerReg,95);
    psmooth = psmooth'; 

    % Plot frequency reponse on subplots
    subplot(4,1,run);
    plot3(timeReg,freqReg,psmooth,'linewidth',4,'color','k'); hold off
    hold on; grid on; view(90,0); ylim([20 20000]);
    plot3(timeReg,freqReg,powerReg);
    xlabel('time');
    zlabel('amplitude');
    if run == 4
        ylabel('frequency');
    end
    legend({'Smoothed Data','Raw Data'},'Location','southwest');
    set(gca,'Yscale','log'); 
    title(strcat('Angle = ',num2str(angle)));

    pause(.25)
    hold off;

    exp(run).inputTheta(angle) = deg2rad(exp(run).measuredTheta(angle)- 90);

    % Save data to workspace
    exp(run).time(angle).reg = timeReg;
    exp(run).freq(angle).reg = freqReg;
    exp(run).power(angle).smooth = psmooth;
    exp(run).power(angle).reg = powerReg;


for angle = 2:38
    for run = 4:-1:1
        % [s,f,t,p] = spectrogram(x,window,noverlap,f,fs)
%         [s,f,t,p] = spectrogram(exp(run).adjusted(angle).data(:,2),tukeywin(256,.1),30,linspace(500,15000,256),150000);
        [s,f,t,p] = spectrogram(exp(run).savedData(:,2,angle),tukeywin(512,.1),30,512,150000);

        % Interpolate the power along the line of best fit
        f = f';
        p = p';
        [timeGrid,frequencyGrid] = ndgrid(t,f);

        pInterp = griddedInterpolant(timeGrid,frequencyGrid,p);
        powerReg = pInterp(timeReg,freqReg);
        powerReg = 10*log10(powerReg);

        % Smooooooothhhhhhhh 
        % 3rd argument increases amount of smoothing 
        psmooth = smooth(freqReg,powerReg,95);
        psmooth = psmooth'; 

        % Plot frequency reponse on subplots
        subplot(4,1,run);
        plot3(timeReg,freqReg,psmooth,'linewidth',4,'color','k'); hold off
        hold on; grid on; view(90,0); ylim([20 20000]);
        plot3(timeReg,freqReg,powerReg);
        xlabel('time');
        zlabel('amplitude');
        if run == 4
            ylabel('frequency');
        end
        legend({'Smoothed Data','Raw Data'},'Location','southwest');
        set(gca,'Yscale','log'); 
        title(strcat('Angle = ',num2str(angle)));

        pause(.25)
        hold off;
        
        exp(run).inputTheta(angle) = deg2rad(exp(run).measuredTheta(angle)- 90);

        % Save data to workspace
        exp(run).power(angle).smooth = psmooth;
        exp(run).power(angle).reg = powerReg;
    end
end