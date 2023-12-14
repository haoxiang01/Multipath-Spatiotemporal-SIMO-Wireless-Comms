%...............................................
% Author: Haoxiang Huang, MSc CSP, IC. 
% Date: 08-Dec-2023.
% This is the Task3 design for the ACT CW PartB
% + Please execute this script in the directory: '..\PartB\'
% + Please ensure to include the util package 'Wrappers'
% + Ref: ACT-6 Slides P42-P47
%...............................................

clc;
clear;
close all;
addpath('Wrappers\');
addpath('Data\hh923\Task3\');

disp('................initialization................');
disp('Load four locations for 4 Rx');
load Xmatrix_1_DFarray.mat
load Xmatrix_2_DFarray.mat
load Xmatrix_3_DFarray.mat
load Xmatrix_4_DFarray.mat

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
r_UCA = [   0.1250 0 0;
            0.0625 0.1083 0;
            -0.0625 0.1083 0;
            -0.125 0 0;
            -0.0625 -0.1083 0;
            0.0625 -0.1083 0]/(lamda/2);% convert from meters to half wavelength
disp('.......................................................');
fprintf('\n');


%%  DOA localization
disp('..............Task-3 DOA Localisation................');
disp('Start DOA Association Stage');
x_DOAs = [x1_DOA; x2_DOA; x3_DOA; x4_DOA];
[rho,DOAs] = fDOAAssociation(x_DOAs,Rx,r_UCA);

disp(['The estimated rho (1-4) are: ',num2str(rho')]);

disp('Start DOA Metric Fusion Stage');
r_m = fDOAMetric(Rx,rho,DOAs);
disp(['The location of the Tx is: ',num2str(r_m')]);
disp('...................................................');
fprintf('\n');
