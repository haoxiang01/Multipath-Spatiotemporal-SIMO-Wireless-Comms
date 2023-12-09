% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 08-Dec-2023

function [rhos,DOAs] = fDOAAssociation(x_DOAs,Rx,r_UCA)
    DOAs = zeros(4,1);
    N = size(r_UCA,1); % num of attennas
    N_Rx = size(Rx,1);% num of receivers

    for i = 1:N_Rx
        st = 1 + (i-1)*6;
        en = i*6;

        x = x_DOAs(st:en,:);
        L = size(x,2); % len of signal
        Rxx = x*x'/L;
        M = fMDL(Rxx,N,L);% Detection
        [~ , DOA] = fMuSIC(r_UCA, Rxx, M);% MuSIC Estimation
        DOAs(i) = DOA;
    end
    rho12 = Rx(2,:) - Rx(1,:);
    rho34 = Rx(3,:) - Rx(4,:);

    theta12 = atan(rho12(2) / rho12(1)) * 180/pi + 180;
    theta34 = atan(rho34(2) / rho34(1)) * 180/pi + 180;

    theta = zeros(4,1);
    theta(1) = 180-theta12+DOAs(1);
    theta(2) = theta12 - DOAs(2);
    theta(3) = DOAs(3) - theta34;
    theta(4) = 180+theta34-DOAs(4);
    theta = theta*pi/180;
   
    rhos = zeros(4,1);
    rhos(1) = norm(rho12) * sin(theta(2)) / sin(theta(1)+theta(2));
    rhos(2) = norm(rho12) * sin(theta(1)) / sin(theta(1)+theta(2));
    rhos(3) = norm(rho34) * sin(theta(4)) / sin(theta(3)+theta(4));
    rhos(4) = norm(rho34) * sin(theta(3)) / sin(theta(3)+theta(4));
end
    
    