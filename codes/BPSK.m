function [BERs] = BPSK(sig,n,SNR)
    
    %sig: modulating signal
    %n: no. of bits
    %SNR: range in dB
    
    encode_sig = sig * 2 - 1;%BPSK:{-1,1}
    BERs = zeros(1,length(SNR));
    ind = 1;
    thresh = 0.5*(max(encode_sig)+min(encode_sig));
    for SNR_dB = SNR
        SNR_bit = 10^(SNR_dB/10);
        N0 = 1/SNR_bit;
        sigma = sqrt(N0/2);

        AWGN = sigma * rand(1,n);

        re_sig = sign(encode_sig + AWGN - thresh);
        %sign func. returns {-1,1}
        decode_sig = 0.5*(re_sig + 1);

        det = find((sig == decode_sig)==0);
        ber = length(det)/n;
        BERs(ind) = ber;
        ind = ind +1 ;
    end
end

