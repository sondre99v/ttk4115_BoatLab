% Discrete time Kalman filter

function [sys,x0,str,ts,simStateCompliance] = kalman(t,x,u,flag,data)
    switch flag
        case 0 % Initialization
            [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(data);

        case 2 % Update
            sys=mdlUpdate(t,x,u,data);

        case 3 % Outputs
            sys=mdlOutputs(t,x,u,data);
            
        case 9 % Terminate
            sys = [];
            
        otherwise % Unexpected flags
            DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
    end
end


function [sys,x0,str,ts,simStateCompliance] = mdlInitializeSizes(data)
    % Initialize the initial conditions
    x0  = [zeros(10,1); data.Pm0(:)];

    % str is always an empty matrix
    str = [];

    % Initialize the array of sample times
    ts  = [-1 0];

    simStateCompliance = 'UnknownSimState';

    sizes = simsizes;

    sizes.NumContStates  = 0;
    sizes.NumDiscStates  = length(x0);
    sizes.NumOutputs     = 3;
    sizes.NumInputs      = 2;
    sizes.DirFeedthrough = 1;
    sizes.NumSampleTimes = 1;

    sys = simsizes(sizes);
end


function sys = mdlUpdate(t,x,u,data)
    % Extract covariance matrix from x
    Pm_vec = x(11:35);
    n = sqrt(length(Pm_vec));
    Pm = reshape(Pm_vec, n, n);

    % Calculate Kalman filter gain, L
    L = Pm * data.C' / (data.C * Pm * data.C' + data.R);

    % Update estimate
    x_priori = x(1:5);
    x_posteriori = x_priori + L * (u(2) - (data.C * x_priori)); 

    % Update covariance matrix
    P = (eye(5) - (L * data.C)) * Pm * ...
        (eye(5) - (L * data.C))' + ...
        L * data.R * L';

    % Project ahead
    x_priori = data.A * x_posteriori + data.B * u(1);
    Pm = data.A * P * data.A' + data.Q;

    % Return new filter state vector
    sys = [x_priori; x_posteriori; Pm(:)];
end

% Output function
function sys=mdlOutputs(t,x,u,data)
    heading = x(8);
    rudder_bias = x(10);
    wave_influence = x(7);
    sys = [rudder_bias heading wave_influence];
end
