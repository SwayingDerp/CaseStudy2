%% Case study 3: Circuits as Resonators, Sensors, and Filters
% *ESE 105* 
%
% *Name: FILL IN HERE*
%
% function myResonatorCircuit(Vin,h) receives a time-series voltage sequence
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

function Vout = myResonatorCircuit(Vin,h)
    % Default RL circuit (Task 2)
    R = 100;
    L = 0.1;
    
    % TASK 4 IMPLEMENTATION - TUNING FORK 
    % Uncomment below and comment above for Task 4 tuning fork resonator
    % % Tuning fork resonator - rings at A4 = 440 Hz
    % f_resonance = 440; % Hz - musical note A4
    % L = 0.1;  % Fixed inductance
    % C = 1/((2*pi*f_resonance)^2 * L); % Calculate C for resonance
    % R = 5; % Small resistance for sustained ringing

    % Initialize arrays
    N = length(Vin);
    i = zeros(1, N); % Current through circuit
    
    % Set initial condition: i = 0 A at t = 0
    i(1) = 0;
    
    % TASK 4 RLC IMPLEMENTATION (COMMENTED OUT)
    % Uncomment below and comment the RL simulation for Task 4 tuning fork
    % % RLC circuit simulation for tuning fork
    % v_C = zeros(1, N);  % Capacitor voltage
    % v_C(1) = 0;
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
    
    % RL circuit simulation using Equation (20) 
    for k = 1:N-1
        i(k+1) = (1 - (h * R) / L) * i(k) + (h / L) * Vin(k);
    end
    
    % Calculate voltage across inductor (output for Task 2.1)
    Vout = Vin - i * R;
    % TASK 4 OUTPUT MODIFICATION 
    % Uncomment below for Task 4 tuning fork (output across resistor)
    % % Output voltage across resistor for tuning fork (rings at resonance)
    % Vout = i * R;
end