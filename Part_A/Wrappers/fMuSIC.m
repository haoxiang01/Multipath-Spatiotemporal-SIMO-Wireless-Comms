% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 07-Dec-2023
function [Cost] = fMuSIC(Rxx,c,M,N_c,arrays,J)
    [eigenVector,eigenValue] = eig(Rxx);
    eigenValue = diag(eigenValue);
    [~,I] = sort(eigenValue,'descend');
    eigenVector = eigenVector(:,I);
    En = eigenVector(:,M+1:end);
    Pn = fpo(En);
    %Cost function
    Cost = zeros(181,N_c);         
    for az = 0:180
        for l = 0:N_c-1
            sp = spv(arrays,[az 0]);
            h = kron(sp,J^l*c);
            Cost(az+1,l+1) = h'*Pn*h;
        end
    end
    Cost= -10*log10(Cost);
    figure(3);
    mesh(0:N_c-1,0:180,real(Cost));    % Plot the cost function;
    title('STAR MuSIC Spectrum');
    xlabel('Delay');
    ylabel('Azimuth Angle-degree');
    zlabel('dB');
    grid on;
end