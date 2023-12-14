% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 08-Dec-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform TDOA Metric Stage (ref: ACT-6 slides P30)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% rhoi1 = difference in distances between Rx_i and Rx_1
% Rx = Location of receiver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% r_m = Location of Tx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function r_m= fTDOAMetric(Rx,rhoi1)
    %Estimate rho1
    syms rho1_unknown
    H = Rx(2:end,:);
    b = 1/2 * [
                norm(H(1,:))^2-rhoi1(1).^2-2*rhoi1(1)*rho1_unknown;
                norm(H(2,:))^2-rhoi1(2).^2-2*rhoi1(2)*rho1_unknown;
                norm(H(3,:))^2-rhoi1(3).^2-2*rhoi1(3)*rho1_unknown];
    equation = rho1_unknown^2 == ((H.'*H)\H.'*b).'*((H.'*H)\H.'*b);
    roots = solve(equation,rho1_unknown);
    rho1_estimated = double(roots);
    rho1_estimated= rho1_estimated(rho1_estimated > 0); 
    b = 1/2 * [
                norm(H(1,:))^2-rhoi1(1).^2-2*rhoi1(1)*rho1_estimated;
                norm(H(2,:))^2-rhoi1(2).^2-2*rhoi1(2)*rho1_estimated;
                norm(H(3,:))^2-rhoi1(3).^2-2*rhoi1(3)*rho1_estimated];
    % Localisation
    r_m = H\b;

   %Plot
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
    % Plot circles for Rx1
    angles = 0:pi/40:2*pi;
    x = r_m(1);
    y = r_m(2);
    radius = sqrt(x^2 + y^2); 
    %rectangle('Position', [-radius, -radius, 2*radius, 2*radius], 'Curvature', [1, 1]);
    x = radius*cos(angles) + Rx(1,1);
    y = radius*sin(angles) + Rx(1,2);
    plot(x,y,'-');

    %   Plot hyperbola for other Rxs
    for i = 2:size(rhoi1,1)+1
            fxy = @(x,y) sqrt((x - Rx(i,1)).^2 + (y - Rx(i,2)).^2) - ...
                    sqrt(x.^2+y.^2) - rhoi1(i-1);
            fimplicit(fxy,[-150 150 -150 150]);
    end
    
    title({'Task1b-TDOA Localisation';['The Tx Coordinate is: (',num2str(r_m(1)),' , ',num2str(r_m(2)) , ')']});
    legend('Receivers','Transmitter');
    xlabel('x');ylabel('y');
    axis equal
end