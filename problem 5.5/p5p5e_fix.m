clear;
close all;
addpath('../Common files');

% Model constants
T = 72.4637;
K = 0.1561;
w0 = 0.7823;
lambda = 0.0855;
Kw = 0.0051526;

% PD regulator parameters
Tf = 8.402;
Td = T;
Kpd = 0.8370;

% Sample time for discretization
Ts = 0.1; %[s]


% Define matrices for the continous time model
A = [
    0       1               0       0       0;
    -w0^2	-2*lambda*w0    0       0       0;
    0       0               0       1       0;
    0       0               0       -1/T    -K/T;
    0       0               0       0       0
    ];

B = [0; 0; 0; K/T; 0];

C = [0 1 1 0 0];

E = [
    0   0;
    Kw  0;
    0   0;
    0   0;
    0   1
    ];

Q = [
    30 0;
    0 10^-6
    ];

R = 0.002;

% Discretisation
[Ad, Bd] = c2d(A, B, Ts);
[~, Ed] = c2d(A, E, Ts);

% Loans method
loan_exponent = [...
    A           E * Q * E';
    zeros(5)    -A'
    ];

loan_m = expm(loan_exponent * Ts);
Qd = loan_m(1:5, 6:10) * loan_m(1:5, 1:5)';
Rd = R / Ts;

% Setup initial conditions for the kalman filter
data.A = Ad;
data.B = Bd;
data.C = C;
data.R = Rd;
data.Q = Qd;
data.E = Ed;

data.Pm0 = [
    1  0      0     0  0;
    0  0.013  0     0  0;
    0  0      pi^2  0  0;
    0  0      0     1  0;
    0  0      0     0  2.5*10^-3];

% Run the simulink model
sim('p5p5e_model_fix.mdl');


% Plot results
figure('pos',[100 100 600 700]);
subplot(2,1,1);
hold on;
grid on;
plot(simout_heading);
plot(simout_est_heading);
title('Measured and estimated ship heading with corrected wave influence');
xlabel('Simulation Time [s]');
ylabel('Heading [deg]');
legend('Measured', 'Estimated', 'Location', 'southeast');

subplot(2,1,2);
hold on;
grid on;
plot(simout_rudder);
plot(simout_est_bias);
title('Rudder angle, and estimated rudder bias with corrected wave influence');
xlabel('Simulation Time [s]');
ylabel('Angle [deg]');
legend('Rudder angle', 'Bias');

% Plot estimated and actual wave influence
figure('pos',[100 100 800 300]);
hold on;
wave_plot_end = 200;
plot(simout_wave_infl.time(1:wave_plot_end/Ts), ...
    simout_wave_infl.data(1:wave_plot_end/Ts));
plot(simout_est_wave_infl.time(1:wave_plot_end/Ts), ...
    simout_est_wave_infl.data(1:wave_plot_end/Ts));
title('Actual, and estimated wave influence with corrected wave influence');
xlabel('Simulation Time [s]');
ylabel('Wave Influence [deg]');
legend('Actual', 'Estimated');