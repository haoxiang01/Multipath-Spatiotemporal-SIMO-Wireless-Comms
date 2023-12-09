% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 08-Dec-2023
function rho = fRSSAssociation(x,PTx,lamda)
    PRx = x * x' / size(x,2);
    rho = sqrt(PTx/PRx)*lamda/4/pi;
end