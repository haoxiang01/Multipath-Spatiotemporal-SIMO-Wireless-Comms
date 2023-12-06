%...............................................
% Author: Haoxiang Huang, MSc CSP, IC. 
% Date: 05-Dec-2023.
% This is the Task1 design for the ACT CW PartA
%...............................................
clc;
clear all;
close all;
addpath('Wrappers')

%% Initialization and Load transmitted images
img1_path = 'Photos\photo1.png';
img2_path = 'Photos\photo2.png';
img3_path = 'Photos\photo3.png';


disp('Load three Images for three Users');
Image1 = imread(img1_path);
Image2 = imread(img2_path);
Image3 = imread(img3_path);
figure;
subplot(1,3,1);
imshow(Image1);
title('Original Desired Image (User1)');
subplot(1,3,2);
imshow(Image2);
title('Original Interference Image (User2)')
subplot(1,3,3);
imshow(Image3);
title('Original Interference Image (User3)')
[x1,y1,~] = size(Image1);
[x2,y2,~] = size(Image2);
[x3,y3,~] = size(Image3);

Q1 = x1*y1*3*8;
Q2 = x2*y2*3*8;
Q3 = x3*y3*3*8;
P = max([Q1,Q2,Q3]);

bitstream_img1 = fImageSource(img1_path,P);
bitstream_img2 = fImageSource(img2_path,P);
bitstream_img3 = fImageSource(img3_path,P);

%% DSSS-QPSK Modulation
disp('........Initization: 3 Co-channel Transmiter.........');
disp('Start DSSS-QPSK Modulation');
X = 8; %alphabetical order of the 1st letter H of my surname Huang.
Y = 8; %alphabetical order of the 1st letter H of my formal firstname Haoxiang.

% generate coefficients
coeffs1 = [1 0 0 1 1]'; %D^4 + D + 1
coeffs2 = [1 1 0 0 1]'; %D^4 + D^3 + 1

%generate m sequence
mSeq1= fMSeqGen(coeffs1);
mSeq2= fMSeqGen(coeffs2);

% degree m
m = length(coeffs1) - 1; 

% maximum period of the shift register
N_c = 2.^m - 1; 

% generate all possible the Gold Sequences
GoldSeq_buffer = [];

for index = 1:N_c
    GoldSeq_buffer = [GoldSeq_buffer fGoldSeq(mSeq1,mSeq2,index)];
end
GoldSeq_buffer = [GoldSeq_buffer mSeq1 mSeq2];
GoldSeq_buffer_trans = 1-2.*GoldSeq_buffer;

% calculate shift delay of the sencond m seqence
delay_threshold = 1 + mod(X + Y,12);
delay=0;

% find Balanced Gold Sequence delay index with satisfied condition
for index = 1:N_c+2
    if sum(GoldSeq_buffer_trans(:,index)) == -1 && index>= delay_threshold
        delay = index;
        break
    end
end

% find the Balanced Gold Sequence for 3 users
Balanced_GoldSeq1 = GoldSeq_buffer(:,delay);
Balanced_GoldSeq2 = GoldSeq_buffer(:,delay+1);
Balanced_GoldSeq3 = GoldSeq_buffer(:,delay+2);

%calculate the angle for DS-QPSK modulation
phi = (X+2*Y) * pi/180;

%get the symbols of transmitted three user images
symbols_img1 = fDSQPSKModulator(bitstream_img1, Balanced_GoldSeq1, phi);
symbols_img2 = fDSQPSKModulator(bitstream_img2, Balanced_GoldSeq2, phi);
symbols_img3 = fDSQPSKModulator(bitstream_img3, Balanced_GoldSeq3, phi);
Tx_symbols = [symbols_img1,symbols_img2,symbols_img3];
disp('...................................................');
fprintf('\n');

%% Task-1a (SNR = 0 dB)
disp('..............Task-1a (SNR = 0 dB).................')
%  Channel Paramater
delays = [5;7;12];
betas = [.4 ; .7 ; .2];
DOAs = [30 0;90 0;150 0];
paths = [1,1,1];
array = [0,0,0];
SNR = 0;
disp('.............Task-1a Channel Parameters..........');
disp(['SNR = ',num2str(SNR)]);
disp(['Delay = ',num2str(delays(1)),',',num2str(delays(2)),',',num2str(delays(3))]);
disp(['Beta = ',num2str(betas(1)),',',num2str(betas(2)),',',num2str(betas(3))]);
disp('...................................................');
disp('Transmit the images through this channel');
Rx_symbols = fChannel(paths,Tx_symbols,delays,betas,DOAs,SNR,array);

%%  Task-1b RAKE Receiver Design
fprintf('\n');
disp('..............Task-1b Rake Receiver................');
disp('Start Channel Estimation');
delay_estimate1 = fChannelEstimation(Rx_symbols,Balanced_GoldSeq1,paths(1));
disp(['The estimated photo-1 transmittion delay is: ',num2str(delay_estimate1)])
disp('Start DSSS-QPSK Demodulation');
Rx_bitstreams = fDSQPSKDemodulator(Rx_symbols,Balanced_GoldSeq1,phi,delay_estimate1,betas(1));
[~,BER_0db] = biterr(Rx_bitstreams, bitstream_img1);
disp(['BER = ',num2str(BER_0db)]);
figure();
fImageSink(Rx_bitstreams, Q1,x1,y1);
title({' Received Desired Image'; ['SNR=',num2str(SNR),'dB ,','BER=',num2str(BER_0db)]});
disp('...................................................');
fprintf('\n');


%% Task-1a (SNR = 40 dB)
disp('..............Task-1a (SNR = 40 dB).................')
%  Channel Paramater
delays = [5;7;12];
betas = [.4 ; .7 ; .2];
DOAs = [30 0;90 0;150 0];
paths = [1,1,1];
array = [0,0,0];
SNR = 40;
disp('.............Task-1a Channel Parameters..........');
disp(['SNR = ',num2str(SNR)]);
disp(['Delay = ',num2str(delays(1)),',',num2str(delays(2)),',',num2str(delays(3))]);
disp(['Beta = ',num2str(betas(1)),',',num2str(betas(2)),',',num2str(betas(3))]);
disp('...................................................');
disp('Transmit the images through this channel');
Rx_symbols = fChannel(paths,Tx_symbols,delays,betas,DOAs,SNR,array);

%%  Task-1b RAKE Receiver Design
fprintf('\n');
disp('..............Task-1b Rake Receiver................');
disp('Start Channel Estimation');
delay_estimate1 = fChannelEstimation(Rx_symbols,Balanced_GoldSeq1,paths(1));
disp(['The estimated photo-1 transmittion delay is: ',num2str(delay_estimate1)])
disp('Start DSSS-QPSK Demodulation');
Rx_bitstreams = fDSQPSKDemodulator(Rx_symbols,Balanced_GoldSeq1,phi,delay_estimate1,betas(1));
[~,BER_40db] = biterr(Rx_bitstreams, bitstream_img1);
disp(['BER = ',num2str(BER_40db)]);
figure();
fImageSink(Rx_bitstreams, Q1,x1,y1);
title({' Received Desired Image'; ['SNR=',num2str(SNR),'dB ,','BER=',num2str(BER_40db)]});
disp('...................................................');
fprintf('\n');