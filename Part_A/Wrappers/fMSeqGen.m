% Haoxiang Huang, CSP(EE4/MSc), 2023, Imperial College.
% 05-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takes polynomial weights and produces an M-Sequence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% coeffs (Px1 Integers) = Polynomial coefficients. For example, if the
% polynomial is D^5+D^3+D^1+1 then the coeffs vector will be [1;0;1;0;1;1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% MSeq (Wx1 Integers) = W bits of 1's and 0's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [MSeq]=fMSeqGen(coeffs)
    % the length of shift register
    m = length(coeffs) - 1; 

    % Initialize 
    reg = ones(m, 1); 
    N_c = 2.^m - 1; % maximum period of the shift register
    MSeq = zeros(N_c, 1); 

    % Generate the M-sequence
    for i = 1:N_c
        % XOR
        feedback = mod(sum(reg .* coeffs(2:end)), 2);
        
      
        % Shift the register
        reg = [feedback; reg(1:end-1)];

        % Store the last bit of the register into MSeq
        MSeq(i) = reg(end);
        
    end
end
