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
img1_path = 'Photos\photo1.jpg';
img2_path = 'Photos\photo2.jpg';
img3_path = 'Photos\photo3.jpg';

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

bitstream1 = fImageSource(img1_path,P);
bitstream2 = fImageSource(img2_path,P);
bitstream3 = fImageSource(img3_path,P);

%% DSSS-QPSK Modulation
disp('DSSS-QPSK Modulation');
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



