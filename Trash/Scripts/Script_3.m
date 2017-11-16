clear;
close all;

% Nomoto constants
K = 0.1560;
T = 72.47; % seconds

% PD regulator parameters
Tf = 8.406;
Td = T;
Kpd = 0.8370;

H0 = tf(K * Kpd, [Tf 1 0]);

margin(H0);

sim('ship.mdl');

load 3b_rudder.mat;
load 3b_angle.mat;

t = delta(1,:);
delta = delta(2,:);
psi = psi(2,:);

% Plot rudder angle and heading
figure;
plot(t, delta);
grid on;
title('Rudder angle - PD regulator with measurement noise and wave disturbance');
xlabel('Simulation Time [s]');
ylabel('Rudder Angle [deg]');

figure;
plot(t, psi);
grid on;
title('Heading - PD regulator with measurement noise and wave disturbance');
xlabel('Simulation Time [s]');
ylabel('Heading [deg]');

% Calculate statistics for the rudder and heading
sample_time = 10; % Hz
transient_time = 500; % second
skip = transient_time * sample_time;

delta_mean = mean(delta(skip:end));
delta_std = std(delta(skip:end));

psi_mean = mean(psi(skip:end));
psi_std = std(psi(skip:end));

