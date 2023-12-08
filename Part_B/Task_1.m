%...............................................
% Author: Haoxiang Huang, MSc CSP, IC. 
% Date: 08-Dec-2023.
% This is the Task1 design for the ACT CW PartB
%...............................................
clc;
clear;
close all;
addpath('Wrappers\');
addpath('Data\hh923\Task1\');

disp('......Initization: 1 unknown Transmiter and 4 known Receiver .......');
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

%%  TOA Localisation
t0 = 20 * Ts; % known the time of starting
disp('..............Task-1a TOA Localisation................');
disp('Start TOA Association Stage');
rho = zeros(4,1);
[rho(1),t1] = fTOAAssociation(x1_Time,Ts,t0);
[rho(2),t2] = fTOAAssociation(x2_Time,Ts,t0);
[rho(3),t3] = fTOAAssociation(x3_Time,Ts,t0);
[rho(4),t4] = fTOAAssociation(x4_Time,Ts,t0);
disp(['The estimated rho (1-4) are: ',num2str(rho')]);

disp('Start TOA Metric Fusion Stage');
r_m = fTOAMetric(Rx,rho);
disp(['The location of the Tx is: ',num2str(r_m')]);
disp('...................................................');
fprintf('\n');

%% TDOA Localisation
disp('Start TDOA Association Stage');
rhoi1 = zeros(3,1);
rhoi1(1) = (t2 - t1) * c;
rhoi1(2) = (t3 - t1) * c;
rhoi1(3) = (t4 - t1) * c;

disp('Start TDOA Metric Fusion Stage');
r_m = fTDOAMetric(Rx,rhoi1);
disp(['The location of the Tx is : ',num2str(r_m')]);
