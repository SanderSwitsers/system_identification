%Bode of system
%System Identification and Modeling
%Exercise - Part 2
%
%HENRI DE PLAEN
%r0681349
%KULeuven
%
%Date: 1-5-2018

%% init
clear ll ; close all ; clc ; figure ;
noise_offset ;
T = 1 ;
L = 50 ;
fs = 1/L ;
n = 50;
n_expe = 100 ;

%prealloc
gains = zeros(n,1) ;
phases = zeros(n,1) ;
outputs = zeros(L-14,n_expe) ;

t = linspace(0,1,L) ;
f = linspace(1/n,30,n) ;

%% calculate
h = waitbar(0,'Processing...') ;
for idx1 = 1:n
    for idx2 = 1:n_expe
        %% input
        input = 3*sin(t*f(idx1)*2*pi) ;
        output = exercise2(input) ;
        
        %% output
        output = preprocess(output) ;
        outputs(:,idx2) = output ;
        waitbar( ((idx1-1)*n_expe + idx2)/n/n_expe ,h) ;
    end
    output = mean(outputs,2) ;
    %% FFT
    f_output = fft(output,L) ;
    f_output = f_output/L ;
    f_output = f_output(1:L/2+1) ;
    f_output(2:end-1) = 2*f_output(2:end-1);
    
    %% values
    magnitudes_temp = abs(f_output) ;
    phases_temp = angle(f_output) ;
    gain = max(magnitudes_temp) ;
    pos_max = find(magnitudes_temp==gain) ;
    gains(idx1) = gain/3 ;
    phases(idx1) = phases_temp(pos_max(1)) ;
end
close(h) ;

%% plots
figure ;
plot(f,20*log(gains)/log(10),':k') ; % .*sign(sin(phases))
title('Bode plot') ;
xlabel('Relative frequency') ; ylabel('Gain [dB]') ;