% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 09-Dec-2023

function K = fLAAAssociation(x_LAA,alpha,N)
    lamda = [];
    L = size(x_LAA,2);
    for i = 1:N
        x = x_LAA(4*(i-1)+1:4*i,:);
        Rxx = x * x' / L;
        D = sort(eig(Rxx),'descend');
        gamma = D(1); %Max eigvalue
        sigma = mean(D(2:end));
        lamda(i) = gamma - sigma;
    end
    K = (lamda(2:end)./lamda(1)) .^ (1/(2*alpha));
end