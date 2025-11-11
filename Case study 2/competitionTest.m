%% Case study 3: Circuits as Resonators, Sensors, and Filters
% *ESE 105* 
%
% *Name: FILL IN HERE*

clear;
close all;

Fs = 192000;   % Sampling frequency, Hz

%% Task 1: Tuning fork
%L = 0.1;
%C = 1/((2*pi*f_resonance)^2 * L);
%R = 5;
Vpulse = zeros(1, 192000*5);     % 5-second duration
Vpulse(1) = 1;
f_resonance = 440; % A4 = 440 Hz

VpulseCompetition = zeros(1, 192000*100);
VpulseCompetition(1) = 1;


Vringing = myResonatorCircuit(Vpulse,1/Fs);
figure;
t = (0:length(Vringing)-1) / Fs;
plot(t, Vringing);
xlabel('Time (seconds)');
ylabel('Voltage (V)');
title('Tuning Fork Ring Duration Measurement');
grid on;

%soundsc(Vringing,Fs);
%pause(2);

VringingCompetition = myResonatorCircuit(VpulseCompetition, 1/Fs);
figure;
t = (0:length(VringingCompetition)-1) / Fs;
plot(t, VringingCompetition);
xlabel('Time (seconds)');
ylabel('Voltage (V)');
title('Tuning Fork Ring Duration Measurement');
grid on;

%soundsc(VringingCompetition,Fs);
%pause(105);

%% Task 2: Audio sensor

load('MarsHelicopter_noisy.mat');
% set sampling interval to match sampling rate of the audio signal
h = 1/Fs;

% compute signal output from circuit
VsoundFiltered = mySensorCircuit(Vsound,h);

% compare power spectra
plotPowerSpectrum(Vsound,Fs);
plotPowerSpectrum(VsoundFiltered,Fs);

% play original sound
playSound(Vsound,Fs);
pause(3);

% play sound after circuit filter
playSound(VsoundFiltered,Fs);
pause(5);

%% Task 3: Music filter

% load('handel.mat');
load('noisyhandel.mat');

% set sampling interval to match sampling rate of the audio signal
h = 1/Fs;

% L = 0.01;
% C = 1e-6;
% R = 100;

% compute signal output from circuit
VsoundFiltered = myFilterCircuit(Vsound,h);

% compare power spectra
plotPowerSpectrum(Vsound,Fs);
plotPowerSpectrum(VsoundFiltered,Fs);

% play original sound
%playSound(Vsound,Fs);

% play sound after circuit filter
%playSound(VsoundFiltered,Fs);
