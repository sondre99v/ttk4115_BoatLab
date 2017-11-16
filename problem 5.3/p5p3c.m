clear;
close all;
addpath('../Common files');

% Model constants
T = 72.4637;
K = 0.1561;

% PD regulator parameters, manually tuned to achieve
% the desired phase margin and crossing frequency
Tf = 8.402;
Td = T;
Kpd = 0.8370;

sim('p5p3c_model.mdl');

t = get(simout_compass, 'time');
delta = get(simout_delta, 'data');
psi = get(simout_compass, 'data');

% Plot rudder angle and heading
figure('pos',[100 100 600 500]);
subplot(2,1,1);
plot(t, delta);
grid on;
title('Rudder angle - PD regulator with measurement noise and current');
xlabel('Simulation Time [s]');
ylabel('Rudder Angle [deg]');

subplot(2,1,2);
plot(t, psi);
grid on;
title('Heading - PD regulator with measurement noise and current');
xlabel('Simulation Time [s]');
ylabel('Heading [deg]');

% Calculate statistics for the rudder and heading
sample_time = 10; % Hz
transient_time = 400; % second
skip = transient_time * sample_time;

delta_mean = mean(delta(skip:end));
delta_std = std(delta(skip:end));

psi_mean = mean(psi(skip:end));
psi_std = std(psi(skip:end));

