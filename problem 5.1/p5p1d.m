clear;
close all;
addpath('../Common files');

% Model constants
T = 72.4637;
K = 0.1561;


% Simulate model without disturbances with a step input
sample_time = 0.1;
sim('p5p1d_model.mdl');

sim_time = get(simout_compass, 'time');
model = @(t) K*T*(exp(-t/T) - 1) + K*t;

% Plot response
figure;
hold on;
plot(simout_compass);
plot(sim_time, model(sim_time));
title('Step response to 1 deg step');
xlabel('Time [s]');
ylabel('Compass Heading [deg]');
legend('Ship', 'Model', 'Location', 'northwest');
