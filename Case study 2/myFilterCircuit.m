%% Case study 3: Circuits as Resonators, Sensors, and Filters
% *ESE 105* 
%
% *Name: FILL IN HERE*
%
% function myFilterCircuit(Vin,h) receives a time-series voltage sequence
% sampled with interval h, and returns the output voltage sequence produced
% by a circuit
%
% inputs:
% Vin - time-series vector representing the voltage input to a circuit
% h - scalar representing the sampling interval of the time series in
% seconds
%
% outputs:
% Vout - time-series vector representing the output voltage of a circuit

function Vout = myFilterCircuit(Vin,h)
    % Default RC circuit (Task 1)
    R = 1e3;    % Resistance = 1 kΩ
    C = 1e-6;   % Capacitance = 1 μF
    tau = R * C; % Time constant
    
    % TASK 4 IMPLEMENTATION - MUSIC FILTER 
    % Uncomment below and comment above for Task 4 music filter
    % % Music filter - bandpass for audio (removes 60Hz hum and high-frequency noise)
    % L = 0.01;   % Smaller inductance
    % C = 1e-6;   % 1 μF capacitor
    % R = 100;    % Ω - Critical damping for clean audio

    
    % Initialize output voltage array
    Vout = zeros(size(Vin));
    
    % Set initial condition: capacitor voltage starts at 0V
    Vout(1) = 0;
    
    % TASK 4 RLC IMPLEMENTATION (COMMENTED OUT)
    % Uncomment below and comment RC simulation for Task 4 music filter
    % % RLC circuit simulation for music filter
    % N = length(Vin);
    % v_C = zeros(1, N);  % Capacitor voltage
    % i = zeros(1, N);    % Current through circuit
    % 
    % % Set initial conditions
    % v_C(1) = 0;
    % i(1) = 0;
    % 
    % % State-space matrices for RLC circuit
    % A = [1, h/C; -h/L, 1 - h*R/L];
    % B = [0; h/L];
    % 
    % for k = 1:N-1
    %     x_next = A * [v_C(k); i(k)] + B * Vin(k);
    %     v_C(k+1) = x_next(1);
    %     i(k+1) = x_next(2);
    % end
    % 
    % % Output voltage across resistor (bandpass characteristic)
    % Vout = i * R;
    
    % RC circuit simulation using numerical integration (Forward Euler) - Task 1
    % Equation (8): i_C = C * dv_C/dt = (v_in - v_C)/R
    % Rearranged as Equation (10): dv_C/dt = (v_in - v_C)/(R*C)
    for n = 2:length(Vin)
        % Forward Euler method
        Vout(n) = Vout(n-1) + h * (Vin(n-1) - Vout(n-1)) / (R * C);
    end
end