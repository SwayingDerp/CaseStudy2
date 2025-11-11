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

function Vout = myFilterCircuit(Vin, h)

 % STAGE 1: Remove 60Hz hum with band-stop
    f_target = 60;      % Target frequency to reject (60Hz power line hum)
    L = 0.1;            % Inductance value
    C = 1/((2*pi*f_target)^2 * L);  % Capacitance calculated for 60Hz rejection
    R = 100;            % Resistance value
    Fs = 1/h;           % Sampling frequency derived from sampling interval

    N = length(Vin);

    % Ensure Vin is a row vector for consistent operations
    if size(Vin, 1) > size(Vin, 2)
        Vin = Vin';
    end


    Vout = zeros(size(Vin));
    
    % Process input signal using RLC circuit simulation
    if N > 10000
        % For large sequences, process in chunks to manage memory
        chunk_size = 10000; % Process 10,000 samples at a time

        % Initial conditions for RLC circuit
        v_C_current = 0;    % Initial Capacitor Voltage
        i_current = 0;      % Initial Current
        % Process data in chunks
        for chunk_start = 1:chunk_size:N
            chunk_end = min(chunk_start + chunk_size - 1, N);
            chunk_length = chunk_end - chunk_start + 1;
                    
            % Initialize chunk vectors
            v_C_chunk = zeros(1, chunk_length);
            i_chunk = zeros(1, chunk_length);

            % Continue from previous chunk's final state
            v_C_chunk(1) = v_C_current; 
            i_chunk(1) = i_current; 

            % Standard RLC simulation for this chunk
            % Using forward Euler discretization
            A = [1, h/C; -h/L, 1 - (h*R)/L];
            B = [0; h/L];

             % Simulate RLC circuit dynamics for current chunk
            for k = 1:chunk_length-1
                % State update: [v_C; i] = A*[v_C; i] + B*Vin
                x_next = A * [v_C_chunk(k); i_chunk(k)] + B * Vin(chunk_start + k - 1);
                v_C_chunk(k+1) = x_next(1);
                i_chunk(k+1) = x_next(2);
            end
            
            % Output is capacitor voltage (band-stop characteristic)
            Vout(chunk_start:chunk_end) = v_C_chunk;

            % Save final state for next chunk
            v_C_current = v_C_chunk(end);
            i_current = i_chunk(end);
        end
        

    else
        % For smaller sequences, process all at once
        v_C = zeros(1, N);      % Capacitor voltage vector
        i = zeros(1, N);        % Current vector

        % Initial conditions
        v_C(1) = 0;             % Initial capacitor voltage
        i(1) = 0;               % Initial current

            % Replaced A and B with the derivation from google docs.
            A = [1, h/C; -h/L, 1 - (h*R)/L]; 
            B = [0; h/L];

        % Simulate RLC circuit dynamics
        for k = 1:N-1
            % State update: [v_C; i] = A*[v_C; i] + B*Vin
            x_next = A * [v_C(k); i(k)] + B * Vin(k);
            v_C(k+1) = x_next(1);
            i(k+1) = x_next(2);
        end

        % Output is capacitor voltage (band-stop characteristic)
        Vout = v_C;
    end

    % STAGE 2: Frequency-domain filtering using FFT
    %-------FFT method to remove 60 Hz hum
    Y = fft(Vin);
    freq = (0:N-1) * Fs / N;    % Frequency vector
    
    % NOTCH FILTER: Remove 60 Hz hum and harmonics
    % Remove 60 Hz ± 2 Hz
    notch_band = (freq >= 58) & (freq <= 62);
    Y(notch_band) = Y(notch_band) * 0.001; % 99.9% attenuation
    
    % Remove mirror frequencies
    notch_mirror = (freq >= Fs-62) & (freq <= Fs-58);
    Y(notch_mirror) = Y(notch_mirror) * 0.001;
    
    %----------


    % ===== REMOVE HIGH-FREQUENCY NOISE =====
    f_cutoff = 10^3.6;       % ≈ 3162 Hz - remove everything above this
    high_freq_noise = (freq > f_cutoff) & (freq < Fs - f_cutoff);
    Y(high_freq_noise) = 0;  % Complete removal of high frequency
    
    % Convert back to time domain
    Vout = real(ifft(Y));
    
    % Mild gain to compensate for filtering
    Vout = Vout * 1.5;

    % Ensure output orientation matches input orientation
    if size(Vin, 1) > size(Vin, 2)
        Vout = Vout';
    end

end

