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

function Vout = myResonatorCircuit(Vin, h)
    
    f_resonance = 440;
    L = 0.01;
    C = 1/((2*pi*f_resonance)^2 * L);
    R = 0.3999;  % Smaller for longer ringing

    
    N = length(Vin);
    % Ensure Vin is a row vector for consistent operations
    if size(Vin, 1) > size(Vin, 2)
        Vin = Vin';
    end
    Vout = zeros(size(Vin));
    
    if N > 10000
        chunk_size = 10000; % Process 10,000 samples at a time
        v_C_current = 0; % Initial Capacitor Voltage
        i_current = Vin(1) / R; % Initial Current
        for chunk_start = 1:chunk_size:N
            chunk_end = min(chunk_start + chunk_size - 1, N);
            chunk_length = chunk_end - chunk_start + 1;
                    
            % Process this chunk
            v_C_chunk = zeros(1, chunk_length);
            i_chunk = zeros(1, chunk_length);
            v_C_chunk(1) = v_C_current; % Continue from previous chunk
            i_chunk(1) = i_current; % Continue from previous chunk

            % Standard RLC simulation for this chunk
            A = [1, h/C; -h/L, 1 - (h*R)/L];
            B = [0; h/L];
            for k = 1:chunk_length-1
                x_next = A * [v_C_chunk(k); i_chunk(k)] + B * Vin(chunk_start + k - 1);
                v_C_chunk(k+1) = x_next(1);
                i_chunk(k+1) = x_next(2);
            end
            
            % Save this chunk's output
            Vout(chunk_start:chunk_end) = i_chunk * R;
            % Save final state for next chunk
            v_C_current = v_C_chunk(end);
            i_current = i_chunk(end);
        end
    else
        v_C = zeros(1, N);
        i = zeros(1, N);
        v_C(1) = 0;
        i(1) = Vin(1) / R;  % Current proportional to initial voltage

            A = [1, h/C; -h/L, 1 - (h*R)/L]; % replaced A and B with the derivation from google docs.
            B = [0; h/L];
        for k = 1:N-1
            x_next = A * [v_C(k); i(k)] + B * Vin(k);
            v_C(k+1) = x_next(1);
            i(k+1) = x_next(2);
        end
        Vout = i * R;


    


    if size(Vin, 1) > size(Vin, 2)
        Vout = Vout';
    end
end
