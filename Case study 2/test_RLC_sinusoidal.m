% Test RLC Circuit with Sinusoidal Inputs (Task 3.3)
clear; close all; clc;

h = 1/192000;
R = 100; L = 0.1; C = 0.1e-6;

frequencies = [10, 100, 1000, 5000, 10000]; % Hz
t_end = 0.1; % 100 ms per frequency

for f = frequencies
    t = 0:h:t_end;
    Vin = sin(2*pi*f*t);
    
    Vout = mySensorCircuit(Vin, h);
    
    % Plot last few cycles to see steady state
    figure;
    cycles_to_plot = min(5, floor(length(t)/2));
    plot_Start = length(t) - cycles_to_plot * round(1/(f*h));
    plot_range = plot_Start:length(t);
    
    plot(t(plot_range)*1000, Vin(plot_range), 'r-', 'LineWidth', 1, 'DisplayName', 'Input');
    hold on;
    plot(t(plot_range)*1000, Vout(plot_range), 'b-', 'LineWidth', 2, 'DisplayName', 'Output');
    xlabel('Time (ms)'); ylabel('Voltage (V)');
    title(sprintf('RLC Response at f = %d Hz', f));
    legend; grid on;
    
    % Calculate amplitude ratio
    input_amp = max(Vin(plot_range)) - min(Vin(plot_range));
    output_amp = max(Vout(plot_range)) - min(Vout(plot_range));
    fprintf('Frequency: %5d Hz, Amplitude Ratio: %.3f\n', f, output_amp/input_amp);
    
    % Play sound
    soundsc(Vout, 1/h);
    pause(2);
end