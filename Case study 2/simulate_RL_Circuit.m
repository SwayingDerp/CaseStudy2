function Vout = simulate_RL_Circuit(Vin,h)
% Default RL circuit (Task 2)
    R = 100;    % Resistance value (100 Ω)
    L = 0.1;    % Inductance value (0.1 H)
    
    N = length(Vin);  % Length of input signal
    
    % Ensure Vin is a row vector for consistent operations
    if size(Vin, 1) > size(Vin, 2)
        Vin = Vin';
    end
    % Pre-allocate Vout with same dimensions as Vin
    Vout = zeros(size(Vin));
    
    % For large input sequences, process in chunks to manage memory
    if N > 10000
        chunk_size = 10000;  % Process 10,000 samples at a time
        i_current = 0;       % Initialize current state
        % Process data in chunks
        for chunk_start = 1:chunk_size:N
            chunk_end = min(chunk_start + chunk_size - 1, N);
            chunk_length = chunk_end - chunk_start + 1;
            % Initialize chunk vector for current
            i_chunk = zeros(1, chunk_length);
            i_chunk(1) = i_current;  % Continue from previous chunk
            % Simulate RL circuit using forward Euler method
            for k = 1:chunk_length-1
                % Update current using differential equation
                i_chunk(k+1) = (1 - (h * R) / L) * i_chunk(k) + (h / L) * Vin(chunk_start + k - 1);
            end
            % Output voltage is inductor voltage: v_L = v_in - i*R
            Vout(chunk_start:chunk_end) = Vin(chunk_start:chunk_end) - i_chunk * R;
            % Save final state for next chunk continuation
            i_current = i_chunk(end);
        end
    else
        % For smaller sequences, process all at once
        i = zeros(1, N);  % Current vector
        i(1) = 0;         % Initial current condition
        % Simulate RL circuit dynamics
        for k = 1:N-1
            % Update current using differential equation
            i(k+1) = (1 - (h * R) / L) * i(k) + (h / L) * Vin(k);
        end 
        % Output voltage is inductor voltage: v_L = v_in - i*R
        Vout = Vin - i * R;
        Vout(1) = Vin(1);  % Initial condition: v_L = v_in at t=0 (step response)
    end
    
    % Ensure output has same orientation as input
    if size(Vin, 1) > size(Vin, 2)
        Vout = Vout';
    end
end