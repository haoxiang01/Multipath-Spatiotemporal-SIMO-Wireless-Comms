% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 05-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform DS-QPSK Modulation on a vector of bits using a gold sequence
% with channel symbols set by a phase phi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% bitsIn (Px1 Integers) = P bits of 1's and 0's to be modulated
% goldseq (Wx1 Integers) = W bits of 1's and 0's representing the gold
% sequence to be used in the modulation process
% phi (Integer) = Angle index in degrees of the QPSK constellation points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% symbolsOut (Rx1 Complex) = R channel symbol chips after DS-QPSK Modulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [symbolsOut]=fDSQPSKModulator(bitsIn,goldseq,phi)
%% QPSK Modulation
%calculate length of the transmitted symbol squences
len_symbols = length(bitsIn)/2;
symbols = zeros(len_symbols);

for index = 1:len_symbols
    %2 bits per symbols
    bit_pairs = [num2str(bitsIn(2*index-1)),num2str(bitsIn(2*index))];
    switch bit_pairs
        case '00'
            symbols(index) = sqrt(2)*(cos(phi)+1i*sin(phi));
        case '01'
            symbols(index) = sqrt(2)*(cos(phi+pi/2)+1i*sin(phi+pi/2));
        case '11'
            symbols(index) = sqrt(2)*(cos(phi+pi)+1i*sin(phi+pi));
        case '10'
            symbols(index) = sqrt(2)*(cos(phi+3*pi/2)+1i*sin(phi+3*pi/2));
    end
end

%% DSSS
% convert Gold Sequence from 0/1 to 1/-1
goldseq_trans= 1-2*goldseq;
symbolsOut = goldseq * symbols;
symbolsOut = symbolsOut(:);
