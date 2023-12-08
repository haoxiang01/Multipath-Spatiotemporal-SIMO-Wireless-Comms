%...............................................
% Author: Haoxiang Huang, MSc CSP, IC. 
% Date: 08-Dec-2023.
% This is the Task1 design for the ACT CW PartB
%...............................................
clc;
clear;
close all;
addpath('Part_B\Wrappers\')
addpath('Part_B\Data\hh923\Task1\')

disp('........Initization: 3 Co-channel Transmiter.........');
disp('Load three Images for three Users');
load Rx1.mat
load Rx2.mat
load Rx3.mat
load Rx4.mat

Fc = 2.4e9; % Carrier frequency
Tcs = 5e-9; % Symbol duration
N = 4;      % Number of receiver
Pn = 5;     % Noise power
c = 3e8;    % Propagation speed
alpha = 2;  % Path Loss exponent
SNR = 20;   % SNR
Ts = 5e-9;  % Sampling period

