% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 06-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function extends the input symbols 'symbolsIn' by 2N_c (N_ext) symbols
% using the mainfold extension method in ACT-5 slides P33.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (MxN Complex) = The input symbols to be extended
% N_c (Interger) = P-N code period
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% x_n ((NxN_ext)xL Complex) = The extended symbols
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x_n] = fMainfoldExtender(symbolsIn,N_c)
    symbolsIn = symbolsIn.';
    x_n = [];
    N_ext = 2 * N_c;
    N = size(symbolsIn, 1);
    M = size(symbolsIn, 2); % length of symbols
    numBlocks = floor(M / N_c);  % Calculate the number of blocks (L)
    numBlocks = max(1,numBlocks);
    
    for j = 1:numBlocks
        start_ = 1 + (j - 1) * N_c;
        end_= (j-1) *N_c + N_ext;  % Ensure b does not exceed the column size of symbolsIn

        % Extract and reshape the current block
        if end_ <= M
            temp = reshape(symbolsIn(:, start_:end_).', [N * N_ext, 1]);
        else
            tempBlock = zeros(N, end_ - start_ + 1);
            tempBlock(:, 1:M - start_ + 1) = symbolsIn(:, start_:end);
            temp = reshape(tempBlock.', [N * N_ext, 1]);
        end

        % Append 
        x_n  = [x_n temp];
    end
end
