function [ref, exp] = Processing(ref, exp)
%% Find frequency response of each run 
% % Define Fourier Parameters
% L = length(ref(1).adjusted.data(:,1));
% Fs = 150000;
% 
% % Do the thing
% for run = 1:4
%     fourierRef = fft(ref(run).adjusted(1).data(:,2));
%     P2 = abs(fourierRef/L);
%     P1 = P2(1:L/2+1);
%     P1(2:end-1) = 2*P1(2:end-1);
%     f = Fs*(0:(L/2))/L;
%     ref(run).RMSvoltage(:) = P1;
%     ref(run).freq(:) = f;
%     plot(f,P1);
%     hold on;
%     for angle = 2:38
%         fourierExp = fft(exp(run).adjusted(angle).data(:,2));
%         P2 = abs(fourierExp/L);
%         P1 = P2(1:L/2+1);
%         P1(2:end-1) = 2*P1(2:end-1);
%         f = Fs*(0:(L/2))/L;
%         exp(run).RMSvoltage(:) = P1;
%         exp(run).freq(:) = f;
%         plot(f,P1);
%         hold on;
%     end
% end
% 
% title('Single-Sided Amplitude Spectrum of S(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')


%% Spectrogram Method
for i = 2:38
    % spectrogram(data, 
    [s,f,t,p] = spectrogram(exp(1).savedData(:,2,1),tukeywin(256,0.1),60,256,150000);
    [q,nd] = max(10*log10(p));
    plot3(t,f(nd),p);
    xlabel('time')
    ylabel('frequency')
    zlabel('power')
%     hold on
end
plot3(t,f(nd),p);
hold on
ylim([500 15000]);

fr = f(nd)
x1 = t(60);
y1 = fr(60);
x2 = t(170);
y2 = fr(170);

xreg = [ x1 x2 ];
yreg = [ y1 y2 ];
C = polyfit(xreg,yreg,1);
timeReg = linspace(0,1.6,1000);
freqReg = polyval(C,timeReg);
plot(timeReg,freqReg,'k','linewidth',4);
f = f';
[timeGrid,frequencyGrid] = ndgrid(t,f);
p = p';
pInterp = griddedInterpolant(timeGrid,frequencyGrid,p);
powerReg = pInterp(timeReg,freqReg);
plot3(timeReg,freqReg,powerReg,'k','linewidth',4);

end