clear;

K_w_model = 0.0181 * 2^4 / 0.8913 * 1.3;
lambda_model = 0.1;
w0_model = 0.7823;

sim('psi_w_new_model.slx');


clear;

load psi_w_new_time.mat;
sampl_freq = 10; % Hz
window_size = 4096;
TWOPI = 2 * pi;

% Compute Power Spectral Density
[pxx, f] = pwelch(psi_w(2,:) .* pi/180, window_size, [],[], sampl_freq);

w = f .* TWOPI;

% Find the peak height and location
pxx_max = log(max(pxx./TWOPI));
%w0 = w(pxx_max_index);

%lambda = 0.1;
%K_w = 2 * lambda * w0 * sqrt(pxx_max);

% Compute Analytical Power Spectral Density
%sxx = K_w^2 * w.^2 ./ ((w0^2 - w.^2).^2 + (2 * lambda^2 * w0 .* w).^2);


% Plot pxx vs. f in a double log plot
hold on;
%plot(log(w), log(sxx./TWOPI));
plot(log(f.*TWOPI), log(pxx./TWOPI));
grid on;
title('Power Spectral Density - Wave Influence');
xlabel('Frequency log(rad/s)');
ylabel('Power log(s/rad)');

