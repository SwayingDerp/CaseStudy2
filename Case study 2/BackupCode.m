%Temp Case Study 2 Storage

% FIlter circuit

            % ===== 2. COMPLETE HIGH-FREQUENCY CHOP-OFF =====
    f_cutoff = 10^3.5;  % ≈ 3162 Hz - everything above this becomes ZERO
    % Alternative cutoffs you could try:
    % f_cutoff = 2000;   % More aggressive
    % f_cutoff = 5000;   % Less aggressive
    
    Y = fft(Vout);
    f = (0:N-1) * (1/h) / N;
    
    % Create mask: keep only frequencies BELOW cutoff
    keep_mask = (f <= f_cutoff) | (f >= (1/h) - f_cutoff);
    
    % CHOP OFF all high frequencies - set them to exactly zero
    Y(~keep_mask) = 0 + 0i;
    
    Vout = real(ifft(Y));

    for n = 2:length(Vstage1)
        Vout(n) = Vout(n-1) + h * (Vstage1(n) - Vout(n-1)) / tau;
    end

    Vstage1 = v_C;  % Band-stop output
    % STAGE 2: Remove high-frequency hiss with low-pass
    f_cutoff = 5000;  % Preserve music, remove hiss
    Vout = zeros(size(Vstage1));
    Vout(1) = Vstage1(1);
    tau = 1/(2*pi*f_cutoff);

function Vout = myFilterCircuitTest2(Vin, h)
% Music filter - removes 60 Hz hum and completely cuts off high frequencies

    N = length(Vin);
    if size(Vin, 1) > size(Vin, 2)
        Vin = Vin';
    end
    
    % ===== 1. REMOVE 60 Hz HUM =====
    Y = fft(Vin);
    f = (0:N-1) * (1/h) / N;
    
    % Deep notch at 60 Hz ± 2 Hz
    notch_band = (f >= 58) & (f <= 62);
    Y(notch_band) = Y(notch_band) * 0.01;  % 99% reduction
    
    Vout = real(ifft(Y));
    
    % ===== 2. COMPLETE HIGH-FREQUENCY CUTOFF =====
    f_cutoff = 8000;  % Everything above 8 kHz becomes zero
    
    Y = fft(Vout);
    f = (0:N-1) * (1/h) / N;
    
    % Keep only frequencies below cutoff and their mirrors
    keep_mask = (f <= f_cutoff) | (f >= (1/h) - f_cutoff);
    Y(~keep_mask) = 0 + 0i;  % Complete removal
    
    Vout = real(ifft(Y));
    
    fprintf('Filter: Removed 60 Hz hum + cut all frequencies above %.0f Hz\n', f_cutoff);
    
    % ===== 3. MILD GAIN =====
    Vout = Vout * 1.2;
    
    % Safety checks
    Vout(isnan(Vout)) = 0;
    Vout(isinf(Vout)) = 0;
    
    if size(Vin, 1) > size(Vin, 2)
        Vout = Vout';
    end
end



function Vout = myFilterCircuitTest3(Vin, h)
% Simple band-stop filter for 60 Hz

    N = length(Vin);
    if size(Vin, 1) > size(Vin, 2)
        Vin = Vin';
    end
    
    % Frequency domain notch filter - guaranteed to work
    Y = fft(Vin);
    f = (0:N-1) * (1/h) / N;
    
    % Create a deep notch at 60 Hz ± 2 Hz
    notch_band = (f >= 58) & (f <= 62);
    Y(notch_band) = Y(notch_band) * 0.01;  % 99% reduction at 60 Hz
    
    Vout = real(ifft(Y));
    
    % Remove high-frequency noise
    f_cutoff = 10000;
    R_lp = 1000;
    C_lp = 1/(2*pi*f_cutoff*R_lp);
    
    Vtemp = Vout;
    for n = 2:length(Vout)
        Vtemp(n) = Vtemp(n-1) + h * (Vout(n) - Vtemp(n-1)) / (R_lp * C_lp);
    end
    Vout = Vtemp;
    
    if size(Vin, 1) > size(Vin, 2)
        Vout = Vout';
    end
end




% Sensor Circuit

    % Ensure output doesn't exceed reasonable bounds
    if max(abs(Vout)) > 1.0
        Vout = Vout / max(abs(Vout)) * 0.95;  % Normalize to prevent clipping
    end

    % ===== NOISE GATE: QUIET WHEN NO HELICOPTER =====
    window_size = min(5000, floor(0.1/h));  % 100ms window
    rms_moving = zeros(1, length(Vout));
    
    % Calculate moving RMS (signal strength over time)
    for i = 1:length(Vout)
        start_idx = max(1, i - floor(window_size/2));
        end_idx = min(length(Vout), i + floor(window_size/2));
        rms_moving(i) = sqrt(mean(Vout(start_idx:end_idx).^2));
    end
    
    % Set threshold - when signal is below this, helicopter is "off"
    threshold = 0.005 * max(rms_moving);  % 5% of peak level
    
    % Apply noise gate: reduce volume when signal is below threshold
    gate_factor = zeros(size(Vout));
    for i = 1:length(Vout)
        if rms_moving(i) > threshold
            gate_factor(i) = 1.0;  % Full volume when helicopter detected
        else
            gate_factor(i) = 0.1;  % 90% quieter when no helicopter
        end
    end
    
    % Smooth the gate transitions to avoid clicks/pops
    smooth_window = min(1000, floor(0.02/h));  % 20ms smoothing
    gate_smooth = movmean(gate_factor, smooth_window);
    
    Vout = Vout .* gate_smooth;
    
    % Debug output
    helicopter_on_time = mean(gate_factor > 0.5) * 100;
    fprintf('Noise gate: Helicopter detected %.1f%% of the time\n', helicopter_on_time);

