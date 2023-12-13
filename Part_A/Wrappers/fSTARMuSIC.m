% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 07-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function performs STAR-MuSIC Estimation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
% Rxx = The covariance matrix of the the signal.
% goldseq = gold sequence
% N_c = The period of P-N code
% arrays = The cartesian location of array with half-wavelength
% inter antenna spacing
% J = Shift matrix.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% Cost = Value of Cost function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Cost] = fSTARMuSIC(Rxx,goldseq,M,N_c,arrays,J)
    % eigenvectors and eigenvalues
    [E, D] = eig(Rxx);
    D = diag(D);

    [~,I] = sort(D,'descend');
    E = E(:,I);
    % noise subspace eigenVectors
    En = E(:,M+1:end);

    % projection onto the noise subspace
    Pn = fpo(En);

    % goldseq extended with zeros padding
    % Ref: https://ieeexplore.ieee.org/abstract/document/1145705
    c = [goldseq;zeros(N_c,1)];

    % Cost function
    % Ref1: https://ieeexplore.ieee.org/abstract/document/1145705
    % Ref2: ACT-5 Slides P37
    Cost = zeros(181,N_c); 
    % Azimuth angle
    for az = 0:180
        % delay
        for l = 0:N_c-1
            % mainfold vector
            S= spv(arrays,[az 0]);
            % extended mainfold
            h = kron(S,J^l*c);
            % cost function
            Cost(az+1,l+1) = h'*Pn*h;
        end
    end
    Cost= -10*log10(Cost);

    % Plot the STAR-MuSIC Spectrum
    figure();
    mesh(0:N_c-1,0:180,real(Cost));    
    title('STAR MuSIC Spectrum');
    xlabel('TOA (Tc)');
    ylabel('DOA (Degree)');
    zlabel('dB');
    grid on;

    % Plot the STAR-MuSIC Contour Diagram
    figure();
    contour(0:N_c-1,0:180,real(Cost));
    xlabel('TOA (T)'); 
    ylabel('DOA (Degree)');
    grid on;
    axis square;
    title('STAR MuSIC Contour Diagram'); 
    axis square;
    grid on;
end