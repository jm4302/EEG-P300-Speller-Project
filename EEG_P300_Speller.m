%%John Mavroudes 

close all 
clear all 
load('sessiontraining1_P300.mat')

fs = 256; %sampling frequency 
index_length_100ms = fs*100*10^-3; %100ms index length
index_length_700ms = fs*700*10^-3; %700ms index length 
before_100ms = round(index_length_100ms); %gets an integer value for the index of 100ms 
after_700ms = round(index_length_700ms);  %gets an integer value for the index of 700ms 

ch10 = y(10,:);  %Reads ch 10
ch11 = y(11,:);  %Reads ch 11

%Locate indexs right before a flash 
index_ch10 = find(diff(ch10)>0); 
index_ch11 = find(diff(ch11)>0);

%separate target from non-target values 
index_target = setdiff(index_ch10,index_ch11);

%Generates Non_target signal for channels 1-9 
for i = 1:9
    ch = y(i,:);
       for j = 1:length(index_target)
        k(j,:) = index_target(j)+1-before_100ms:index_target(j)+4+after_700ms;
        non_target(j,:) = ch(k(j,:)); 
       end 
    f_tar{i} = mean(non_target);
end 

%Generates Target signal for channels 1-9  
for i = 1:9
    ch = y(i,:);
        for j = 1:length(index_ch11)
        w(j,:) = index_ch11(j)+1-before_100ms:index_ch11(j)+4+after_700ms;
        target(j,:) = ch(w(j,:));  
        end 
    f_ntar{i} = mean(target);
end 


 t = -100:3.91:716;
 %Plots the figures 
for i = 1:9
    figure
   %Target Values
    subplot(1,2,1)
    plot(t,f_tar{i},'b')
    xlim([-100 716])
    title(sprintf('Non Target Response of CH%d',i))
    xlabel('Time (ms)')
    ylabel('Voltage (uV)')
    
    %Non Target Values 
    subplot(1,2,2)
    plot(t,f_ntar{i},'m')
    xlim([-100 716])
    title(sprintf('Target Response of CH%d',i))
    xlabel('Time (ms)')
    ylabel('Voltage (uV)')
end 
    
    

 
    
