%...............................................
% + Author: Haoxiang Huang, MSc CSP, IC. 
% + Date: 06-Dec-2023.
% + This is the Task3 design for the ACT CW PartA
% + Please execute this script in the directory: '..\PartA\'
% + Please ensure to include the util package 'Wrappers'
%   and 'Photos' folder
% + In Task3, you need to enter your interested SNR values. 
%   If you only care about the SNR = 0 situations, you can 
%   enter any non-numeric values (like blank, enter…)
% + For more information, please see Readme.md file 
%...............................................

clc;
clear;
close all;
%add the environment path of util packages
addpath('Wrappers')

%% Read SNR from User
disp('First, please set your desired SNR (dB).')
disp('You can enter any non-numeric value to defaultly set SNR to 0 dB')
inputValue = input('Enter SNR (dB) value: ', 's'); % Read input as a string

% Check if the input is numeric and not empty
if isempty(str2num(inputValue))
    % If input is non-numeric or empty, set SNR to 0
    SNR = 0;
else
    % Convert the input string to a numeric value
    SNR = str2num(inputValue);
end

% Display the SNR value
disp(['SNR is set to: ', num2str(SNR),' dB']);

%% Initialization and Load transmitted images
%image environment path 
img1_path = 'Photos\photo1.png';
img2_path = 'Photos\photo2.png';
img3_path = 'Photos\photo3.png';

disp('........Initization: 3 Co-channel Transmiter.........');
disp('Load three Images for three Users');
% set the maximum width and height limits for the image
% here limitation is required by the official doc
width_limit = 160;
height_limit = 112;

% read and display images
[bits,widths,heights] = fShowImg(img1_path,img2_path,img3_path,width_limit,height_limit);

%the maximum number of bits required for the image
bitsMax = max(widths) * max(heights) * 3 * 8;

%imgs to bitstream
bitstream_img1 = fImageSource(img1_path,bitsMax);
bitstream_img2 = fImageSource(img2_path,bitsMax);
bitstream_img3 = fImageSource(img3_path,bitsMax);

%% DS-QPSK Modulation
disp('Start DS-QPSK Modulation');
X = 8; %alphabetical order of the 1st letter H of my surname Huang.
Y = 8; %alphabetical order of the 1st letter H of my formal firstname Haoxiang.

% generate coefficients
coeffs1 = [1 0 0 1 1]'; %D^4 + D + 1
coeffs2 = [1 1 0 0 1]'; %D^4 + D^3 + 1

%Generate Balanced Gold Sequence
Balanced_GoldSeq = fBGoldseq(X,Y,coeffs1,coeffs2);

%calculate the angle for DS-QPSK modulation
phi = (X+2*Y) * pi/180;

%get the mapped symbols of transmitted three user images using DS-QPSK
symbols_img1 = fDSQPSKModulator(bitstream_img1, Balanced_GoldSeq(:, 1), phi);
symbols_img2 = fDSQPSKModulator(bitstream_img2, Balanced_GoldSeq(:, 2), phi);
symbols_img3 = fDSQPSKModulator(bitstream_img3, Balanced_GoldSeq(:, 3), phi);
Tx_symbols = [symbols_img1,symbols_img2,symbols_img3];
disp('...................................................');

%% Task3(0dB)
fprintf('\n');
disp(['..............Task-3 (SNR = ' num2str(SNR) ' dB).................'])
%  Channel Paramater
delays = [5;7;12];
betas = [.4 ; .7 ; .2];
DOAs = [30 0;90 0;150 0];
paths = [1,1,1];
disp('.............Task-3 Channel Parameters..........');
disp(['SNR = ',num2str(SNR)]);
disp(['Delay = ',num2str(delays(1)),', ',num2str(delays(2)),', ',num2str(delays(3))]);
disp(['Beta = ',num2str(betas(1)),', ',num2str(betas(2)),', ',num2str(betas(3))]);
disp(['DOAs (Theta) = ',num2str(DOAs(1)),', ',num2str(DOAs(2)),', ',num2str(DOAs(3))]);
disp('...................................................');



%% Define Uniform Circular Array (UCA)
fprintf('\n')
disp('.............Task-3 UCA STAR Receiver................');
disp('Deploy Uniform Circular Array (UCA)')
% 1st antenna degree with respect to x-axis
angle0 = pi/6;

% Number of the Rx antennas
N_Rx= 5;

% Model UCA
cartesianArray = fUCA(N_Rx,angle0);

%Transmitting
disp('Transmit the images through this channel');
Rx_symbols = fChannel(paths,Tx_symbols,delays,betas,DOAs,SNR,cartesianArray);

%% Discretiser and Manifold Extender
disp('Start Discretiser and Manifold Extender');
% degree m
m = length(coeffs1) - 1; 

% maximum period of the shift register
N_c = 2.^m - 1; 

% Extended Length
N_ext = 2*N_c;

%Extended Signal
x_n = fMainfoldExtender(Rx_symbols.', N_c);

%% STAR Channel Estimation
disp('Start STAR Channel Estimation');

% Perform channel estimation
[delay_estimate,DOA_estimate] = fChannelEstimation(x_n, Balanced_GoldSeq(:, 1), paths(1),cartesianArray);

disp(['The estimated Photo-1 delay are : ',num2str(delay_estimate)]);
disp(['The estimated Photo-1 DOAs (theta, phi) are : ',num2str(reshape(DOA_estimate',1,numel(DOA_estimate)))]);

%% STAR Beamformer
disp('Start STAR Beamformer');
y_n = fSTARBeamformer(x_n,cartesianArray, Balanced_GoldSeq(:, 1), delay_estimate,DOA_estimate,betas(1:paths(1)));

%% Demodulate
disp('Start DS-QPSK Demodulation');
Rx_bitstreams = fDSQPSKDemodulator(y_n.', Balanced_GoldSeq(:, 1),phi);

% Calculate the Bit Error Rate (BER)
[~,BER_0db] = biterr(Rx_bitstreams, bitstream_img1);
disp(['BER = ',num2str(BER_0db)]);
figure();
fImageSink(Rx_bitstreams, bits(1), widths(1),heights(1));
title({'Task3';'STAR Receiver: Desired Received Photo1 '; ['SNR=',num2str(SNR),' dB , ','BER=',num2str(BER_0db)]});
disp('...................................................');
fprintf('\n');