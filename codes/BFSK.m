function [BERs] = BFSK(sig,n,SNR)
    
    encode_sig = sqrt(sig * 2 - 1);%BFSK:{1,j}
    BERs = zeros(1,41);
    ind = 1;
    for SNR_dB = SNR
        SNR_bit = 10^(SNR_dB/10);
        N0 = 1/SNR_bit;
        sigma = sqrt(N0/2);

        AWGN = sigma * rand(1,n) + sigma * rand(1,n)*1i ;

        re_sig = encode_sig + AWGN;
        %sign func. returns {-1,1}
        decode_sig = -1*sign(angle(re_sig) - angle(1+1i));
        %>0 for 0 and <0 for 1
        decode_sig = (decode_sig + 1)/2;

        det = find((sig == decode_sig)==0);
        ber = length(det)/n;
        BERs(ind) = ber;
        ind = ind +1 ;
    end
end

