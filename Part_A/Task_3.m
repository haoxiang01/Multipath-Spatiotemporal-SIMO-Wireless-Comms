%...............................................
% Author: Haoxiang Huang, MSc CSP, IC. 
% Date: 06-Dec-2023.
% This is the Task3 design for the ACT CW PartA
%...............................................

clc;
clear all;
close all;
addpath('Wrappers')

%% Initialization and Load transmitted images
img1_path = 'Photos\photo1.png';
img2_path = 'Photos\photo2.png';
img3_path = 'Photos\photo3.png';


disp('........Initization: 3 Co-channel Transmiter.........');
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

%% Task3(0dB)
fprintf('\n');
disp('..............Task-3 (SNR = 40 dB).................')
%  Channel Paramater
delays = [5;7;12];
betas = [.4 ; .7 ; .2];
DOAs = [30 0;90 0;150 0];
paths = [1,1,1];
%array = [0,0,0];
SNR = 0;
disp('.............Task-3 Channel Parameters..........');
disp(['SNR = ',num2str(SNR)]);
disp(['Delay = ',num2str(delays(1)),',',num2str(delays(2)),',',num2str(delays(3))]);
disp(['Beta = ',num2str(betas(1)),',',num2str(betas(2)),',',num2str(betas(3))]);
disp('...................................................');



%% Define Uniform Circular Array (UCA)
fprintf('\n')
disp('.............Task3 UCA STAR Receiver................');
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

disp('Transmit the images through this channel');
Rx_symbols = fChannel(paths,Tx_symbols,delays,betas,DOAs,SNR,cartesianArray);

%% Discretiser and Manifold Extender
disp('Start Discretiser and Manifold Extender');
N = 5; % Num of Antennas
N_ext = 2*N_c;% Extended Length
%Extended Signal
x_n = fMainfoldExtender(Rx_symbols.', N_c);

%% STAR Channel Estimation
disp('Start STAR Channel Estimation');
[delay_estimate,DOA_estimate] = fChannelEstimation(x_n,Balanced_GoldSeq1,paths(1),cartesianArray);
disp(['The estimated Photo-1 delay are : ',num2str(delay_estimate)]);
disp(['The estimated Photo-1 DOAs (theta, phi) are : ',num2str(reshape(DOA_estimate',1,numel(DOA_estimate)))]);

%% STAR Beamformer
disp('Start STAR Beamformer');
y_n = fSTARBeamformer(x_n,cartesianArray,Balanced_GoldSeq1,delay_estimate,DOA_estimate,betas(1:paths(1)));

disp('Start DSSS-QPSK Demodulation');

Rx_bitstreams = fDSQPSKDemodulator(y_n.',Balanced_GoldSeq1,phi);
[~,BER_40db] = biterr(Rx_bitstreams, bitstream_img1);
disp(['BER = ',num2str(BER_40db)]);
figure();
fImageSink(Rx_bitstreams, Q1,x1,y1);
title({'Task3';'STAR Receiver: Desired Received Photo1 '; ['SNR=',num2str(SNR),' dB , ','BER=',num2str(BER_40db)]});
disp('...................................................');
fprintf('\n');