% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 09-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform LAA Association Stage (ref: ACT-6 slides P59)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% x_LAA = The data set of 256 sample signal at Rx.
% alpha = Path loss exponent.
% N = Number of Rx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% K = The vector used in the metric-fusion stage(defined in ACT-6 slides P58 eqution 66 )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function K = fLAAAssociation(x_LAA,alpha,N)
    lambda = [];
    L = size(x_LAA,2);
    for i = 1:N
        x = x_LAA(4*(i-1)+1:4*i,:);
        Rxx = x * x' / L;
        D = sort(eig(Rxx),'descend');
        %Max eigvalue
        gamma = D(1); 
        sigma = mean(D(2:end));
        lambda(i) = gamma - sigma;
    end
    K = (lambda(2:end)./lambda(1)) .^ (1/(2*alpha));
end