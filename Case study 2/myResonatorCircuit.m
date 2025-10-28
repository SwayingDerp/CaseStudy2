%% Case study 3: Circuits as Resonators, Sensors, and Filters
% *ESE 105* 
%
% *Name: FILL IN HERE*
%
% function myResonatorCircuit(Vin,h) receives a time-series voltage sequence
% sampled with interval h, and returns the output voltage sequence produced
% by a circuit
%
% inputs:
% Vin - time-series vector representing the voltage input to a circuit
% h - scalar representing the sampling interval of the time series in
% seconds
%
% outputs:
% Vout - time-series vector representing the output voltage of a circuit

function Vout = myResonatorCircuit(Vin,h)
R=100;
L=0.1;
% Initialize arrays
N = length(Vin);
i = zeros(1, N); % Current through circuit
% Set initial condition: i = 0 A at t = 0
i(1) = 0;
% RL circuit simulation using Equation (20)
for k = 1:N-1
    i(k+1) = (1 - (h * R) / L) * i(k) + (h / L) * Vin(k);
end
 % Calculate voltage across inductor (output for Task 2.1)
Vout = Vin - i * R;
end