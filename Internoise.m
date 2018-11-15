%inverse sweep

t = 0:0.00000666666:1; % Seconds
s_t = chirp(t,50,1,15000); %inverse of output signal
for i = 1:150001;
    s_t(i)=1/s_t(i);
end
s_t = (s_t)';
s_t = vertcat(s_t,ones(112143,1));
%s_t = horzcat(ones(262144,1),s_t);



    %%calc u_t for exp
    for i = 4:-1:1
        for angle = 38:-1:1
            exp(i).u_t(:,:,angle) = exp(i).adjusted(angle).data(:,2) .* s_t;
            exp(i).h_t(:,:,angle) = ifft(exp(i).adjusted(angle).data(:,2));
            exp(i).h_t(:,:,angle) = exp(i).h_t(:,:,angle) .* s_t;
            exp(i).H_f(:,:,angle) = fft(exp(i).h_t(:,:,angle));

        end
    end
    
    
        %%calc u_t for references
    for i = 4:-1:1
            ref(i).u_t(:,:,angle) = ref(i).adjusted(angle).data(:,2) .* s_t;
            ref(i).h_t(:,:,angle) = ifft(ref(i).adjusted(angle).data(:,2));
            ref(i).h_t(:,:,angle) = ref(i).h_t(:,:,angle) .* s_t;
            ref(i).H_f(:,:,angle) = fft(ref(i).h_t(:,:,angle)');

    end
    
%to make things official, the first column of the above should be zeta =
%t*k, where k is the chirpiness of the signal

    hold on;

L=length(exp(i).H_f(1,:,angle));        
NFFT=262144;       
X=fft(exp(i).H_f(1,:,angle),NFFT);       
Px=X.*conj(X)/(NFFT*L); %Power of each freq components       
fVals=150000*(0:NFFT/2-1)/NFFT;      
plot(fVals,Px(1:NFFT/2),'b','LineWidth',1);         
title('One Sided Power Spectral Density');       
xlabel('Frequency (Hz)')         
ylabel('PSD');