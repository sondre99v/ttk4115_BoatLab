clear;
close all;

% Define boat parameters

w0 = 0.7823;
lambda = 0.4465;
Kw = 0.0269;

% Nomoto constants
K = 0.1560;
T = 72.47; % seconds


% Matrices for the state space equation with all disturbances
A = [
    0       1               0 0     0;
    -w0^2   -2*lambda*w0    0 0     0;
    0       0               0 1     0;
    0       0               0 -1/T  -K/T;
    0       0               0 0     0
    ];

B = [
    0;
    0;
    0;
    K/T;
    0
    ];

C = [0 1 1 0 0];

E = [
    0   0;
    Kw  0;
    0   0;
    0   0;
    0   1
    ];
