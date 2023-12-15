%...............................................
% + Author: Haoxiang Huang, MSc CSP, IC. 
% + Date: 09-Dec-2023.
% + This is the Task4 LAA Localisation design for the ACT CW PartB
% + Please execute this script in the directory: '..\PartB\'
% + Please ensure to include the util package 'Wrappers'
% + Ref: ACT-6 Slides P56-P60
% + Please ensure to include the util package 'Wrappers' and 'Data' folder
% + For more information, please see Readme.md file 
%...............................................

clc;
clear;
close all;
addpath('Wrappers\');
addpath('Data\hh923\Task4\');

disp('................initialization................');
disp('Load four locations for 4 Rx');
load Xmatrix_LAA_1.mat
load Xmatrix_LAA_2.mat
load Xmatrix_LAA_3.mat
load Xmatrix_LAA_4.mat

disp('Set up System Parameters');
Fc = 2.4e9; % Carrier frequency
Tcs = 5e-9; % Symbol duration
N = 4;      % Number of Rx
sigma_2 = 5;% Noise power
c = 3e8;    % Propagation speed
alpha = 2;  % Path Loss exponent
SNR = 20;   % SNR
Ts = 5e-9;  % Sampling period
Rx = [0,0; 60,-88; 100,9;60,92];% Locations of Rxs
lamda = c/Fc;                   % Wavelength
x_LAA = [x1_LAA;x2_LAA;x3_LAA;x4_LAA]; 
disp('.......................................................');
fprintf('\n');

disp('..............Task-4 LAA Localisation................');
disp('Start LAA Association Stage');
K = fLAAAssociation(x_LAA,alpha,N);

disp('Start LAA Metric Fusion Stage');
r_m = fLAAMetric(K,Rx);
disp(['The location of the Tx is: ',num2str(r_m')]);
disp('...................................................');
fprintf('\n');
