% Test RLC Circuit Oscillations (Task 3.2) - Using mySensorCircuit
clear; close all; clc;

h = 1/192000; % Sampling interval from specification
t_end = 0.015; % 15 ms simulation to match Figure 6
t = 0:h:t_end;
Vin = zeros(size(t));
Vin(2:end) = 1; % Step input

% Different component sets for different behaviors
component_sets = {
    [100, 0.1, 0.1e-6],    % Quick decay (blue) - Overdamped
    [10, 0.1, 0.1e-6],     % Tuned oscillation (yellow) - Critically damped
    [1, 0.1, 0.1e-6],      % Slow decay (red) - Underdamped
    [0.5, 0.1, 0.1e-6]     % Unstable/growing (purple) - Numerical instability
};

colors = {'b-', 'y-', 'r-', 'm-'};
labels = {'Quick Decay (R=100Ω)', 'Tuned Oscillation (R=10Ω)', ...
          'Slow Decay (R=1Ω)', 'Unstable (R=0.5Ω)'};

figure;
for i = 1:length(component_sets)
    R = component_sets{i}(1);
    L = component_sets{i}(2);
    C = component_sets{i}(3);
    
    % CALL mySensorCircuit WITH CUSTOM COMPONENTS
    Vout = mySensorCircuit(Vin, h, R, L, C);
    
    plot(t*1000, Vout, colors{i}, 'LineWidth', 2, 'DisplayName', labels{i});
    hold on;
    
    % Calculate damping ratio for analysis
    w0 = 1/sqrt(L*C);
    alpha = R/(2*L);
    damping_ratio = alpha/w0;
    fprintf('%s: ζ = %.3f\n', labels{i}, damping_ratio);
end

plot(t*1000, Vin, 'k--', 'LineWidth', 1, 'DisplayName', 'Input');
xlabel('Time (ms)'); 
ylabel('Voltage (V)');
title('RLC Circuit Step Responses (Figure 6 Reproduction)');
legend('Location', 'northeast'); 
grid on;
ylim([-0.2 1.2]);

%% Play sounds for each case
fprintf('\nPlaying sounds for analysis...\n');
for i = 1:length(component_sets)
    R = component_sets{i}(1);
    L = component_sets{i}(2);
    C = component_sets{i}(3);
    
    Vout = mySensorCircuit(Vin, h, R, L, C);
    
    fprintf('Playing: %s\n', labels{i});
    soundsc(Vout, 1/h);
    pause(2);
end