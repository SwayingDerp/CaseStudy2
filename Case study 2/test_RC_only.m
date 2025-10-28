% test_RC_only.m
% Test only the RC charging circuit (Task 1)

clear; close all; clc;

fprintf('=== Task 1: RC Circuit Charging Simulation ===\n');

% Circuit parameters
R = 1e3;    % 1 kΩ
C = 1e-6;   % 1 μF
tau = R * C; % Time constant = 1 ms

% Choose suitable h (much smaller than tau for accuracy)
h_accurate = tau / 100; % h = 0.01 ms

% Create step input: v_C = 0V at t=0, v_in = 1V for t>0
t_end = 5 * tau; % Simulate for 5 time constants
t = 0:h_accurate:t_end;
Vin = zeros(size(t));
Vin(2:end) = 1; % Step input: 1V for t > 0

% Simulate RC charging circuit
Vout = myFilterCircuit(Vin, h_accurate);

% Plot charging curve
figure;
plot(t*1000, Vin, 'r--', 'LineWidth', 2, 'DisplayName', 'v_{in}');
hold on;
plot(t*1000, Vout, 'b-', 'LineWidth', 2, 'DisplayName', 'v_C');
xlabel('Time (ms)');
ylabel('Voltage (V)');
title('Task 1: RC Circuit Charging - Circuit A');
legend('Location', 'southeast');
grid on;
axis([0 5 0 1.1]);

fprintf('RC Time Constant: τ = %.3f ms\n', tau*1000);
fprintf('Sampling interval: h = %.6f s\n', h_accurate);
fprintf('Simulation completed successfully!\n');