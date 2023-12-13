% Haoxiang Huang, CSP(MSc), 2023, Imperial College.
% 05-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fShowImg Function
% This function reads three images and displays them if they are within 
% the specified size limits.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% img1_path (String) = path to the first image file.
% img2_path (String) = path to the second image file.
% img3_path (String) = path to the third image file.
% width_limit (1x1 Integer) = maximum allowable width for the images.
% height_limit (1x1 Integer) = maximum allowable height for the images.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% bits (3x1 Integers)= Array contains the total number of bits for each image.
% widths (3x1 Integers) = Array contains the width of each image.
% heights (3x1 Integers)  = Array contains the height of each image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [bits,widths,heights] = fShowImg(img1_path,img2_path,img3_path,width_limit,height_limit)
    
    % Read the images
    Image1 = imread(img1_path);
    Image2 = imread(img2_path);
    Image3 = imread(img3_path);
    
    % Check Image1 size.
    [x1,y1,~] = size(Image1);
    if(x1*y1 > width_limit*height_limit)
        error('Input Image1 exceed the image size limitation!');
    end
    
    % Check Image2 size.
    [x2,y2,~] = size(Image2);
    if(x2*y2 > width_limit*height_limit)
        error('Input Image2 exceed the image size limitation!');
    end

    % Check Image3 size.
    [x3,y3,~] = size(Image3);
    if(x3*y3 > width_limit*height_limit)
        error('Input Image3 exceed the image size limitation!');
    end

    % Calculate the total number of bits Q for each image
    Q1 = x1*y1*3*8;
    Q2 = x2*y2*3*8;
    Q3 = x3*y3*3*8;
    bits =[Q1;Q2;Q3];

    % Collect each image width and height size 
    widths = [x1;x2;x3];
    heights = [y1;y2;y3];
    
    % Display each images
    figure;
    subplot(1,3,1);
    imshow(Image1);
    title('Original Image of  User1');
    subplot(1,3,2);
    imshow(Image2);
    title('Original Image of User2')
    subplot(1,3,3);
    imshow(Image3);
    title('Original Image of User3')
end