% Test Complementary Characteristics of RC and RL Circuits
clear; close all; clc;

fprintf('=== Complementary Characteristics: RC vs RL Circuits ===\n\n');

%% Common parameters
t_end = 0.01; % 10 ms simulation
h = 1e-5;     % 10 μs time step
t = 0:h:t_end;
Vin = zeros(size(t));
Vin(2:end) = 1; % Step input: 0V at t=0, 1V for t>0

%% RC Circuit Simulation
fprintf('RC CIRCUIT (R=1kΩ, C=1μF):\n');
Vout_RC = myFilterCircuit(Vin, h);

% Calculate current through capacitor (i_C = C * dv_C/dt)
R_RC = 1e3; C_RC = 1e-6;
i_RC = zeros(size(Vout_RC));
for n = 2:length(Vout_RC)
    i_RC(n) = C_RC * (Vout_RC(n) - Vout_RC(n-1)) / h;
end

% Steady-state values for RC circuit
v_C_steady = Vout_RC(end);
i_C_steady = i_RC(end);

fprintf('  Steady-state capacitor voltage: %.4f V\n', v_C_steady);
fprintf('  Steady-state capacitor current: %.6f A\n', i_C_steady);
fprintf('  Final current through capacitor: %.2e A\n\n', i_C_steady);

%% RL Circuit Simulation
fprintf('RL CIRCUIT (R=100Ω, L=100mH):\n');
v_L_RL = myResonatorCircuit(Vin, h);

% Calculate current through inductor (from RL circuit equations)
R_RL = 100; L_RL = 0.1;
i_RL = zeros(size(v_L_RL));
i_RL(1) = 0;
for k = 1:length(v_L_RL)-1
    i_RL(k+1) = (1 - (h * R_RL) / L_RL) * i_RL(k) + (h / L_RL) * Vin(k);
end

% Steady-state values for RL circuit
v_L_steady = v_L_RL(end);
i_L_steady = i_RL(end);

fprintf('  Steady-state inductor voltage: %.4f V\n', v_L_steady);
fprintf('  Steady-state inductor current: %.4f A\n', i_L_steady);
fprintf('  Theoretical max current (V/R): %.4f A\n\n', 1/R_RL);

%% Plot Comparison
figure('Position', [100, 100, 1200, 800]);

% Voltage comparison
subplot(2,2,1);
plot(t*1000, Vin, 'k--', 'LineWidth', 1, 'DisplayName', 'v_{in}');
hold on;
plot(t*1000, Vout_RC, 'b-', 'LineWidth', 2, 'DisplayName', 'v_C (Capacitor)');
plot(t*1000, v_L_RL, 'r-', 'LineWidth', 2, 'DisplayName', 'v_L (Inductor)');
xlabel('Time (ms)');
ylabel('Voltage (V)');
title('Voltage Comparison: Capacitor vs Inductor');
legend('Location', 'east');
grid on;
axis([0 10 0 1.1]);

% Current comparison
subplot(2,2,2);
plot(t*1000, i_RC*1000, 'b-', 'LineWidth', 2, 'DisplayName', 'i_C (Capacitor)');
hold on;
plot(t*1000, i_RL*1000, 'r-', 'LineWidth', 2, 'DisplayName', 'i_L (Inductor)');
xlabel('Time (ms)');
ylabel('Current (mA)');
title('Current Comparison: Capacitor vs Inductor');
legend('Location', 'east');
grid on;

% Capacitor behavior
subplot(2,2,3);
yyaxis left;
plot(t*1000, Vout_RC, 'b-', 'LineWidth', 2);
ylabel('Capacitor Voltage (V)');
yyaxis right;
plot(t*1000, i_RC*1000, 'b--', 'LineWidth', 2);
ylabel('Capacitor Current (mA)');
xlabel('Time (ms)');
title('Capacitor: Voltage ↗, Current ↘');
grid on;

% Inductor behavior
subplot(2,2,4);
yyaxis left;
plot(t*1000, v_L_RL, 'r-', 'LineWidth', 2);
ylabel('Inductor Voltage (V)');
yyaxis right;
plot(t*1000, i_RL*1000, 'r--', 'LineWidth', 2);
ylabel('Inductor Current (mA)');
xlabel('Time (ms)');
title('Inductor: Voltage ↘, Current ↗');
grid on;

