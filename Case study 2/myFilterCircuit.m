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
    R = 1e3;
    C = 1e-6;
    
    % TASK 4 - MUSIC FILTER (COMMENTED OUT)
    % L = 0.01;
    % C = 1e-6;
    % R = 100;
    
    N = length(Vin);
    
    % Ensure Vin is a row vector for consistent operations
    if size(Vin, 1) > size(Vin, 2)
        Vin = Vin';
    end
    % Pre-allocate Vout with same dimensions as Vin
    Vout = zeros(size(Vin));
    Vout(1) = 0;
    if N > 10000
        chunk_size = 10000;
        v_out_current = 0;
        for chunk_start = 1:chunk_size:N
            chunk_end = min(chunk_start + chunk_size - 1, N);
            chunk_length = chunk_end - chunk_start + 1;
            v_out_chunk = zeros(1, chunk_length);
            v_out_chunk(1) = v_out_current;
            for n = 2:chunk_length
                v_out_chunk(n) = v_out_chunk(n-1) + h * (Vin(chunk_start + n - 2) - v_out_chunk(n-1)) / (R * C);
            end
            Vout(chunk_start:chunk_end) = v_out_chunk;
            v_out_current = v_out_chunk(end);
        end
    else
        for n = 2:N
            Vout(n) = Vout(n-1) + h * (Vin(n-1) - Vout(n-1)) / (R * C);
        end
    end
    % Ensure output has same orientation as input
    if size(Vin, 1) > size(Vin, 2)
        Vout = Vout';
    end
end