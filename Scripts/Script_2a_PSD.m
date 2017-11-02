clear;

load wave.mat;
sampl_freq = 10; % Hz
window_size = 4096;
TWOPI = 2 * pi;

% Compute Power Spectral Density
[pxx, f] = pwelch(psi_w(2,:) .* pi/180, window_size, [],[], sampl_freq);

w = f .* TWOPI;

% Find the peak height and location
[pxx_max, pxx_max_index] = max(pxx./TWOPI);
w0 = w(pxx_max_index);

lambda = 0.3;
K_w = 2 * lambda * w0 * sqrt(pxx_max);

% Compute Analytical Power Spectral Density
sxx = K_w^2 * w.^2 ./ ((w0^2 - w.^2).^2 + (2 * lambda^2 * w0 .* w).^2);


% Plot pxx vs. f in a double log plot
hold on;
plot(log(w), log(sxx./TWOPI));
plot(log(f.*TWOPI), log(pxx./TWOPI));
grid on;
title('Power Spectral Density - Wave Influence');
xlabel('Frequency log(rad/s)');
ylabel('Power log(s/rad)');

