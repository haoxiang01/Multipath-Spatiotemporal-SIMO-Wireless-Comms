% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 08-Dec-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform TOA Association Stage (ref: ACT-6 slides P23)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% x_time = The data set of 256 sample signal at Rx.
% Ts = The sampling period of the signal.
% t0 = The reference time of starting.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% rho =  The calculated distance array based on estimated TOA
% t = The estimated TOA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [rho,t]= fTOAAssociation(x_time,Ts,t0)
    % propagation speed(light speed)
    c = 3e8;   

    % amplitude of the signal
    amp=abs(x_time);

    % average amplitude
    amp_avg = mean(abs(x_time));
     
    %zero below the average
    amp(amp < amp_avg) = 0;  
    index = find(amp>0);

    % calculate TOA use first index
    t = index(1) * Ts;

    % calculate distance
    rho = (t - t0)* c;
end