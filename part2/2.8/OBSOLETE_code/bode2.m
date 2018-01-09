%Bode of system (bis)
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

n_expe = 100 ;
n_fft = 1000 ;
L = 2000 ;

f = 1:n_fft ;

tf = zeros(n_fft,n_expe) ; %prealloc

%% calc
for idx = 1:n_expe
    input = randn(L,1) ;
    output = preprocess(exercise2(input)) ;
    input = input(1:(end-14)) ;
    tf_temp = tfestimate(output,input,[],[],(n_fft-1)*2) ;
    tf(:,idx) = tf_temp ;
end
    
tf_mean = mean(tf,2) ;

%% plots
plot(f,mag2db(abs(tf_mean)),':k') ; % .*sign(sin(phases))
title('Bode plot') ;
xlabel('Relative frequency') ; ylabel('Gain [dB]') ;