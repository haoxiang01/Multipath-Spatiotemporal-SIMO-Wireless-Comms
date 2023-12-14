% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 07-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform Spatiotemporal Rake Beamformer (ACT-5 Slides P45 Equation 25)
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
    % 0/1 -> -1/1
    goldSeq = 1 - 2 * goldSeq;

    N_c = size(goldSeq,1);
    N_ext = 2 * N_c;

    % Shifting matrix
    J = [zeros(1,N_ext-1),0;eye(N_ext-1),zeros(N_ext-1,1)]; 

    % Extended Gold sequence with zeros
    c = [goldSeq;zeros(N_c,1)];
    
    % ST manifold matrix
    H = zeros(size(symbolsIn,1),length(delays));
    
    for i = 1:length(delays)
        % mainfold vector
        S = spv(arrays,DOAs(i,:));
        % extended mainfold
        h_i = kron(S ,J^delays(i)*c);
        H(:,i) = h_i;
    end
    
    %STAR-RAKE weight vector(Ref: ACT-5 Slides P45 Equation 25)
    w = H * betas;
    symbolsOut = w' * symbolsIn;

    %Plot Array Pattern of STAR-RAKE Beamformer
    figure();
    g = zeros(181,N_c);

    for i = 1:181
        for j = 1:N_c
            S = spv(arrays,[i 0]);
            h = kron(S,(J^(j-1) * c));
            g(i,j) = w'*h;
        end
    end

    mesh(0:N_c-1, 0:180, abs(g));
    title('STAR-RAKE Array Pattern');
    xlabel('TOA (T)'); 
    ylabel('DOA (Degree)');
    zlabel('gain');
    axis square;
end