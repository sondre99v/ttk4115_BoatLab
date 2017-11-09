clear;
close all;

% Define boat parameters
w0 = 0.7823;
lambda = 0.4465;
Kw = 0.0269;

% Nomoto constants
K = 0.1560;
T = 72.47; % seconds


% Matrices for the state space equation without the rudder bias
% disturbance, caused by the current
A = [
    0       1               0 0;
    -w0^2   -2*lambda*w0    0 0;
    0       0               0 1;
    0       0               0 -1/T;
    ];

C = [0 1 1 0];


% Calculate the observability
obsv_rank = rank(obsv(A, C));
n = size(A,1);

if obsv_rank < n
    disp('Not observable')
else
    disp('Observable')
end
