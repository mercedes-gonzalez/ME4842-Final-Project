%% D_PV_DESIGN
%
% Designs a proportional-velocity (PV) position controller for the SRV02 
% plant based on the desired overshoot and peak time specifications.
%
% ************************************************************************
% Input paramters:
% K         Model steady-state gain                 (rad/s/V)
% tau       Model time constant                     (s)
% PO        Percentage overshoot specification      (%)
% tp        Peak time specifications                (s)
% AMP_TYPE  Type of amplifier (e.g. Q3)
%
% ************************************************************************
% Output parameters:
% kp        Proportional gain                       (V/rad)
% kv        Velocity gain                           (V.s/rad)
%
% Copyright (C) 2010 Quanser Consulting Inc.
% Quanser Consulting Inc.
%%
%
function [ kp, kv ] = d_pv_design( K, tau, PO, tp, AMP_TYPE )
    % Damping ratio from overshoot specification.
    zeta = -log(PO/100) * sqrt( 1 / ( ( log(PO/100) )^2 + pi^2 ) );
    % Natural frequency from specifications (rad/s)
    wn = pi / ( tp * sqrt(1-zeta^2) );
    %
    if strcmp(AMP_TYPE,'Q3')        
        % Proportional gain (V/rad)
        kp = wn^2/K;
        % Velocity gain (V.s/rad)
        kv = 2*zeta*wn/K;
    else
        % Proportional gain (V/rad)
        kp = wn^2/K*tau;
        % Velocity gain (V.s/rad)
        kv = (-1+2*zeta*wn*tau)/K;
    end        
end