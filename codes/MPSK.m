function [SERs] = MPSK(sig,M,SNR)

    %sig:modulating signal
    %n: no. of input bits
    %SNR: range in dB
    %M: modulating levels
    
    stride = log2(M);
    symbols_number = floor(length(sig)/stride);
    
    [symbols,encode_groups] = encode(sig,stride,symbols_number);

    coordis = cos(2*pi/M*symbols)+1j*sin(2*pi/M*symbols);%generate coordinates
    %coordinates = cos(2*pi/M*n)+1j*sin(2*pi/M*n);

    SNR_dB = SNR;
    SNR = 10 .^(SNR_dB/10);
    sigma = sqrt(1./(stride*2*SNR));
    SERs = zeros(1,length(SNR));

    for i=1:length(SNR)
        var = sigma(i);
        AWGN=randn(1,symbols_number)*var+1j*randn(1,symbols_number)*var;
        received_data = coordis + AWGN;
        decoded_symbols = decode(received_data,M);
        SERs(i)=length(find(symbols~=decoded_symbols))/length(symbols);
    end
    
end

