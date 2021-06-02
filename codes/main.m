%----------------------------------------------------------------------%
%--------------- Coursework for SCC351 of BJTU-LU----------------------%
%--------------------Qiqi Gong, Yunsheng, Liu--------------------------%
%----------------------------------------------------------------------%

clc,clear
[lines,Levels,Modes,nums,ths,sims,appros,ranges] = ReadData('Test.csv');
%ReadData is a self-defined func
%lines: no. of datalines
for i=1:lines
%%    
    %data processing
    Level = Levels{i};%no. of levels, 2 4 8...
    Mode = Modes{i};%modulating mode:ASK FSK PSK
    n = double(nums(i));%n: no. of input bits
    th = ths{i};%plot theoretical BER or not
    sim = sims{i};%plot simulation BER or not
    appro = appros{i};%plot appro. BER or not, in Q-function
    SNR_dB = ranges{i};%SNR range in dB
    EbN0 = 10 .^(SNR_dB/10);
    
    input = randi([0,1],1,n);%generate the input stream
    
    if Level(7) == '2'%Acquire Level
        L = 'B';
    else
        L = Level(7:length(Level));%else conditions: 4,8,16,32...
        M = str2num(L);
    end
    
    modulation = [L,Mode];%modulation type
 %%  
    % Modulation
    if length(modulation)==4 & modulation == 'BPSK'
        sim_BERs = BPSK(input,n,SNR_dB);
        th_BERs = 0.5 * erfc(sqrt(EbN0));
        ap_BERs = qfunc(sqrt(2*EbN0));
        
    elseif length(modulation)==4 & modulation == 'BASK'
        sim_BERs = BASK(input,n,SNR_dB);
        th_BERs = 0.5 * erfc(0.5*sqrt(EbN0));
        ap_BERs = qfunc(sqrt(EbN0/2));
        
    elseif length(modulation)==4 & modulation == 'BFSK'
        sim_BERs = BFSK(input,n,SNR_dB);
        th_BERs = 0.5 * erfc(sqrt(EbN0/2));
        ap_BERs = qfunc(sqrt(EbN0));
    
    else%MPSK
        sim_BERs = MPSK(input,M,SNR_dB);%actually SER
        th_BERs = erfc(sqrt(2*EbN0*log2(M)*(sin(pi/M))^2/2));
        ap_BERs = 2*qfunc(sqrt(2*EbN0*log2(M)*(sin(pi/M))^2));
    end

 %%
    %plot curves and set configurations
    
    if th(1:2)=='-1' & sim(1:2)=='-1' & appro(1:2)=='-1'
        continue %no figures to be created
    end
    
    Colors = getcolor();
    
    figure %Create an image
    
    if th(1:2) ~= '-1'%Plot theoretical BERs?
        plot(SNR_dB,th_BERs,'LineWidth',1.5,...
            'Color',Colors(1,:),'DisplayName','BER_{th}');
        hold on
    end
    
    if sim(1:2) ~= '-1'%Plot simulated BERs?
        plot(SNR_dB,sim_BERs,'LineWidth',1.5,'LineStyle','--',...
            'Color',Colors(2,:),'DisplayName','BER_{sim}');
        hold on
    end
    
    if appro(1:2) ~= '-1'%Plot approximated BERs?
        plot(SNR_dB,ap_BERs,'LineWidth',1.5,'LineStyle','--',...
            'Color',Colors(3,:),'DisplayName','BER_{appro.}');
        hold on
    end
    
    if modulation(1)=='B' | modulation(1)=='2'
        title (['BER of ',modulation])
        ylabel('BER(%)')
    else
        title(['SER of ',modulation])
        ylabel('SER(%)')
    end
    xlabel('SNR(dB)')
    grid on
    legend
    hold off

end