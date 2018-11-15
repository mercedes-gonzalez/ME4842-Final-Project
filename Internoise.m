%inverse sweep

t = 0:0.00000666666:1; % Seconds
u_t = chirp(t,50,1,15000).^-1; %inverse of output signal
u_t = u_t'
u_t = vertcat(u_t,zeros(112143,1));
u_t = horzcat(ones(262144,1),u_t);



    %%calc u_t for exp
    for i = 4:-1:1
        for angle = 38:-1:1
            exp(i).ut(:,:,angle) = exp(i).adjusted(angle).data .* u_t;
        end
    end
    
    
        %%calc u_t for references
    for i = 4:-1:1
            ref(i).ut(:,:,angle) = ref(i).adjusted(angle).data .* u_t;
    end
    
        %%calc u_kt for exp
    for i = 4:-1:1
        for angle = 38:-1:1
            exp(i).kt(:,:,angle) = exp(i).adjusted(angle).data .* u_t;
        end
    end
    
    
        %%calc u_kt for references
    for i = 4:-1:1
            ref(i).kt(:,:,angle) = ref(i).adjusted(angle).data .* u_t;
    end
    