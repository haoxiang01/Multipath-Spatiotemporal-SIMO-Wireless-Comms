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



