%...............................................
% + Author: Haoxiang Huang, MSc CSP, IC. 
% + Date: 06-Dec-2023.
% + This is the Task2 design for the ACT CW PartA
% + Please execute this script in the directory: '..\PartA\'
% + Please ensure to include the util package 'Wrappers'
%   and 'Photos' folder
% + For more information, please see Readme.md file 
%...............................................

clc;
clear;
close all;

%add the environment path of util packages
addpath('Wrappers')

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
fprintf('\n');

%% Task-2a (SNR = 0 dB)
disp('..............Task-2a (SNR = 0 dB).................');
%  Channel Paramater
delays = [mod(X+Y,4); 4 + mod(X+Y,5); 9 + mod(X+Y,6); 8; 13];
betas = [.8 ; .4*exp(-1i*40*pi/180) ; .8*exp(1i*80*pi/180); 0.5 ; 0.2];
DOAs = [30 0; 45 0; 20 0; 80 0; 150 0;];
paths = [3,1,1];
array = [0,0,0];
SNR = 0;
disp('..............Task-2a Channel Parameters............');
disp(['SNR = ',num2str(SNR)]);
disp(['Delay = ',num2str(delays(1)),', ',num2str(delays(2)),', ',num2str(delays(3)), ...
    ', ' , num2str(delays(4)),', ' , num2str(delays(5))]);
disp(['Beta = ',num2str(betas(1)),', ',num2str(betas(2)),', ',num2str(betas(3)) ...
       ,', ',num2str(betas(4)),', ',num2str(betas(5))]);
disp('...................................................');
disp('Transmit the images through this channel');
Rx_symbols = fChannel(paths,Tx_symbols,delays,betas,DOAs,SNR,array);

%%  Task-1b RAKE Receiver Design
fprintf('\n');
disp('..............Task-1b Rake Receiver................');
disp('Start Channel Estimation');

% Perform channel estimation 
delay_estimate1 = fChannelEstimation(Rx_symbols, Balanced_GoldSeq(:, 1), paths(1));
disp(['The estimated photo-1 transmition delay is: ',num2str(delay_estimate1)]);
disp('Start DSSS-QPSK Demodulation');

% Demodulate
Rx_bitstreams = fDSQPSKDemodulator(Rx_symbols, Balanced_GoldSeq(:, 1), phi, delay_estimate1,betas(1));

% Calculate the Bit Error Rate (BER)
[~,BER_0db] = biterr(Rx_bitstreams, bitstream_img1);

% Print and plot
disp(['BER = ',num2str(BER_0db)]);
figure();
fImageSink(Rx_bitstreams, bits(1), widths(1),heights(1));
title({'Task2-Multipath';'Rake Receiver: Desired Received Photo1 '; ['SNR=',num2str(SNR),' dB , ','BER=',num2str(BER_0db)]});
disp('...................................................');
fprintf('\n');


%% Task-2b (SNR = 40 dB)
disp('..............Task-2b (SNR = 40 dB).................');
%  Channel Paramater
delays = [mod(X+Y,4); 4 + mod(X+Y,5); 9 + mod(X+Y,6); 8; 13];
betas = [.8 ; .4*exp(-1i*40*pi/180) ; .8*exp(1i*80*pi/180); 0.5 ; 0.2];
DOAs = [30 0; 45 0; 20 0; 80 0; 150 0;];
paths = [3,1,1];
array = [0,0,0];
SNR = 40;
disp('..............Task-2b Channel Parameters............');
disp(['SNR = ',num2str(SNR)]);
disp(['Delay = ',num2str(delays(1)),', ',num2str(delays(2)),', ',num2str(delays(3)), ...
    ', ' , num2str(delays(4)),', ' , num2str(delays(5))]);
disp(['Beta = ',num2str(betas(1)),', ',num2str(betas(2)),', ',num2str(betas(3)) ...
       ,', ',num2str(betas(4)),', ',num2str(betas(5))]);
disp('...................................................');
disp('Transmit the images through this channel');
Rx_symbols = fChannel(paths,Tx_symbols,delays,betas,DOAs,SNR,array);

%%  Task-1b RAKE Receiver Design
fprintf('\n');
disp('..............Task-1b Rake Receiver................');
disp('Start Channel Estimation');

% Perform channel estimation 
delay_estimate1 = fChannelEstimation(Rx_symbols, Balanced_GoldSeq(:, 1), paths(1));
disp(['The estimated photo-1 transmition delay is: ',num2str(delay_estimate1)]);
disp('Start DSSS-QPSK Demodulation');

% Demodulate
Rx_bitstreams = fDSQPSKDemodulator(Rx_symbols, Balanced_GoldSeq(:, 1), phi,delay_estimate1,betas(1));

% Calculate the Bit Error Rate (BER)
[~,BER_0db] = biterr(Rx_bitstreams, bitstream_img1);

% Print and plot
disp(['BER = ',num2str(BER_0db)]);
figure();
fImageSink(Rx_bitstreams, bits(1), widths(1),heights(1));
title({'Task2-Multipath';'Rake Receiver: Desired Received Photo1 '; ['SNR=',num2str(SNR),' dB , ','BER=',num2str(BER_0db)]});
disp('...................................................');
fprintf('\n');

