% Test RLC Circuit Oscillations (Task 3.2) - Using mySensorCircuit
clear; close all; clc;

h = 1/192000; % Sampling interval from specification
t_end = 0.015; % 15 ms simulation to match Figure 6
t = 0:h:t_end;
Vin = zeros(size(t));
Vin(2:end) = 1; % Step input

% Different component sets for different behaviors
component_sets = {
    [100, 0.1, 0.1e-6],   % Quick decay 
    [50, 0.1, 0.1e-6],    % Tuned oscillation
    [10, 0.1, 0.1e-6],    % Unstable
};

colors = {'b-', 'y-', 'r-', 'm-'};
labels = {'Quick Decay (R=100Ω)', 'Tuned Oscillation (R=50Ω)', ...
          'Unstable (R=10Ω)'};

figure;

for i = 1:length(component_sets)
    R = component_sets{i}(1);
    L = component_sets{i}(2);
    C = component_sets{i}(3);
    
    % CALL mySensorCircuit WITH CUSTOM COMPONENTS
    Vout = simulate_RLC_circuit(Vin, h, R, L, C);
    
    plot(t*1000, Vout, colors{i}, 'LineWidth', 2, 'DisplayName', labels{i});
    hold on;
  
    
    % Calculate damping ratio for analysis
    w0 = 1/sqrt(L*C);           % Natural frequency
    alpha = R/(2*L);            % Damping coefficient
    damping_ratio = alpha/w0;   % Damping ratio
    fprintf('%s: ζ = %.3f\n', labels{i}, damping_ratio);

    % Play sound of the circuit response
    fprintf('Playing: %s\n', labels{i});
    soundsc(Vout);
    pause(2);   % Pause to hear each sound clearly
end

% Plot input signal for reference
plot(t*1000, Vin, 'k--', 'LineWidth', 1, 'DisplayName', 'Input');
xlabel('Time (ms)'); 
ylabel('Voltage (V)');
title('RLC Circuit Step Responses (Figure 6 Reproduction)');
legend('Location', 'northeast'); 
grid on;
ylim([-0.2 1.2]);

%% Play sounds for each case % additional loop not needed.
%fprintf('\nPlaying sounds for analysis...\n');
%for i = 1:length(component_sets)
%    R = component_sets{i}(1);
%    L = component_sets{i}(2);
%    C = component_sets{i}(3);
    
%    Vout = mySensorCircuit(Vin, h, R, L, C);
    

%end