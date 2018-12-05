%% MAKE A COOL SURFACE PLOT
% z is frequency
% theta is theta
% R is amplitude
theta = totalTheta;
z = linspace(15000,500,50);

[TH,Z] = ndgrid(theta,z);

for th = 72:-1:1
    for f = 50:-1:1
        FR(th,f) = polar(1).data(f).amplitude(th);
    end
end
FR(37,:) = [];
TH(37,:) = [];
Z(37,:)= [];

FR = flip(FR,1);
FR = flip(FR,2);
TH = flip(TH,1);
Z = flip(Z,2);
freqInterp = griddedInterpolant(TH,Z,FR,'spline');
R = freqInterp(TH,Z);

[x,y,z] = pol2cart(TH,R,Z);

% for rows = 71:-1:1
%         zsmooth(rows,:) = smooth(x(rows,:),z(rows,:),11);
% end

surf(x,y,z,'FaceAlpha',0.5,'FaceColor','interp','FaceLighting','gouraud');
colorbar