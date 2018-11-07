%% D_I_DESIGN
%
% Designs the integral (I) gain for the SRV02 position controller based
% on the previously designed proportional gain, the maximum controller
% voltage, and the integral time.
%
% ************************************************************************
% Input paramters:
% AmpMmax   Maximum control voltage or current      (V or A)
% kp        Proportional gain found in PV design.   (V/rad or A/rad)
% e_ss      Steady-state error with PV control.     (rad)
% ti        Integral time.                          (s)
%
% ************************************************************************
% Output parameters:
% ki        Integral control gain                   (V/rad/s or A/rad/rs)
%
% Copyright (C) 2010 Quanser Consulting Inc.
% Quanser Consulting Inc.
%%
%
function [ ki ] = d_i_design( AmpMax, kp, e_ss, ti)
    % Integral gain calculation
    ki = -( -AmpMax + kp * e_ss ) / ti / e_ss;
end