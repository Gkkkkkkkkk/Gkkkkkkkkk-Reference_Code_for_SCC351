function decoded_symbols = decode(receive,M)
    %decode coordinates to relative symbols
    %receive: coordis to be decoded
    %M:No. of original coordis, i.e. M-PSK
    symbols=[0:M-1];
    coordis = cos(2*pi/M*symbols)+1j*sin(2*pi/M*symbols);%generate coordis
    D = zeros(length(receive),M);
    
    for i=1:length(receive)
        for j=1:M
            D(i,j)=norm(receive(i)-coordis(j));
        end
    end
    [~,decoded_symbols] = min(D,[],2);
    decoded_symbols = decoded_symbols'-1;
    
end

