%% D_E_SS_RAMP_PV
%
% Calculate the steady-state error when tracking a ramp reference using a
% PV controller.
%
% ************************************************************************
% Input paramters:
% R0        Ramp slope.                             (rad/s)
% kp        Proportional gain                       (V/rad)
% kv        Velocity gain                           (V.s/rad)
% K         Model steady-state gain                 (rad/s/V)
%
% ************************************************************************
% Output parameters:
% e_ss      Ramp steady-state error using PV        (V/rad/s)
%
% Copyright (C) 2010 Quanser Consulting Inc.
% Quanser Consulting Inc.
%%
%
function [ e_ss ] = d_e_ss_ramp_pv (R0, kp, kv, K);
   e_ss = R0 * ( 1 + K*kv ) / K / kp;
end