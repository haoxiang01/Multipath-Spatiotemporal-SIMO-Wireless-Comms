% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 05-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reads an image file with AxB pixels and produces a column vector of bits
% of length Q=AxBx3x8 where 3 represents the R, G and B matrices used to
% represent the image and 8 represents an 8 bit integer. If P>Q then
% the vector is padded at the bottom with zeros.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% filename (String) = The file name of the image
% P (Integer) = Number of bits to produce at the output - Should be greater
% than or equal to Q=AxBx3x8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% bitsOut (Px1 Integers) = P bits (1's and 0's) representing the image
% x (Integer) = Number of pixels in image in x dimension
% y (Integer) = Number of pixels in image in y dimension
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [bitsOut,x,y]=fImageSource(filename,P)
    % Read the image
    img = imread(filename);
    
    %Calculate image width and height
    [x, y, ~] = size(img);

    % Calculate the number of bits Q
    Q = x * y * 3 * 8;

    % Reshape and convert the image to a binary vector
    imgReshaped = reshape(img, [], 1);
    imgBinary = de2bi(imgReshaped, 8, 'left-msb');
    imgBits = reshape(imgBinary', [], 1);

    
    if P >= Q
        % Pad with zeros if necessary
        imgBits = [imgBits; zeros(P-Q, 1)];
    else
        error('P must be greater than or equal to Q = AxBx3x8');
    end

    % Output the bitstream
    bitsOut = imgBits;
end

