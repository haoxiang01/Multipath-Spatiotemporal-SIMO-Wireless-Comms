% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 08-Dec-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform RSS Metric Stage (ref: ACT-6 slides P39)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% rho =  The calculated distance array based on estimated TOA
% Rx = Location of receiver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% r_m = Location of Tx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function r_m= fRSSMetric(Rx,rho)
   % r1 is origin
   H = Rx(2:end,:); 
   b = 1/2 *[
           norm(H(1,:))^2-rho(2).^2+rho(1).^2;
           norm(H(2,:))^2-rho(3).^2+rho(1).^2;
           norm(H(3,:))^2-rho(4).^2+rho(1).^2];
    r_m= H\b;

    %plot
    figure();
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
    angles = 0:pi/40:2*pi;
    for i = 1:size(rho,1)
        x = rho(i)*cos(angles) + Rx(i,1);
        y = rho(i)*sin(angles) + Rx(i,2);
        plot(x,y,'-');
    end
    title({'Task2-RSS Localisation';['The Tx Coordinate is: (',num2str(r_m(1)),' , ',num2str(r_m(2)) , ')']});
    
    legend('Receivers','Transmitter');
    xlabel('x');ylabel('y');
    axis equal
    hold off
end