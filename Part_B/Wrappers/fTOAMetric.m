% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 08-Dec-2023

function r_m= fTOAMetric(Rx,rho)
    H = Rx(2:end,:); % r1 is origin
    b = 1/2 *[
           norm(H(1,:))^2-rho(2).^2+rho(1).^2;
           norm(H(2,:))^2-rho(3).^2+rho(1).^2;
           norm(H(3,:))^2-rho(4).^2+rho(1).^2];
    r_m= H\b;

    %plot
    figure();
    plot(Rx(:,1),Rx(:,2),'ob',...
         'MarkerSize',10,...
         'LineWidth',2,...
         'MarkerFaceColor','b');
    hold on
    grid on
    plot(r_m(1),r_m(2),'or',...
         'MarkerSize',10,...
         'LineWidth',2,...
         'MarkerFaceColor','r');
    angles = 0:pi/40:2*pi;
    for i = 1:size(rho,1)
        x = rho(i)*cos(angles) + Rx(i,1);
        y = rho(i)*sin(angles) + Rx(i,2);
        plot(x,y,'-');
    end
    
    title('TOA Localisation');
    legend('Receivers','Transmitter');
    xlabel('x');ylabel('y');
    axis equal
    hold off
end