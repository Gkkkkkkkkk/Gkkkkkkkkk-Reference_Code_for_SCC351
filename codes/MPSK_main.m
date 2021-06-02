clc,clear

symbols_number = 2e4;
stride = randi([1,5]);
M = 2^stride;

data_length = symbols_number * stride;% generate a bit stream whose L=M*10,000
data = randi([0,1],1,data_length);
[symbols,encode_symbols] = encode(data,stride,symbols_number);

coordis = cos(2*pi/M*symbols)+1j*sin(2*pi/M*symbols);%generate coordinates
%coordinates = cos(2*pi/M*n)+1j*sin(2*pi/M*n);

SNR_dB = -20:20;
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

plot(SNR_dB,SERs)