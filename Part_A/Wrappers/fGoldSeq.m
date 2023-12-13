% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 05-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takes two M-Sequences of the same length and produces a gold sequence by
% adding a delay and performing modulo 2 addition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% mseq1 (Wx1 Integer) = First M-Sequence
% mseq2 (Wx1 Integer) = Second M-Sequence
% shift (Integer) = Number of chips to shift second M-Sequence to the right
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% GoldSeq (Wx1 Integer) = W bits of 1's and 0's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [GoldSeq]=fGoldSeq(mseq1,mseq2,shift)

    % Ensure the input two m sequences have the same length
    if length(mseq1) ~= length(mseq2)
        error('M-sequences must be of the same length');
    end

    % Shift the second M-sequence
    shifted_mseq2 = circshift(mseq2, shift);

    % Perform modulo-2 addition (XOR)
    GoldSeq = mod(mseq1 + shifted_mseq2, 2);
end