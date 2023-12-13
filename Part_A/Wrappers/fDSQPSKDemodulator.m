% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 05-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform demodulation of the received data using <INSERT TYPE OF RECEIVER>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (Fx1 Integers) = R channel symbol chips received
% goldseq (Wx1 Integers) = W bits of 1's and 0's representing the gold
% sequence of the desired signal to be used in the demodulation process
% phi (Integer) = Angle index in degrees of the QPSK constellation points
% delay (nx1 Integers) = Estimated delay for each path
% beta (Cx1 Integers) = Fading Coefficient for each path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% bitsOut (Px1 Integers) = P demodulated bits of 1's and 0's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [bitsOut]=fDSQPSKDemodulator(symbolsIn,GoldSeq,phi,delay,betas)
    GoldSeq = 1-2*GoldSeq;  % Transfer Gold Sequence from 0/1 to 1/-1
    
    if nargin <= 3
        symbolsDespread = symbolsIn;
    else
        len_goldseq = size(GoldSeq,1); % Length of the gold sequence
        len_symbolsIn = size(symbolsIn,1); % Length of the symbols with delay
        len_sig = floor(len_symbolsIn/len_goldseq);% Length of the original signal
        len_in = len_goldseq * len_sig ;% Length of symbols without delay
        len_delay = size(delay,1);% number of delay
        symbolsDespread = [];
        
        for i = 1:len_delay
            symbols = [];
            symbols = symbolsIn(delay(:,i)+1:delay(:,i)+len_in);
            symbols = reshape(symbols,len_goldseq,len_sig);
            symbolsDespread = [symbolsDespread;GoldSeq' * symbols];
        end

        % Max Ratio Combining
        symbolsDespread = conj(betas.')*symbolsDespread;
    end

    %% QPSK Demodulation Based on ML detection
    bitsOut = [];
    dist = [];
    for i = 1:length(symbolsDespread)
        % 00
        dist(1) = abs(symbolsDespread(i)-sqrt(2)*(cos(phi)+1i*sin(phi))); 
        % 01
        dist(2) = abs(symbolsDespread(i)-sqrt(2)*(cos(phi+pi/2)+1i*sin(phi+pi/2)));   
        % 11
        dist(3) = abs(symbolsDespread(i)-sqrt(2)*(cos(phi+pi)+1i*sin(phi+pi))); 
        % 10
        dist(4) = abs(symbolsDespread(i)-sqrt(2)*(cos(phi+3*pi/2)+1i*sin(phi+3*pi/2)));   
        % Find the index of minimum distance
        [~,index] = min(dist);                                                            
        bit_str = num2str(index);
        switch  bit_str
            % 00
            case '1'                                                                           
                bitsOut = [bitsOut;0;0];
            % 01
            case '2'                                                                          
                bitsOut = [bitsOut;0;1];
            % 11
            case '3'                                                                          
                bitsOut = [bitsOut;1;1];
            % 10
            case '4'                                                                          
                bitsOut = [bitsOut;1;0];
        end
    end
end

