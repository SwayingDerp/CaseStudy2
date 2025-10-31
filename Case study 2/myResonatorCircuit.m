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
    
    % TASK 4 - TUNING FORK (COMMENTED OUT)
    % f_resonance = 440; % A4 = 440 Hz
    % L = 0.1;
    % C = 1/((2*pi*f_resonance)^2 * L);
    % R = 5;
    
    N = length(Vin);
    
    % Ensure Vin is a row vector for consistent operations
    if size(Vin, 1) > size(Vin, 2)
        Vin = Vin';
    end
    % Pre-allocate Vout with same dimensions as Vin
    Vout = zeros(size(Vin));
    if N > 10000
        chunk_size = 10000;
        i_current = 0;
        for chunk_start = 1:chunk_size:N
            chunk_end = min(chunk_start + chunk_size - 1, N);
            chunk_length = chunk_end - chunk_start + 1;
            i_chunk = zeros(1, chunk_length);
            i_chunk(1) = i_current;
            for k = 1:chunk_length-1
                i_chunk(k+1) = (1 - (h * R) / L) * i_chunk(k) + (h / L) * Vin(chunk_start + k - 1);
            end
            Vout(chunk_start:chunk_end) = Vin(chunk_start:chunk_end) - i_chunk * R;
            i_current = i_chunk(end);
        end
    else
        i = zeros(1, N);
        i(1) = 0;
        for k = 1:N-1
            i(k+1) = (1 - (h * R) / L) * i(k) + (h / L) * Vin(k);
        end 
        Vout = Vin - i * R;
    end
    
    % TASK 4 OUTPUT (COMMENTED OUT)
    % Vout = i * R;
    
    if size(Vin, 1) > size(Vin, 2)
        Vout = Vout';
    end
end