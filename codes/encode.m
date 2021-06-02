function [symbols,encoded_data] = encode(data,bits_per_symbol,symbols_number)
    %encode bit stream into symbols for MPSK
    encoded_data = zeros(bits_per_symbol,symbols_number);
    for i=1:symbols_number
        for j=1:bits_per_symbol
            encoded_data(j,i)=data((i-1)*bits_per_symbol+j);
        end
    end
    
    symbols = zeros(1,symbols_number);
    for i=1:symbols_number
        tmp = 0;
        for j=1:bits_per_symbol
            tmp = tmp+encoded_data(j,i)*2^(bits_per_symbol-j);%symbol=sum[data_i*2^(M-i)],i=1:stride
        end
        symbols(i)=tmp;
    end
end

