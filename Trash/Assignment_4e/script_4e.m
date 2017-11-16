clear;
close all;

% Model constants
T = 72.4637;
K = 0.1561;
w0 = 0.7823;
lambda = 0.0855;
Kw = 0.0052;


% Matrices for the state space equation with all disturbances
A = [
    0       1               0 0     0;
    -w0^2   -2*lambda*w0    0 0     0;
    0       0               0 1     0;
    0       0               0 -1/T  -K/T;
    0       0               0 0     0
    ];

C = [0 1 1 0 0];


% Calculate the observability
obsv_rank = rank(obsv(A, C));
n = size(A,1);

if obsv_rank < n
    disp('Not observable')
else
    disp('Observable')
end
