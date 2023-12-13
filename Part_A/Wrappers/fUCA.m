% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 06-Dec-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Model and Display the Uniform Circular Array (UCA) of N isotropic 
% elements (antennas) with half-wavelength inter-antenna spacing (1st 
% element:angle0 anticlockwise respect to the x-axis)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% N (1x1 Integer)= Number of antennas
% angle0 (1x1 Integer) = 1st antenna degree with respect to x-axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% cartesianArray(Nx3) = The cartesian location of array with half-wavelength
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cartesianArray = fUCA(N,angle0)
    %% Modeling the UCA
    %the differece of each angle
    delta_angle = 2*pi/N;

    % radius of the UCA
    r = 1/(2*sin(delta_angle/2));
    % calculate angles for each antennas
    angles = angle0 + (0:N-1)*delta_angle;

    % define the position of an antenna in polar coordinates
    polarArray = r * exp(1i * angles);
    % convert polar coordinates to cartesian coordinates
    cartesianArray = [real(polarArray); imag(polarArray); zeros(1, length(polarArray))]';
    
    %% Display the UCA
    figure(2);
    plot(cartesianArray(:, 1), cartesianArray(:, 2), 'xr', ...
        'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'r');
    hold on;
    plot(0, 0, '+k', 'MarkerSize', 10, 'LineWidth', 2);
    for i = 1:size(cartesianArray, 1)
        plot([0, cartesianArray(i, 1)], [0, cartesianArray(i, 2)], '--k'); 
    end
    angleText = sprintf('%.2f°', rad2deg(2*pi/N));
    text(0, 0, angleText, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    
    legend('Antenna', 'FontSize', 12); 
    xlabel('X', 'FontSize', 14); 
    ylabel('Y', 'FontSize', 14);
    axis([-1 1 -1 1]);
    title('The Distribution of UCA', 'FontSize', 16);
    set(gca, 'FontSize', 12); 
    set(gcf, 'Color', 'w'); 
    grid on;
end

