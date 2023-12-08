% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 08-Dec-2023

function [rho,t]= fTOAAssociation(x_time,Ts,t0)
    c = 3e8;    % Propagation speed
    amp=abs(x_time);
    amp_avg = mean(abs(x_time));
    amp(amp<amp_avg) = 0;  
    index = find(amp>0);
    t = index(1) * Ts;
    rho = (t - t0)* c;
end