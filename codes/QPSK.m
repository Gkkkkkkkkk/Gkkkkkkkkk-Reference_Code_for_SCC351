function [SERs,BERs] = QPSK(sig,n)
    
    split_data = zeros(2,n/2);% 2 lines, n/2 colomn
    symbols = zeros(1,n/2);
    for i=1:2:n
        split_data(1,(i+1)/2)=sig(i);%odd bits
    end
    for i=2:2:n
        split_data(2,i/2)=sig(i);%even bits
    end
    for i=1:n/2
        symbols(i)= split_data(1,i)*2 + split_data(2,i);
    end
    
    encode_data = zeros(1,n/2);% encode_data = cos(pi*n/2 + pi/4) + sin(pi*n/2 + pi/4)j
    for i=1:n/2
        symbol = symbols(i);
        encode_data(i)= cos(pi*symbol/2 + pi/4) + sin(pi*symbol/2 + pi/4)*1j;
    end
    
    SERs = zeros(1,41);
    BERs = zeros(1,41);
    ind = 1;
    
    for SNR_dB = -20:1:20
        SNR_bit = 10^(SNR_dB/10);
        N0 = 1/(2*SNR_bit);
        sigma = sqrt(N0/2);

        AWGN = sigma * rand(1,n/2) + sigma * rand(1,n/2)*1i ;
        
        re_sig = AWGN + encode_data;
        
        decoded_symbols = zeros(1,n/2);%decode the received sig
        decoded_bits = zeros(2,n/2);
        for i=1:n/2
            R = real(re_sig(i));
            I = imag(re_sig(i));
            if R>0 && I>0
                decoded_symbols(i) = 0;
                decoded_bits(1,i)=0;
                decoded_bits(2,i)=0;
            elseif R<0 && I>0
                decoded_symbols(i) = 1;
                decoded_bits(1,i)=0;
                decoded_bits(2,i)=1;
            elseif R<0 && I<0
                decoded_symbols(i) = 2;
                decoded_bits(1,i)=1;
                decoded_bits(2,i)=0;
            else
                decoded_symbols(i) = 3;
                decoded_bits(1,i)=1;
                decoded_bits(2,i)=1;
            end
        end
        
        BER = size(find(split_data ~= decoded_bits),1)/n;
        SER = size(find(symbols ~= decoded_symbols),2)/(n/2);
        BERs(ind) = BER;
        SERs(ind) = SER;
        ind = ind + 1 ; 
    end
end

