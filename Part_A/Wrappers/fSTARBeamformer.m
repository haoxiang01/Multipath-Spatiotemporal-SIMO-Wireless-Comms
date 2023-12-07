% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 07-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform Spatiotemporal Rake Beamformer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (N_ext x N x L Complex) = The extended input symbols
% array = The cartesian location of array with half-wavelength
% goldseq (Wx1 Integers) = W bits of 1's and 0's representing the gold
% sequence to be used in the modulation process
% pathnum (nx1 Intergers) = The number of path of desired signal
% delay (Cx1 Integers) = Delay for each path in the system starting with
% source 1
% beta (Cx1 Integers) = Fading Coefficient for each path in the system
% starting with source 1
% DOA = Direction of Arrival for each source in the system in the form
% [Azimuth, Elevation]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% symbolsOut(Sx1) = S symbols after the ST-Rake beamformer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [symbolsOut] = fSTARBeamformer(symbolsIn,arrays,goldSeq,delays,DOAs,betas)
    goldSeq = 1 - 2 * goldSeq; % 0/1 -> -1/1
    N_c = size(goldSeq,1);
    N_ext = 2 * N_c;
    c = [goldSeq;zeros(N_c,1)];
    % Shifting matrix
    J = [zeros(1,N_ext-1),0;eye(N_ext-1),zeros(N_ext-1,1)]; 
    H = [];
    
    for i = 1:length(delays)
        amv = spv(arrays,DOAs(i,:));
        h_i = kron(amv,J^delays(i)*c);
        H = [H h_i];
    end
    
    w = H * betas;
    symbolsOut = w' * symbolsIn;
end