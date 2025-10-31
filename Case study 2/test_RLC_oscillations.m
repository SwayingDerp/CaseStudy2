% Test RLC Circuit Oscillations (Task 3.2)
clear; close all; clc;

h = 1/192000; % Sampling interval from specification
t_end = 0.02; % 20 ms simulation
t = 0:h:t_end;
Vin = zeros(size(t));
Vin(2:end) = 1; % Step input

% Different component sets for different behaviors
component_sets = {
    [100, 0.1, 0.1e-6],    % Quick decay (blue)
    [10, 0.1, 0.1e-6],     % Tuned oscillation (yellow) 
    [1, 0.1, 0.1e-6]       % Unstable/growing (purple)
};

colors = ['b', 'y', 'm'];
labels = {'Quick Decay', 'Tuned Oscillation', 'Unstable'};

figure;
for i = 1:length(component_sets)
    % Modify circuit parameters (you'd need to modify mySensorCircuit temporarily)
    % This is conceptual - you'd need to pass parameters to the function
    Vout = mySensorCircuit(Vin, h); % With modified parameters
    plot(t*1000, Vout, colors(i), 'LineWidth', 2, 'DisplayName', labels{i});
    hold on;
end

plot(t*1000, Vin, 'r--', 'LineWidth', 1, 'DisplayName', 'Input');
xlabel('Time (ms)'); ylabel('Voltage (V)');
title('RLC Circuit Step Responses');
legend; grid on;