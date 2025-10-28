% Test RL Circuit (Part 2)
clear; close all; clc;

R = 100; L = 0.1; tau_L = L/R;
h = tau_L / 100;
t_end = 5 * tau_L;
t = 0:h:t_end;
Vin = zeros(size(t));
Vin(2:end) = 1;

v_L = myResonatorCircuit(Vin, h);

figure;
plot(t*1000, Vin, 'r--', t*1000, v_L, 'b-');
xlabel('Time (ms)'); ylabel('Voltage (V)');
title('RL Circuit - Inductor Voltage');
legend('v_{in}', 'v_L'); grid on;