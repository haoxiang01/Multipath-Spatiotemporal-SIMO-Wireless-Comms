% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 07-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the minimum description length (MDL) to 
% estimate the number of sources
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
% Rxx = The covariance matrix of the the signal.
% N = The number of arrays.
% L = The length of the symbols.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% M = The number of sources
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M = fMDL(Rxx,N,L)

    eigenv = sort(real(eig(Rxx)), 'descend');
    MDL = zeros(1,N);
    
    for k = 0:N-1
        % geometric mean of the smallest N-k eigenvalues
        num = vpa(prod(eigenv(k + 1:N) .^(1 / (N - k))), 6);
        % arithmetic mean of the smallest N-k eigenvalues
        den = (1/(N-k)) * sum(eigenv(k+1:N));
        % compute the MDL criterion(ACT-4 slides p34)
        MDL(k+1) = -1 * log((num / den).^((N - k) * L)) + 1 / 2 * k * (2 * N - k) * log(L);
    end

    %find the min
    [~,M] = min(MDL);
    M = M - 1;

end