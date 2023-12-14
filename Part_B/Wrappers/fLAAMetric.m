% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 09-Dec-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% + Perform LAA Metric Stage 
% + ref1: ACT-6 slides P60
% + ref2: https://ieeexplore.ieee.org/abstract/document/6255799
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% K =  The vector used in the metric-fusion stage(defined in ACT-6 slides P58 eqution 66 )
% Rx = Location of receiver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% r_m = Location of Tx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function r_m= fLAAMetric(K,Rx)
    N = size(Rx,1);
    H = [2*(ones(N-1,1) * Rx(1,:) - Rx(2:end,:)) , ones(N-1,1) - (K.').^2];
    b = norm(Rx(1,:)).^2 * ones(N-1,1) - Rx(2:end,1).^2 - Rx(2:end,2).^2;
    r_m = H\b;
    r_m= r_m(1:2);

    %% Plot loci
    % Ref: https://ieeexplore.ieee.org/abstract/document/6255799
    % rci reference point
    r_c = [];
    % Rci radii of these loci
    R_c = [];
    r_c(1,:) = 1/(1-K(1)^2) * Rx(2,:) - K(1)^2/(1-K(1)^2) * Rx(1,:);
    
    R_c(1) = abs(K(1)/(1-K(1)^2)) * norm(Rx(2,:) - Rx(1,:));
    
    r_c(2,:) = 1/(1-K(2)^2) * Rx(3,:) - K(2)^2/(1-K(2)^2) * Rx(1,:);
    R_c(2) = abs(K(2)/(1-K(2)^2)) * norm(Rx(3,:) - Rx(1,:));
    
    r_c(3,:) = 1/(1-K(3)^2) * Rx(4,:) - K(3)^2/(1-K(3)^2) * Rx(1,:);
    R_c(3) = abs(K(3)/(1-K(3)^2)) * norm(Rx(4,:) - Rx(1,:));
    
    figure();
    grid on;
    hold on;
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
    for i = 1:3
        x = R_c(i)*cos(angles) + r_c(i,1);
        y = R_c(i)*sin(angles) + r_c(i,2);
        plot(x,y,'-');
    end
    plot(r_c(1,1),r_c(1,2),'og',...
         'MarkerSize',5,...
         'LineWidth',2,...
         'MarkerFaceColor','g');
    text(r_c(1,1),r_c(1,2),'r_c_1');
    plot(r_c(2,1),r_c(2,2),'og',...
         'MarkerSize',5,...
         'LineWidth',2,...
         'MarkerFaceColor','g');
    text(r_c(2,1),r_c(2,2),'r_c_2');
    plot(r_c(3,1),r_c(3,2),'og',...
         'MarkerSize',5,...
         'LineWidth',2,...
         'MarkerFaceColor','g');
    text(r_c(3,1),r_c(3,2),'r_c_3');
    title({'Task4-LAA Localisation';['The Tx Coordinate is: (',num2str(r_m(1)),' , ',num2str(r_m(2)) , ')']});
    legend('Receivers','Transmitter');
    axis equal;
    fprintf(['Tx location estimated by LAA is (' num2str(r_m(1)) ',' num2str(r_m(2)) ')\n']);
end