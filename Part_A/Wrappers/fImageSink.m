% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 06-Dec-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display the received image by converting bits back into R, B and G
% matrices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% bitsIn (Px1 Integers) = P demodulated bits of 1's and 0's
% Q (Integer) = Number of bits in the image
% x (Integer) = Number of pixels in image in x dimension
% y (Integer) = Number of pixels in image in y dimension
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% None
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fImageSink(bitsIn, Q, x, y)
    % Ensure bitsIn contains only the relevant bits
    bitsIn = bitsIn(1:Q);

    % Number of bits per color channel
    Qc = Q / 3;

    img = zeros(x, y, 3, 'uint8');

    for channel = 1:3
        % Extract bits for the current channel
        channelBits = bitsIn((channel - 1) * Qc + 1 : channel * Qc);

        % Reshape for 8 bits
        channelBits = reshape(channelBits, 8, []);

        % binary to integers
        channelImage = bi2de(channelBits', 'left-msb');

        % Reshape 
        img(:,:,channel) = reshape(channelImage, [x, y]);
    end

   
    imshow(img);
end