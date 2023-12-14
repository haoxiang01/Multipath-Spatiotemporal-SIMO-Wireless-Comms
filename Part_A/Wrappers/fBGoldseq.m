% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 05-Dec-2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generates a 'balanced' gold-sequence that satisfies the inequality:
% d >= 1 + (X + Y) mod 12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% X (Integer) = alphabetical order of the 1st letter of my surname
% Y (Integer) = alphabetical order of the 1st letter of my formal firstname
% coeffs1 & coeffs2 (Px1 Integers) = Polynomial coefficients. For example, if the
% polynomial is D^5+D^3+D^1+1 then the coeffs vector will be [1;0;1;0;1;1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% Balanced_GoldSeq (Wx3 Integer) = Array of W bits of 1's and 0's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Balanced_GoldSeq = fBGoldseq(X,Y, coeffs1, coeffs2)

    %generate m sequence
    mSeq1= fMSeqGen(coeffs1);
    mSeq2= fMSeqGen(coeffs2);
    
    % degree m
    m = length(coeffs1) - 1; 
    
    % maximum period of the shift register
    N_c = 2.^m - 1; 
    
    %generate all possible the Gold Sequences
    GoldSeq_buffer = zeros(N_c,N_c);
    
    for index = 1:N_c
        GoldSeq_buffer(:,index) = fGoldSeq(mSeq1,mSeq2,index);
    end
    
    GoldSeq_buffer = [GoldSeq_buffer mSeq1 mSeq2];
    GoldSeq_buffer_trans = 1-2.*GoldSeq_buffer;
    
    % calculate shift delay lowerbound required by the official doc
    delay_lowerbound = 1 + mod(X + Y,12);
    delay=0;
    
    % find Balanced Gold Sequence delay index with satisfied conditions
    for index = 1:N_c+2
        if sum(GoldSeq_buffer_trans(:,index)) == -1 && index>= delay_lowerbound
            delay = index;
            break;
        end
    end

    Balanced_GoldSeq = zeros(size(GoldSeq_buffer_trans, 1), 3);
    % find the Balanced Gold Sequence for 3 users
    Balanced_GoldSeq(:, 1)= GoldSeq_buffer(:,delay);
    Balanced_GoldSeq(:, 2)= GoldSeq_buffer(:,delay+1);
    Balanced_GoldSeq(:, 3)= GoldSeq_buffer(:,delay+2);
end