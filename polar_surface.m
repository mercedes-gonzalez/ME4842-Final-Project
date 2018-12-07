% %% MAKE A COOL SURFACE PLOT
% % z is frequency
% % theta is theta
% % R is amplitude
% theta = totalTheta;
% theta = fliplr(theta);
% z = linspace(15000,500,59);
% 
% [TH,Z] = ndgrid(theta,z);
% 
% for th = length(theta(1,:)):-1:1
%     for f = 59:-1:1
%         FR(th,f) = polar(1).data(f).asmooth(th);
%     end
% end
% 
% FR = flip(FR,1);
% FR = flip(FR,2);
% TH = flip(TH,1);
% Z = flip(Z,2);
% 
% freqInterp = griddedInterpolant(TH,Z,FR);
% R = freqInterp(TH,Z);
% [x,y,z] = pol2cart(TH,R,Z);
% 
% surf(x,y,z,'FaceColor','interp','FaceLighting','gouraud');
% colorbar

refff = [0 2 2.5 4.5 5 4.5 3 2 4 4.5];
x = linspace(1000,10000,10);

pwr = interp1(ref(1).freq(1).reg,ref(1).power(1).smooth,x);
error = (pwr - refff)./refff;

exp(1).power(1).smooth = ref(1).power(1).smooth + abs(pwr(1));
pwr = pwr + abs(pwr(1));
plot(ref(1).freq(1).reg,ref(1).power(1).smooth,'b');
hold on;
plot(x,refff,'r')
scatter(x,refff,'k');
scatter(x,pwr);
xlim([1000 10000])
% 
% 
% boxplot(percent)