% Haoxiang Huang, CSP (MSc), 2023, Imperial College.
% 07-Dec-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function converts a stream of bits into a string
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% bitstream = A vector of bits (0s and 1s) representing the binary data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% str = A string converted from the input bitstream.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function str = fbit2str(bitstream)
    nBits = length(bitstream);
    if mod(nBits, 8) ~= 0
        nBitsToKeep = nBits - mod(nBits, 8); 
        bitstream = bitstream(1:nBitsToKeep); 
    end
    binValues = reshape(bitstream, 8, [])'; 
    decValues = bi2de(binValues, 'left-msb'); 
    str = char(decValues)';
end
