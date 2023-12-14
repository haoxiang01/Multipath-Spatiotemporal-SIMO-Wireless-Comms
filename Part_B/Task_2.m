%...............................................
% + Author: Haoxiang Huang, MSc CSP, IC. 
% + Date: 08-Dec-2023.
% + This is the Task2 RSS Localisation design for the ACT CW PartB
% + Please execute this script in the directory: '..\PartB\'
% + Please ensure to include the util package 'Wrappers'
% + Ref: ACT-6 Slides P23-P24
%...............................................
clc;
clear;
close all;
addpath('Wrappers\');
addpath('Data\hh923\Task2\');

disp('................initialization................');
disp('Load four locations for 4 Rx');
load Rx1.mat
load Rx2.mat
load Rx3.mat
load Rx4.mat

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
disp('...................................................');
fprintf('\n');

%%  RSS localization
disp('..............Task-2 RSS Localisation................');
disp('Start RSS Association Stage');
PTx_dB = 150;
PTx = 10^(PTx_dB/10) * 10^-3; %Tx-Power
lambda = c/Fc;% Wavelength

rho = zeros(4,1);
rho(1) = fRSSAssociation(x1_RSS,PTx,lambda);
rho(2) = fRSSAssociation(x2_RSS,PTx,lambda);
rho(3) = fRSSAssociation(x3_RSS,PTx,lambda);
rho(4) = fRSSAssociation(x4_RSS,PTx,lambda);
disp(['The estimated rho (1-4) are: ',num2str(rho')]);

disp('Start RSS Metric Fusion Stage');
r_m = fRSSMetric(Rx,rho);
disp(['The location of the Tx is: ',num2str(r_m')]);
disp('...................................................');
fprintf('\n');
