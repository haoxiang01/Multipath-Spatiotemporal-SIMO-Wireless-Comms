% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 09-Dec-2023


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
    
    title('DOA Localisation');
    legend('Receivers','Transmitter');
    xlabel('x');ylabel('y');
    axis equal
    hold off
end