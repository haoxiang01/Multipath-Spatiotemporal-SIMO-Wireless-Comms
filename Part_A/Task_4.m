%...............................................
% Author: Haoxiang Huang, MSc CSP, IC. 
% Date: 07-Dec-2023.
% This is the Task4 design for the ACT CW PartA
%...............................................
clc;
clear all;
close all;
addpath('Wrappers');
addpath('Data');
load hh923_fastfading.mat

% generate coefficients
coeffs1 = [1 0 0 1 0 1]';%D^5 + D^2 + 1
coeffs2 = [1 0 1 1 1 1]';%D^5 + D^3 + D + 1

%generate m sequence
mSeq1= fMSeqGen(coeffs1);
mSeq2= fMSeqGen(coeffs2);
GoldSeq1 = fGoldSeq(mSeq1,mSeq2,phase_shift);

%%Task4
%% Define Uniform Circular Array (UCA)
disp('..........Task4 UCA STAR Receiver with Personal data.............');
disp('Deploy Uniform Circular Array (UCA)')
%the differece of each angle
delta_angle = 2*pi/5;
% radius of the UCA
r = 1/(2*sin(delta_angle/2));
angle0 = pi/6;
angles = angle0 + (0:4)*delta_angle;
polarArray = r * exp(1i * angles);
cartesianArray = [real(polarArray); imag(polarArray); zeros(1, length(polarArray))]';
figure(2);
plot(cartesianArray(:, 1), cartesianArray(:, 2), 'xr', ...
    'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'r');
hold on;
plot(0, 0, '+k', 'MarkerSize', 10, 'LineWidth', 2);
for i = 1:size(cartesianArray, 1)
    plot([0, cartesianArray(i, 1)], [0, cartesianArray(i, 2)], '--k'); 
end
angleText = sprintf('%.2f°', rad2deg(2*pi/5));
text(0, 0, angleText, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

legend('Antenna', 'FontSize', 12); 
xlabel('X', 'FontSize', 14); 
ylabel('Y', 'FontSize', 14);
axis([-1 1 -1 1]);
title('The Distribution of UCA', 'FontSize', 16); 

set(gca, 'FontSize', 12); 
set(gcf, 'Color', 'w'); 
grid on;

%% Discretiser and Manifold Extender
disp('Start Discretiser and Manifold Extender');
N = 5; % Num of Antennas
N_c = length(GoldSeq1);
N_ext = 2*N_c;% Extended Length
%Extended Signal
x_n = fMainfoldExtender(Xmatrix, N_c);

%% STAR Channel Estimation
disp('Start STAR Channel Estimation');
PathNum = 3;
[delay_estimate,DOA_estimate] = fChannelEstimation(x_n,GoldSeq1,PathNum,cartesianArray);
disp(['The estimated delay are : ',num2str(delay_estimate)]);
disp(['The estimated DOAs (theta, phi) are : ',num2str(reshape(DOA_estimate',1,numel(DOA_estimate)))]);

%% STAR Beamformer
disp('Start STAR Beamformer');
y_n = fSTARBeamformer(x_n,cartesianArray,GoldSeq1,delay_estimate,DOA_estimate,Beta_1);

disp('Start DS-QPSK Demodulation');
Rx_bitstreams = fDSQPSKDemodulator(y_n.',GoldSeq1,phi_mod);

%%  Print the text
%Convert the bitstream to binary numbers
nBits = length(Rx_bitstreams);
if mod(nBits, 8) ~= 0
    nBitsToKeep = nBits - mod(nBits, 8); 
    Rx_bitstreams = Rx_bitstreams(1:nBitsToKeep); 
end
binValues = reshape(Rx_bitstreams, 8, [])'; 
decValues = bi2de(binValues, 'left-msb'); 
str = char(decValues)';
disp('The received text-message is :');
disp(str);
