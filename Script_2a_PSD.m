sampl_freq = 10; % Hz
window_size = 4096;
TWOPI = 2 * pi;

% Compute Power Spectral Density
[pxx, f] = pwelch(psi_w(2,:), window_size, sampl_freq);

% Plot pxx vs. f in a double log plot
plot(log(f.*TWOPI), log(pxx./TWOPI));
grid on;
title('Power Spectral Density - Wave Influence');
xlabel('Frequency log(rad/s)');
ylabel('Power log(s/rad)');