clc
clear variables

f_samp = 150000; %sampling rate
f_min = 20; %high pass
f_min_n = f_min/(f_samp/2); %normalized
f_max = 20000; %low pass
f_max_n = f_max/(f_samp/2); %normalized

for i = 4:-1:1
ref(i) = load(strcat('Data\Project Data\reference_',num2str(i),'_workspace.mat'),...
    'measuredTheta', 'outputSignal1', 'savedData', 'time', 'triggerTime');
end;

for i = 4:-1:1
exp(i) = load(strcat('Data\Project Data\run_',num2str(i),'_workspace.mat'),...
    'measuredTheta', 'outputSignal1', 'savedData', 'time', 'triggerTime');
end;

%%
%Lowpass = l
for i = 1:4
exp_l(i).savedData=lowpass(exp(i).savedData,f_max,f_samp);
end


smoothed = medfilt1(ref(1).savedData)
for i = 1:1000
    smoothed = medfilt1(smoothed);
end

plot(smoothed)
hold on;
plot(ref(1).savedData)
hold off;

% I think we need to swap columns 1 and 2 of all the data.savedData or specify column 2 somehow;
% fft may be operating on first column - MR
Y=fft(data(2).savedData(:,2)) 
L=40001
Fs=40000

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%%
%Making the low-pass filter
n = 8191; % order
dp = 0.00001; %deviation from passband	
ds = 0.00005; %deviation from stopband
wt = 17000/(f_samp/2);
h2 = fircls1(n,f_max_n,dp,ds,wt);
fvtool(h2,1)

for i = 4:-1:1
ref(i) = load(strcat('Data\Project Data\reference_',num2str(i),'_workspace.mat'),...
    'measuredTheta', 'outputSignal1', 'savedData', 'time', 'triggerTime');
end;

% xzp = vertcat(ref(1).savedData,zeros(22144, 2));
% hzp = [h zeros(1,253951)];

y = xzp .* hzp;

y = ifft(y);
relrmserr = norm(imag(y))/norm(y) % check... should be zero
y = real(y);

plot(xzp)
hold on;
plot(hzp)



 L=262144;
 N=18;
 fy=fft(hzp,2^N)/(L/2);
 f=(150000/2^N)*(0:2^(N-1)-1);
 figure, plot(f,abs(fy(1:2^(N-1))));

hold off;
plot(fft(xzp))
hold on;
plot (fft(hzp))

%%
% Fs = 150000;            % Sampling frequency                    
% T = 1/Fs;             % Sampling period       
% L = 262144;             % Length of signal
% t = (0:L-1)*T;        % Time vector
% % clf
%  for i = 1:4
%     hold on
% 
% X(:,1,i) = exp(i).adjusted(1).data(:,2);
% % Y = shiftfft(10000*X,L/2);
% % P2 = abs(Y/L);
% % P1 = P2(1:end);
% % P1(2:end-1) = 2*P1(2:end-1);
% % f = Fs*(0:(L/2))/L;
% % plot(f(1:1000),P1(1:1000))
% end
% % xlabel('f (Hz)')
% % ylabel('|P1(f)|')
% 
% X = mean(X,3);
% 
% 
% fs = 150000;               % sampling frequency
% t = 0:(1/fs):(10-1/fs); % time vector
% n = length(X);
% X = fft(X);
% f = (0:n-1)*(fs/n);     %frequency range
% power = abs(X).^2/n;    %power
% Y = fftshift(X);
% fshift = (-n/2:n/2-1)*(fs/n); % zero-centered frequency range
% powershift = abs(Y).^2/n;     % zero-centered power
% plot(fshift,powershift)


clf
fs = 150000;
% load an audio file
x = exp(i).adjusted(1).data(:);   % get the first channel
% define analysis parameters
%%%THESE ARE NOT THE CORRECT PARAMETERS%%%
wlen = 4096;                        % window length (recomended to be power of 2)
hop = wlen/4;                       % hop size (recomended to be power of 2)
nfft = 16384;                        % number of fft points (recomended to be power of 2)
% perform STFT
win = blackman(wlen, 'periodic');
[S, f, t] = STFFT(x, win, hop, nfft, fs);
% calculate the coherent amplification of the window
C = sum(win)/wlen;
% take the amplitude of fft(x) and scale it, so not to be a
% function of the length of the window and its coherent amplification
S = abs(S)/wlen/C;
% correction of the DC & Nyquist component
if rem(nfft, 2)                     % odd nfft excludes Nyquist point
    S(2:end, :) = S(2:end, :).*2;
else                                % even nfft includes Nyquist point
    S(2:end-1, :) = S(2:end-1, :).*2;
end
% convert amplitude spectrum to dB (min = -120 dB)
S = 20*log10(S + 1e-6);
% plot the spectrogram
figure(1)
surf(t, f, S)
shading interp
axis tight
view(0, 90)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Time, s')
ylabel('Frequency, Hz')
title('Amplitude spectrogram of the signal')
hcol = colorbar;
set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)
ylabel(hcol, 'Magnitude, dB')


%for all f below 20k Hz, find max S, plot it. Done!
