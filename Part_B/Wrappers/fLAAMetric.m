% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 09-Dec-2023

function r_m= fLAAMetric(K,Rx)
    N = size(Rx,1);
    H = [2*(ones(N-1,1) * Rx(1,:) - Rx(2:end,:)) , ones(N-1,1) - (K.').^2];
    b = norm(Rx(1,:)).^2 * ones(N-1,1) - Rx(2:end,1).^2 - Rx(2:end,2).^2;
    r_m = H\b;
    r_m= r_m(1:2);

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
    
    title('LAA Localisation');
    legend('Receivers','Transmitter');
    xlabel('x');ylabel('y');
    axis([-200 200 -200 200]);
    hold off
end