
fourierData = fft(data);
L = length(data);
Fs = 150000;
P2 = abs(fourierData/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

figure(1)
plot(f,P1)

title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

figure(2)
spectrogram(data,128,120,128,150000,'yaxis')