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

R = 1e3;
C = 1e-6;
tau = R * C;
t_fine = 0:0.0001:0.01;
t_coarse = 0:0.002:0.01;
V_in_fine = ones(size(t_fine));
V_in_fine(1) = 0;
V_in_coarse = ones(size(t_coarse));
V_in_coarse(1) = 0;
V_fine = myFilterCircuit(V_in_fine, 0.0001);
V_coarse = myFilterCircuit(V_in_coarse, 0.002);
V_C_theoretical_fine = 1 - exp(-t_fine/tau);
V_C_theoretical_coarse = 1 - exp(-t_coarse/tau);

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

% Plot the accurate and inaccurate curves.
figure('Position', [100, 100, 1200, 500]);
subplot(1,2,1);
plot(t_fine*1000, V_fine, 'r-', 'LineWidth', 2, 'DisplayName', 'Accurate (h = 0.1 ms)');
hold on;
plot(t_fine*1000, V_C_theoretical_fine, 'k--', 'LineWidth', 1.5, 'DisplayName', 'Theoretical');
grid on;
xlabel('Time (ms)');
ylabel('Capacitor Voltage V_C (V)');
title('Accurate Simulation vs Theoretical');
legend('show', 'Location', 'southeast');
xlim([0, 10]);
ylim([0, 1.1]);
subplot(1,2,2);
plot(t_fine*1000, V_C_theoretical_fine, 'k--', 'LineWidth', 2, 'DisplayName', 'Theoretical');
hold on;
plot(t_fine*1000, V_fine, 'b-', 'LineWidth', 2, 'DisplayName', 'Accurate (h = 0.1 ms)');
plot(t_coarse*1000, V_coarse, 'ro-', 'LineWidth', 2, 'MarkerSize', 4, 'DisplayName', 'Inaccurate (h = 2 ms)');
grid on;
xlabel('Time (ms)');
ylabel('Capacitor Voltage V_C (V)');
title('Comparison of Simulation Accuracy');
legend('show', 'Location', 'southeast');
xlim([0, 10]);
ylim([0, 1.1]);