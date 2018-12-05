% function [ref, exp] = Processing(ref, exp)
% %% Spectrogram Method

for angle = 1:38
    % Generate spectrogram data, find location of maximum power
    for run = 1:4
        [s,f,t,p] = spectrogram(exp(run).savedData(:,2,angle),tukeywin(512,0.1),60,512,150000);
        [q,nd] = max(10*log10(p));
        fmax = f(nd);
        L = 1500;
        % Grab two data points to generate line of best fit
        x1 = t(60);
        y1 = fmax(60);
        
        x2 = t(170);
        y2 = fmax(170);
    
        % Calculate line of best fit
        xreg = [ x1 x2 ];
        yreg = [ y1 y2 ];
        C = polyfit(xreg,yreg,1);
        timeReg = linspace(0,1.6,L);
        freqReg = polyval(C,timeReg);
        
        % Interpolate the power along the line of best fit
        f = f';
        p = p';
        [timeGrid,frequencyGrid] = ndgrid(t,f);

        pInterp = griddedInterpolant(timeGrid,frequencyGrid,p);
        powerReg = pInterp(timeReg,freqReg);
        powerReg = 10*log10(powerReg);
        
        % Smooooooothhhhhhhh
        psmooth = smooth(freqReg,powerReg,55);
        
        % Plot 
        subplot(4,1,run);
        plot3(timeReg,freqReg,psmooth,'linewidth',4,'color','k');
        hold on; view(90,0);
        plot3(timeReg,freqReg,powerReg);
        ylim([500 15000]);
        
        xlabel('time');
        ylabel('frequency');
        zlabel('power');
        legend({'Smoothed Data','Raw Data'},'Location','southwest');
        set(gca,'Yscale','log'); 
        grid on;
        hold off;
        
        pause(.5)
        
    end
end