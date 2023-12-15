%...............................................
% + Author: Haoxiang Huang, MSc CSP, IC. 
% + Date: 07-Dec-2023.
% + This is the Task4 design for the ACT CW PartA
% + Please execute this script in the directory: '..\PartA\'
% + Please ensure to include the util package 'Wrappers'
%   and 'Data' folder
% + For more information, please see Readme.md file 
%...............................................

clc;
clear;
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
% 1st antenna degree with respect to x-axis
angle0 = pi/6;

% Number of the Rx antennas
N_Rx= 5;

% Model UCA
cartesianArray = fUCA(N_Rx,angle0);

%% Discretiser and Manifold Extender
disp('Start Discretiser and Manifold Extender');
N = 5; % Num of Antennas
N_c = length(GoldSeq1);
N_ext = 2 * N_c;% Extended Length

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
%Convert the bitstream to string
str = fbit2str(Rx_bitstreams);
disp('The received text-message is :');
disp(str);
