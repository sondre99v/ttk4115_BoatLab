clear;
close all;
addpath('../Common files');

% Constants for Power Spectral Density calculation
sampl_freq = 10; % Hz
window_size = 4096;
TWOPI = 2 * pi;

% Compute Power Spectral Density for wave.mat
load wave.mat;
[pxx, f] = pwelch(psi_w(2,:) .* pi/180, window_size, [],[], sampl_freq);

% Scale from 1/s to rad/s
w = f .* TWOPI;
pxx = pxx ./ TWOPI;

% Find the peak height and location
[peak_value, peak_index] = max(pxx);
w0 = w(peak_index);
sigma = sqrt(peak_value);

% Curve-fit the analytical expression to find lambda
fun = @(x,w)(2*x*w0*sigma)^2.*w.^2./(w.^4+w0^2.*w.^2*(4*x^2-2)+w0^4);
lambda0 = 0.5;
lambda = lsqcurvefit(fun, lambda0, w, pxx);

Kw = 2 * lambda * w0 * sigma;

% Compute Analytical Power Spectral Density
sxx = fun(lambda, w);

% Plot the analytical and measured spectrums
figure;
loglog(w, pxx);
hold on;
loglog(w, sxx);
title('Analytical and measured PSD for the wave influence');
xlabel('Frequency [rad/s]');
ylabel('PSD [power s/rad]');
