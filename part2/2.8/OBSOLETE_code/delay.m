%Delay of system
%System Identification and Modeling
%Exercise - Part 2
%
%HENRI DE PLAEN
%r0681349
%KULeuven
%
%Date: 1-5-2018

%% init
clear all ; close all ; clc ; figure ;
noise_offset ;
T = 1 ;
L = 30 ;
max_expe = 100 ;

%% signals
input = zeros(L,1) ;
input(1) = 3 ; %max intensity before saturation

output = zeros(L,max_expe) ;
for idx = 1:max_expe
    output(:,idx) = pkshave(exercise2(input),[0.9 1.1]*offset,false)-offset;
end

output = mean(output,2) ;

f_output = fft(output) ;
plot(abs(f_output)) ;

%% plot signal
subplot(2,2,1) ;
stem(1:L,input,'black') ;
title('Input signal') ;
xlabel('Samples') ; ylabel('Magnitude') ;

subplot(2,2,2) ;
stem(1:L,output,'black') ;
title('Output signal') ;
xlabel('Samples') ; ylabel('Magnitude') ;

%% analysis
f_output = fft(output) ;
f_output = f_output/L ;
f_output = f_output(1:L/2+1) ;
f_output(2:end-1) = 2*f_output(2:end-1);

f_shift = (0:(L/2))/L/T;

%% cra
subplot(2,2,[3 4]) ;
u_cra = randn(1000,1) ;
y_cra = exercise2(u_cra) ;
y_cra = pkshave(y_cra,[0.9 1.1]*offset,false)-offset ;
[b,a] = butter(4,.03,'high') ;
y_cra = filter(b,a,y_cra) ;

data = iddata(y_cra,u_cra,T) ;
cra(data,L) ;


