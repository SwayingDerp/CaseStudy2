function Vout = simulate_RC_circuit(Vin,h)
% Default RC circuit (Task 1)
    R = 1e3;    % Resistance value (1 kΩ)
    C = 1e-6;   % Capacitance value (1 μF)

    N = length(Vin);  % Length of input signal
    
    % Ensure Vin is a row vector for consistent operations
    if size(Vin, 1) > size(Vin, 2)
        Vin = Vin';
    end
    % Pre-allocate Vout with same dimensions as Vin
    Vout = zeros(size(Vin));
    Vout(1) = 0;  % Initial condition: capacitor voltage starts at 0
    
    % For large input sequences, process in chunks to manage memory
    if N > 10000
        chunk_size = 10000;  % Process 10,000 samples at a time
        v_out_current = 0;   % Initialize current output voltage state
        % Process data in chunks
        for chunk_start = 1:chunk_size:N
            chunk_end = min(chunk_start + chunk_size - 1, N);
            chunk_length = chunk_end - chunk_start + 1;
            % Initialize chunk vector
            v_out_chunk = zeros(1, chunk_length);
            v_out_chunk(1) = v_out_current;  % Continue from previous chunk
            % Simulate RC circuit using forward Euler method
            for n = 2:chunk_length
                % Update capacitor voltage using differential equation
                v_out_chunk(n) = v_out_chunk(n-1) + h * (Vin(chunk_start + n - 2) - v_out_chunk(n-1)) / (R * C);
            end
            % Store chunk results in output
            Vout(chunk_start:chunk_end) = v_out_chunk;
            % Save final state for next chunk continuation
            v_out_current = v_out_chunk(end);
        end
    else
        % For smaller sequences, process all at once
        for n = 2:N
            % Update capacitor voltage using differential equation
            Vout(n) = Vout(n-1) + h * (Vin(n-1) - Vout(n-1)) / (R * C);
        end
    end
    % Ensure output has same orientation as input
    if size(Vin, 1) > size(Vin, 2)
        Vout = Vout';
    end
end