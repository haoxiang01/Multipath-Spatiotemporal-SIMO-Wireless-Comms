% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 09-Dec-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% + Perform DOA Metric Stage 
% + ref1: ACT-6 slides P42
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% Rx = Location of receiver
% rho = estimated distance
% DOAs = estimated DOAs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% r_m = Location of Tx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function r_m= fDOAMetric(Rx,rho,DOAs)
    
    N = size(Rx,1);
    b = zeros(2,N);
    for i=1:N
        b(1,i) = Rx(i,1) + rho(i)*cos(DOAs(i)*pi/180);
        b(2,i) = Rx(i,2) + rho(i)*sin(DOAs(i)*pi/180); 
    end
    b = b(:);
    H = kron(ones(N,1),eye(2));
    r_m= inv(H'*H)*H'*b;

    %%  Plot
    DOAs=DOAs/180*pi;
    figure;
    plot(Rx(:,1),Rx(:,2),'sb',...
         'MarkerSize',7,...
         'LineWidth',2,...
         'MarkerFaceColor','b');
    hold on
    grid on
    plot(r_m(1),r_m(2),'xr',...
         'MarkerSize',12,...
         'LineWidth',2,...
         'MarkerFaceColor','r');
    for i = 1:N
        fc = @(x,y) (y-Rx(i,2)) - tan(DOAs(i)) * (x-Rx(i,1));
        fimplicit(fc,[-150 150 -150 150]);
    end
    
    title({'Task3-DOA Localisation';['The Tx Coordinate is: (',num2str(r_m(1)),' , ',num2str(r_m(2)) , ')']});
    legend('Receivers','Transmitter');
    xlabel('x');ylabel('y');
    axis equal
end