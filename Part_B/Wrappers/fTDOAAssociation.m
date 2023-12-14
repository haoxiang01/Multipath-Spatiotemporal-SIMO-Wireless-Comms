% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 08-Dec-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform TDOA Association Stage (ref: ACT-6 slides P27)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% TOA_est = The estimated TOA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% rhoi1 =  difference in distances between Rx_i and Rx_1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  rhoi1 = fTDOAAssociation(TOA_est)
   % propagation speed(light speed)
    c = 3e8;
    rhoi1 = zeros(3,1);
    %calculate distance difference
    rhoi1(1) = (TOA_est(2) - TOA_est(1)) * c;
    rhoi1(2) = (TOA_est(3) - TOA_est(1)) * c;
    rhoi1(3) = (TOA_est(4) - TOA_est(1)) * c;
end

