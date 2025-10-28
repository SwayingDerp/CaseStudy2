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
    % Circuit parameters for RC charging simulation
    R = 1e3;    % Resistance = 1 kΩ
    C = 1e-6;   % Capacitance = 1 μF
    tau = R * C; % Time constant
    % Initialize output voltage array
    Vout = zeros(size(Vin));
    % Set initial condition: capacitor voltage starts at 0V
    Vout(1) = 0;
    % Simulate RC circuit using numerical integration (Forward Euler)
    % Equation (8): i_C = C * dv_C/dt = (v_in - v_C)/R
    % Rearranged as Equation (10): dv_C/dt = (v_in - v_C)/(R*C)
    for n = 2:length(Vin)
        % Forward Euler method
        Vout(n) = Vout(n-1) + h * (Vin(n-1) - Vout(n-1)) / (R * C);
    end
end