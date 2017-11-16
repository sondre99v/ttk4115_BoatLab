clear;
close all;
addpath('../Common files');

sample_time = 0.1;
w1 = 0.005;
w2 = 0.05;

% Simulate model without disturbances with frequency 0.005
sine_freq = w1;
sim('p5p1c_model.mdl');

% Calculate amplitude
compass = get(simout_compass, 'data');
maximum = max(compass(length(compass) / 2 : end));
minimum = min(compass(length(compass) / 2 : end));

A1 = (maximum - minimum) / 2;

% Plot response
figure;
hold on;
plot(simout_compass);
plot(simout_delta);
maxline = refline(0, maximum);
minline = refline(0, minimum);
maxline.LineStyle = '--';
minline.LineStyle = '--';
maxline.Color = [0.7 0.7 0.7];
minline.Color = [0.7 0.7 0.7];
title('Sine response with freq = 0.005 and noise');
xlabel('Time [s]');
ylabel('Compass Heading / Rudder [deg]');
legend('Compass Heading', 'Rudder angle');

% Simulate model without disturbances with frequency 0.05
sine_freq = w2;
sim('p5p1c_model.mdl');

% Calculate amplitude
compass = get(simout_compass, 'data');
maximum = max(compass(length(compass) / 2 : end));
minimum = min(compass(length(compass) / 2 : end));

A2 = (maximum - minimum) / 2;

% Plot response
figure;
hold on;
plot(simout_compass);
plot(simout_delta);
maxline = refline(0, maximum);
minline = refline(0, minimum);
maxline.LineStyle = '--';
minline.LineStyle = '--';
maxline.Color = [0.7 0.7 0.7];
minline.Color = [0.7 0.7 0.7];
title('Sine response with freq = 0.05 and noise');
xlabel('Time [s]');
ylabel('Compass Heading / Rudder [deg]');
legend('Compass Heading', 'Rudder angle');

