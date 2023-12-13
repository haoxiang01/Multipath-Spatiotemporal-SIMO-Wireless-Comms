% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 05-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Models the channel effects in the system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% paths (Mx1 Integers) = Number of paths for each source in the system.
% For example, if 3 sources with 1, 3 and 2 paths respectively then
% paths=[1;3;2]
% symbolsIn (MxR Complex) = Signals being transmitted in the channel
% delay (Cx1 Integers) = Delay for each path in the system starting with
% source 1
% beta (Cx1 Integers) = Fading Coefficient for each path in the system
% starting with source 1
% DOA = Direction of Arrival for each source in the system in the form
% [Azimuth, Elevation]
% SNR = Signal to Noise Ratio in dB
% array = Array locations in half unit wavelength. If no array then should
% be [0,0,0]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% symbolsOut (FxN Complex) = F channel symbol chips received from each antenna
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [symbolsOut]=fChannel(paths,symbolsIn,delay,beta,DOA,SNR,array)
%% Parameters
% number of Tx
num_Tx = size(symbolsIn,2); 

% length of the transmitted symbols
len_in = size(symbolsIn,1);  
% length of the received symbols
len_out = len_in + max(delay);

% number of antennas
N = size(array,1); 

% index for each path in the system 
% starting with source 1
paths_index = 1;

% received symbols
symbolsOut = zeros(len_out, N);

%% Transmiting through channel
% use defin in ACT-3 slides p52
for i = 1:num_Tx
    % if paths(i) > 1 muti-path
    for j = 1:paths(i)
        % get the message signal of current path by delay and scaling
        m_t = zeros(len_out,1);
        m_t(1 + delay(paths_index) : len_in + delay(paths_index)) = symbolsIn(:,i);
        % channel muitpath impusle response(Manifold vector * fadding coeff)
        S = beta(i) * spv(array,DOA(paths_index,:));
        % received signal 
        x_t = S.' .* m_t;
        % add to the current channel stream
        symbolsOut = symbolsOut + x_t;
        paths_index = paths_index + 1;
    end
end

%% Add AWGN
% desired signal power
Pd_dB = 10*log10(sum(abs((beta(1:paths(1)) .* symbolsIn(1,1))).^2)); 

% noise power
Pn_dB = Pd_dB - SNR; 
Pn = 10.^(Pn_dB/10);
% AWGN noise
noise = sqrt(Pn/2) * (randn(size(symbolsOut)) + 1i * randn(size(symbolsOut)));
% add noise
symbolsOut = symbolsOut + noise;                     
end

