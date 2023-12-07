% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 06-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (L*N Complex) = Received Symbol 
% N_c (Interger) = P-N code period
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% x_n ((N*2*Nc)x(L/Nc) Complex) = Extended signals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x_n] = fMainfoldExtender(symbolsIn,N_c)
    symbolsIn = symbolsIn.';
    x_n = [];
    N_ext = 2 * N_c;
    N = size(symbolsIn, 1);
    L = size(symbolsIn, 2);
    numBlocks = ceil(L / Nc);  % Calculate the number of blocks

    for j = 1:numBlocks
        start_ = 1 + (j - 1) * Nc;
        end_= min(j * N_ext, L);  % Ensure b does not exceed the column size of symbolsIn

        % Extract and reshape the current block
        if end_ <= L
            temp = reshape(symbolsIn(:, start_:end_).', [N * N_ext, 1]);
        else
            tempBlock = zeros(N, end_ - start_ + 1);
            tempBlock(:, 1:L - start_ + 1) = symbolsIn(:, start_:end);
            temp = reshape(tempBlock.', [N * N_ext, 1]);
        end

        % Append 
        x_n  = [symbolsExtended temp];
    end
end

