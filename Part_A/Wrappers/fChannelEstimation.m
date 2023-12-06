% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 05-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performs channel estimation for the desired source using the received signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (Fx1 Complex) = R channel symbol chips received
% goldseq (Wx1 Integers) = W bits of 1's and 0's representing the gold
% sequence of the desired source used in the modulation process
% pathnum (Nx1 Intergers) = The number of path of desired signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% delay_estimate = Vector of estimates of the delays of each path of the
% desired signal
% DOA_estimate = Estimates of the azimuth and elevation of each path of the
% desired signal
% beta_estimate = Estimates of the fading coefficients of each path of the
% desired signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [delay_estimate, DOA_estimate, beta_estimate]=fChannelEstimation(symbolsIn,goldseq,pathNum)
goldseq = (1 - 2*goldseq);% convert from 0/1 to -1/1
len_goldseq = size(goldseq,1); % Length of the gold sequence
len_symbolsIn = size(symbolsIn,1); % Length of the symbols with delay
len_sig = floor(len_symbolsIn/len_goldseq);% Length of the original signal
len_in = len_goldseq * len_sig ;% Length of symbols without delay
d_max = len_symbolsIn - len_in ;% the maximum relativedelay

%correlator based on max power
powers = zeros(d_max+1,1); %0-dmax,so dmax+1 items
for d_i = 1:d_max+1
    start = d_i;
    endpoint = len_in +  d_i-1;
    symbols = reshape(symbolsIn(start:endpoint),len_goldseq,len_sig);
    powers(d_i) = mean(abs(goldseq' * symbols));
end
[~,delay_estimate] = maxk(powers, pathNum);
delay_estimate = sort(delay_estimate - 1);
delay_estimate = delay_estimate.';
end