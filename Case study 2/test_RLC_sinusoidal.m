% Test RLC Circuit with Sinusoidal Inputs (Task 3.3)
clear; close all; clc;

h = 1/192000;
R = 100; L = 0.1; C = 0.1e-6;

frequencies = [10, 1525, 1600, 5000, 10000]; % Hz
t_end = 0.1; % 100 ms per frequency

%for f = frequencies
%    t = 0:h:t_end;
 %   Vin = sin(2*pi*f*t);
%    
%    Vout = simulate_RLC_circuit(Vin, h);
%    
%    % Plot last few cycles to see steady state
%    figure;
%    cycles_to_plot = min(5, floor(length(t)/2));
%    
%    % Calculate samples per cycle and ensure valid plot range
%    samples_per_cycle = round(1/(f*h));
%    plot_Start = max(1, length(t) - cycles_to_plot * samples_per_cycle);
%    plot_range = plot_Start:length(t);
    

    
   figure('Position', [100, 100, 1200, 800]);

for i = 1:length(frequencies)
    f = frequencies(i);
    t = 0:h:t_end;
    Vin = sin(2*pi*f*t);
    
    Vout = simulate_RLC_circuit(Vin, h, R, L, C);
    
    % Create subplot
    subplot(3, 2, i); % 3 rows, 2 columns, current subplot
    
    % Calculate samples per cycle and ensure valid plot range
    samples_per_cycle = round(1/(f*h));
    plot_Start = max(1, length(t) - 3 * samples_per_cycle); % Show last 3 cycles
    plot_range = plot_Start:length(t);
        % Ensure plot_range doesn't exceed array bounds
    if plot_Start > length(t)
        plot_range = 1:length(t);
        warning('Not enough samples for %d Hz, plotting entire signal', f);
    end
    
    % Plot input and output
    plot(t(plot_range)*1000, Vin(plot_range), 'r-', 'LineWidth', 1, 'DisplayName', 'Input');
    hold on;
    plot(t(plot_range)*1000, Vout(plot_range), 'b-', 'LineWidth', 2, 'DisplayName', 'Output');
    xlabel('Time (ms)'); 
    ylabel('Voltage (V)');
    title(sprintf('%d Hz Response', f));
    legend('Location', 'best'); 
    grid on;
    
    % Calculate and display amplitude ratio
    input_amp = max(Vin(plot_range)) - min(Vin(plot_range));
    output_amp = max(Vout(plot_range)) - min(Vout(plot_range));
    amp_ratio = output_amp/input_amp;
        % Play sound
    soundsc(Vout, 1/h);
    pause(2);
end

    %end
    

    
    % Calculate amplitude ratio
    input_amp = max(Vin(plot_range)) - min(Vin(plot_range));
    output_amp = max(Vout(plot_range)) - min(Vout(plot_range));
    fprintf('Frequency: %5d Hz, Amplitude Ratio: %.3f\n', f, output_amp/input_amp);
    

%end