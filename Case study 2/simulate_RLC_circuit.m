function Vout = simulate_RLC_circuit(Vin, h, R, L, C)
% Modified to accept component parameters for testing by turning task 3
% into default if there is no task
    
    % If no component values provided, use defaults
    if nargin < 3
        R = 100;
        L = 0.1;
        C = 0.1e-6;
    end
    
    N = length(Vin);
    % Ensure Vin is a row vector for consistent operations
    if size(Vin, 1) > size(Vin, 2)
        Vin = Vin';
    end
    Vout = zeros(size(Vin));
    
    % For large input sequences, process in chunks to manage memory
    if N > 10000
        chunk_size = 10000; % Process 10,000 samples at a time
        v_C_current = 0; % Initial Capacitor Voltage
        i_current = 0; % Initial Current
        % Process data in chunks
        for chunk_start = 1:chunk_size:N
            chunk_end = min(chunk_start + chunk_size - 1, N);
            chunk_length = chunk_end - chunk_start + 1;
                    
            % Initialize chunk vectors
            v_C_chunk = zeros(1, chunk_length);
            i_chunk = zeros(1, chunk_length);
            v_C_chunk(1) = v_C_current; % Continue from previous chunk
            i_chunk(1) = i_current; % Continue from previous chunk

            % State-space matrices for RLC circuit simulation
            A = [1, h/C; -h/L, 1 - (h*R)/L];
            B = [0; h/L];
            % Simulate RLC circuit dynamics for current chunk
            for k = 1:chunk_length-1
                x_next = A * [v_C_chunk(k); i_chunk(k)] + B * Vin(chunk_start + k - 1);
                v_C_chunk(k+1) = x_next(1);
                i_chunk(k+1) = x_next(2);
            end
            
            % Save this chunk's output (voltage across resistor)
            Vout(chunk_start:chunk_end) = i_chunk * R;
            % Save final state for next chunk continuation
            v_C_current = v_C_chunk(end);
            i_current = i_chunk(end);
        end
    else
        % For smaller sequences, process all at once
        v_C = zeros(1, N);  % Capacitor voltage vector
        i = zeros(1, N);    % Current vector
        % Initial conditions
        v_C(1) = 0;         % Initial capacitor voltage
        i(1) = 0;           % Initial current
        % State-space matrices for RLC circuit simulation
        A = [1, h/C; -h/L, 1 - (h*R)/L];
        B = [0; h/L];
        % Simulate RLC circuit dynamics
        for k = 1:N-1
            x_next = A * [v_C(k); i(k)] + B * Vin(k);
            v_C(k+1) = x_next(1);
            i(k+1) = x_next(2);
        end
        % Output voltage is voltage across resistor (V = i*R)
        Vout = i * R;
    end
    
    % Ensure output orientation matches input orientation
    if size(Vin, 1) > size(Vin, 2)
        Vout = Vout';
    end
end