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
    % extended Dims
    N_ext = 2 * N_c;
    % number of antennas
    N = size(symbolsIn, 1);
    % length of symbols
    M = size(symbolsIn, 2); 
    % calculate the number of blocks (L)
    numBlocks = floor(M / N_c);
    % pre-allocate the output of extended mainfold vector
    x_n = zeros(N*N_ext,numBlocks);
    
    for j = 1:numBlocks
        % start index for the current block
        start_ = 1 + (j-1)*N_c;
        % end index for the current block
        end_ = (j+1)*N_c;
        % if the end index is within the symbol length
        if end_ < M
            % Vectorisation
            temp = reshape(symbolsIn(:, start_:end_).', [N * N_ext, 1]);
        % if the end index exceeds the symbol length
        else
            % pad with zeros
            tempBlock = zeros(N, end_ - start_ + 1);
            tempBlock(:, 1:M - start_ + 1) = symbolsIn(:, start_:end);
            % Vectorisation
            temp = reshape(tempBlock.', [N * N_ext, 1]);
        end
        % Append vectorized current block to the output matrix
        x_n(:,j) = temp;
    end
end