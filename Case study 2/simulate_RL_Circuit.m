function Vout = simulate_RL_Circuit(Vin,h)
  % Default RL circuit (Task 2)
    R = 100;
    L = 0.1;
    
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
        Vout(1) = Vin(1);  % Initial condition: v_L = v_in at t=0
    end
    
    if size(Vin, 1) > size(Vin, 2)
        Vout = Vout';
    end
end