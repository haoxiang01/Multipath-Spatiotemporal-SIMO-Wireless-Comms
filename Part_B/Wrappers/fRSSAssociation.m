% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 08-Dec-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform RSS (RSSI) Association Stage (ref: ACT-6 slides P39)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% x = The data set of 256 sample signal at Rx.
% PTx = Power of Tx.
% lambda = wavelength.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% rho =  The estimated distance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rho = fRSSAssociation(x,PTx,lambda)
    % Power of Rx
    PRx = x * x' / size(x,2);
    rho = sqrt(PTx/PRx)*lambda/4/pi;
end