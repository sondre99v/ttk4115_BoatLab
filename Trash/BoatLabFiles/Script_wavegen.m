clear;
close all;

TWOPI = 2 * pi;

% Set to true to run a simuling model generating a
% dataset corresponding to equations 13a and 13b.
create_new_wave = false;

if create_new_wave
    Kw_wavegen = 0.4224;
    lambda_wavegen = 0.1000;
    w0_wavegen = 0.7823;

    sim('psi_w_new_model.slx');

    load psi_w_new_time.mat;
else
    load wave.mat;
end

% Parameters for pwelch
sampl_freq = 10; % Hz
window_size = 4096;

% Compute Power Spectral Density of sample data
[pxx, f] = pwelch(psi_w(2,:) .* pi/180, window_size, [],[], sampl_freq);

w = f .* TWOPI;

% Find the peak height and location
[peak_value, peak_index] = max(pxx./TWOPI);

% Resonant frequency is the frequency of the peak
w0 = w(peak_index);
sigma = sqrt(peak_value);

% Curve fitting
fun = @(x,w)(2*x*w0*sigma)^2*w.^2./((w0^2-w.^2).^2+(2*x^2*w0.*w).^2);
lambda0 = 0.5;
lambda = lsqcurvefit(fun, lambda0, w, pxx);

Kw = 2 * lambda * w0 * sigma;

% Compute Analytical Power Spectral Density
sxx = Kw^2 * w.^2 ./ ((w0^2 - w.^2).^2 + (2 * lambda^2 * w0 .* w).^2);

% Plot pxx vs. f in a double log plot
hold on;
plot(log(w), log(sxx./TWOPI));
plot(log(f.*TWOPI), log(pxx./TWOPI));
grid on;
title('Power Spectral Density - Wave Influence');
xlabel('Frequency log(rad/s)');
ylabel('Power log(s/rad)');

