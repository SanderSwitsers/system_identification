%NOISE SPECTRUM
%System Identification & Modeling
%
%Author:
%HENRI DE PLAEN
%r0681349
%KULeuven
%
%Date:
%6-1-2018 (new version after crash)

%% init
clear all ; close all ; clc ;

offset = 14.95 ;

%% signal
L = 1000 ;

input = zeros(L,1) ;
output = exercise2(input)-offset ;
output = pkshave(output, [-2 2],false);

%% analysis
f_output = abs(fft(output)/L) ;
f_output = f_output(1:L/2+1) ;
f_output(2:end-1) = 2*f_output(2:end-1) ;

%% plot
figure ;
subplot(1,2,1) ;
plot(1:L,output,'-k') ;
title('Output') ;
xlabel('Sample') ; ylabel('Magnitude') ;
axis([0 L -2 2]) ;

subplot(1,2,2) ;
plot((1:L/2+1)/L,-mag2db(f_output),'-k') ;
title('Frequency') ;
xlabel('Normalized frequency [f/f_s]') ; ylabel('Intensity [dB]') ;
axis([0 .501 0 inf]) ;
