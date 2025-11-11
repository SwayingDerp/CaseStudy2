% Test RL Circuit (Part 2)
clear; close all; clc;

% RL circuit parameters
R = 100; L = 0.1; tau_L = L/R;
% Sampling time step (small compared to time constant for accuracy)
h = tau_L / 100;
% Simulation duration (5 time constants to reach steady state)
t_end = 5 * tau_L;
% Time vector
t = 0:h:t_end;
% Step input voltage (0V for t=0, 1V for t>0)
Vin = zeros(size(t));
Vin(2:end) = 1;

% Simulate RL circuit response
v_L = simulate_RL_Circuit(Vin, h);

% Plot results
figure;
plot(t*1000, Vin, 'r--', t*1000, v_L, 'b-');
xlabel('Time (ms)'); ylabel('Voltage (V)');
title('RL Circuit - Inductor Voltage');
legend('v_{in}', 'v_L'); grid on;