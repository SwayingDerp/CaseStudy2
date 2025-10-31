%% Case study 3: Circuits as Resonators, Sensors, and Filters
% *ESE 105* 
%
% *Name: FILL IN HERE*
%
% function mySensorCircuit(Vin,h) receives a time-series voltage sequence
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

function Vout = mySensorCircuit(Vin,h)
    % Default RLC circuit (Task 3)
    R = 100;
    L = 0.1;
    C = 0.1e-6;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TASK 4 IMPLEMENTATION - HELICOPTER DETECTOR (COMMENTED OUT)
    % % Helicopter rotor detection - bandpass filter centered at 84 Hz
    % f_target = 84; % Hz - Ingenuity rotor frequency
    % L = 1.0;  % Larger inductance for lower frequency
    % C = 1/((2*pi*f_target)^2 * L); % Resonant capacitance for 84 Hz
    % R = 50; % Ω - Moderate damping
    N = length(Vin);
    
    % Initialize state vectors
    v_C = zeros(1, N);  % Capacitor voltage
    i = zeros(1, N);    % Current through circuit
    
    % Set initial conditions: v_C = 0V, i = 0A at t = 0
    v_C(1) = 0;
    i(1) = 0;
    
    % RLC circuit simulation using state-space approach
    for k = 1:N-1
        % State-space equations derived from KVL and component equations
        % x_{k+1} = A*x_k + B*u_k
        % where x = [v_C; i], u = v_in
        
        % Matrix A and vector B (from Task 3.1 derivation)
        A = [1 - h/(R*C), -h/C; 
             h/L, 1 - (h*R)/L];
        B = [h/(R*C); h/L];
        
        % State update
        x_next = A * [v_C(k); i(k)] + B * Vin(k);
        
        v_C(k+1) = x_next(1);
        i(k+1) = x_next(2);
    end
    
    % Output voltage across resistor
    Vout = i * R;
    
    % TASK 4 ENVELOPE DETECTION (COMMENTED OUT)
    % Uncomment below for helicopter detection to get cleaner output
    % % Envelope detection for helicopter signal
    % Vout = abs(Vout); % Simple envelope detection
end