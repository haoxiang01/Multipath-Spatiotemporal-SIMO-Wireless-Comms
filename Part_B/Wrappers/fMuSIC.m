% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 08-Dec-2023

function [cost,DOA] = fMuSIC(arrays, Rxx, M)

    [E, D] = eig(Rxx); %eigenvalues and eigenvectors
    D = diag(D);
    [~,I] = sort(D,'descend');
    
    E = E(:,I);
    En = E(:,M+1:end);
    cost = zeros(361,1);
   
    for azimuth = 0:360
        amv = spv(arrays,[azimuth,0]);
        cost(azimuth + 1,:) = amv'*(En*En')*amv;
    end
    
    cost = -10*log10(cost);
    [~,DOA] = max(cost);
    DOA = DOA - 1;
end