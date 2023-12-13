% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 05-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performs channel estimation for the desired source using the received signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (FxM Complex) = R channel symbol chips received. if no
% arrays, M=1.
% goldseq (Wx1 Integers) = W bits of 1's and 0's representing the gold
% sequence of the desired source used in the modulation process
% pathNum (Px1 Intergers) = The number of path of desired signal
% cartesianArray (Nx3 Double) = The cartesian location of array with half-wavelength
% inter antenna spacing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% delay_estimate = Vector of estimates of the delays of each path of the
% desired signal
% DOA_estimate = Estimates of the azimuth and elevation of each path of the
% desired signal
% beta_estimate = Estimates of the fading coefficients of each path of the
% desired signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [delay_estimate, DOA_estimate, beta_estimate]=fChannelEstimation(symbolsIn,goldseq,pathNum,cartesianArray)
    goldseq = (1 - 2*goldseq);% convert from 0/1 to -1/1
    len_goldseq = size(goldseq,1); % length of the gold sequence

    %Single Attennas
    if nargin <= 3 
        len_symbolsIn = size(symbolsIn,1); % Length of the symbols with delay
        len_sig = floor(len_symbolsIn/len_goldseq);% Length of the original signal
        len_in = len_goldseq * len_sig ;% Length of symbols without delay
        d_max = len_symbolsIn - len_in ;% the maximum relative delay
        
        %correlator based on max power
        powers = zeros(d_max+1,1); %delay range (0-dmax),so dmax+1 items
        
        for d_i = 1:d_max+1
            start = d_i;
            endpoint = len_in +  d_i-1;
            symbols = reshape(symbolsIn(start:endpoint),len_goldseq,len_sig);
            powers(d_i) = mean(abs(goldseq' * symbols));
        end

        %find the most simlar signal
        [~,delay_estimate] = maxk(powers, pathNum);
        delay_estimate = sort(delay_estimate - 1);
        delay_estimate = delay_estimate.';

    % Array Antenna (STAR Channel Estimation)
    else
        [N, L] = size(symbolsIn);
        N_c = len_goldseq;
        N_ext = 2*N_c;
        
        %Shift matrix
        J = [zeros(1,N_ext-1),0;eye(N_ext-1),zeros(N_ext-1,1)];
        c = [goldseq;zeros(N_c,1)];
        Rxx = symbolsIn*symbolsIn'/L;
        M = fMDL(Rxx,N,L);
        Cost = fMuSIC(Rxx,c,M,N_c,cartesianArray,J);
        %   Estimate the delay and DOA from the peak (MAX) of the Cost
        [maxValue,~] = maxk(max(real(Cost)),pathNum);
        index = [];
         for i = 1:pathNum
                index = [index find(maxValue(i) == real(Cost))];
         end
         delay_estimate = floor(index/181);
         DOA_estimate = [(index - delay_estimate*181 - 1).' zeros(pathNum,1)];
    end
end