function Vout = mySensorCircuitTest2(Vin, h)
% Simple, working helicopter sensor

    f_target = 84;  % Hz - Ingenuity rotor frequency
    
    % Safe, tested component values
    L = 0.1;        % Stable value
    C = 1/((2*pi*f_target)^2 * L);
    R = 100;        % Moderate resistance
    
    N = length(Vin);
    
    if size(Vin, 1) > size(Vin, 2)
        Vin = Vin';
    end

    Vout = zeros(size(Vin));
    
    % Simple RLC simulation - no fancy stuff
    v_C = 0;
    i_L = 0;
    
    for k = 1:N
        Vout(k) = i_L * R;  % Output across resistor
        
        if k < N
            % Basic RLC update
            dv_C = (i_L / C) * h;
            di_L = ((Vin(k) - v_C - i_L * R) / L) * h;
            
            v_C = v_C + dv_C;
            i_L = i_L + di_L;
        end
    end
    
    % Apply reasonable gain
    Vout = Vout * 20.0;
    
    
    % Simple noise gate
    rms_level = sqrt(mean(Vout.^2));
    if rms_level < 0.01  % If very quiet
        Vout = Vout * 0.1;  % Make it even quieter
    end
    
    % Safety checks
    Vout(isnan(Vout)) = 0;
    Vout(isinf(Vout)) = 0;
    
    fprintf('Sensor: Max=%.4f, RMS=%.6f\n', max(abs(Vout)), rms_level);
    
    if size(Vin, 1) > size(Vin, 2)
        Vout = Vout';
    end
end



    % 2. Gentle low-pass to remove very high frequency noise above 200 Hz
    f_cutoff = 150;
    R_lp = 1000;
    C_lp = 1/(2*pi*f_cutoff*R_lp);
    
    Vlowpass = zeros(size(Vout));
    Vlowpass(1) = Vout(1);
    for n = 2:length(Vout)
        Vlowpass(n) = Vlowpass(n-1) + h * (Vout(n) - Vlowpass(n-1)) / (R_lp * C_lp);
    end
    
    % 3. Smart noise gating - only activate when helicopter is present
    window_size = min(10000, floor(0.2/h));  % 200ms windows for better detection
    rms_moving = zeros(1, length(Vlowpass));
    
    for i = 1:length(Vlowpass)
        start_idx = max(1, i - floor(window_size/2));
        end_idx = min(length(Vlowpass), i + floor(window_size/2));
        rms_moving(i) = sqrt(mean(Vlowpass(start_idx:end_idx).^2));
    end
    
    % Adaptive threshold based on signal characteristics
    %signal_median = median(rms_moving);
    %signal_std = std(rms_moving);
    window_size2 = min(5000, floor(0.1/h));
    rms_moving2 = movmean(Vout.^2, window_size2).^0.5;
    threshold = 0.1 * max(rms_moving2);  % Much more permissive threshold
    
    % Apply noise gate with smooth transitions
        gate_factor = (rms_moving > threshold) * 0.8 + 0.2;
    %Vout = Vout .* gate_factor;

    
    % Smooth the gate transitions to avoid clicks
    gate_smooth = smoothdata(gate_factor, 'gaussian', min(1000, floor(0.05/h)));
    
    Vout = Vlowpass .* gate_smooth;
    
    % 4. Mild gain to compensate for filtering losses, but avoid clipping
    %Vout = Vout * 5.0;





    % Resonator Circuit

     % 2. Gentle low-pass to remove very high frequency noise above 200 Hz
    f_cutoff = 150;
    R_lp = 1000;
    C_lp = 1/(2*pi*f_cutoff*R_lp);
    
    Vlowpass = zeros(size(Vout));
    Vlowpass(1) = Vout(1);
    for n = 2:length(Vout)
        Vlowpass(n) = Vlowpass(n-1) + h * (Vout(n) - Vlowpass(n-1)) / (R_lp * C_lp);
    end
    
    % 3. Smart noise gating - only activate when helicopter is present
    window_size = min(10000, floor(0.2/h));  % 200ms windows for better detection
    rms_moving = zeros(1, length(Vlowpass));
    
    for i = 1:length(Vlowpass)
        start_idx = max(1, i - floor(window_size/2));
        end_idx = min(length(Vlowpass), i + floor(window_size/2));
        rms_moving(i) = sqrt(mean(Vlowpass(start_idx:end_idx).^2));
    end
    
    % Adaptive threshold based on signal characteristics
    %signal_median = median(rms_moving);
    %signal_std = std(rms_moving);
    window_size2 = min(5000, floor(0.1/h));
    rms_moving2 = movmean(Vout.^2, window_size2).^0.5;
    threshold = 0.1 * max(rms_moving2);  % Much more permissive threshold
    
    % Apply noise gate with smooth transitions
        gate_factor = (rms_moving > threshold) * 0.8 + 0.2;
    Vout = Vout .* gate_factor;
