w0 = 0.782330201821677; %[rad/s]
T = 72.47; %[s]
K = 0.156; %[1]
lambda = 0.0827; %[1]
Kw = 0.024111693339534;

% PD regulator parameters
Tf = 8.406;
Td = T;
Kpd = 0.8370;

H0 = tf(K * Kpd, [Tf 1 0]);
margin(H0);

Ts = 0.1; %[s]

%% Continous time model
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

%% Discretisation
[Ad, Bd] = c2d(A, B, Ts);
[~, Ed] = c2d(A, E, Ts);

loan_m = expm([A E*Q*E';zeros(5) -A'] * Ts);
Qd = loan_m(1:5, 6:10) * loan_m(1:5, 1:5)';

data.A = Ad;
data.B = Bd;
data.C = C;
data.R = 0.002 / Ts;
data.Q = Qd;
data.E = Ed;

data.Pm0 = [
    1 0 0 0 0;
    0 0.013 0 0 0;
    0 0 pi^2 0 0;
    0 0 0 1 0;
    0 0 0 0 2.5*10^-3];


sim('..\BoatLabFiles\ship.mdl');