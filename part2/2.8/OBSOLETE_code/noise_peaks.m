%Noise visualization 2
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
L = 1000 ;

input = zeros(L,1) ;
output = exercise2(input) ;

%% get rid of the peaks
% idx1 = output > 1.1*offset ;
% idx2 = output < 0.9*offset ;
% idx = find(idx1 + idx2) ;
% for i = idx
%     %interpolation for missing clipped data
%     output(i) = output(i-1)/2+output(i+1)/2 ;     
% end

output = pkshave(output,[0.9 1.1]*offset,false) ;

%% plot signal
subplot(2,2,1) ;
plot(1:L,input,'-k') ;
title('Input signal') ;
xlabel('Samples') ; ylabel('Magnitude') ;

subplot(2,2,3) ;
plot(1:1000,output,'-k') ;
title('Output signal') ;
xlabel('Samples') ; ylabel('Magnitude') ;

%% analyze signal
f_output = fft(output-offset) ;
f_output = f_output/L ;
f_output = f_output(1:L/2+1) ;
f_output(2:end-1) = 2*f_output(2:end-1);

f_shift = 2*(0:(L/2))/L/T;

subplot(2,2,2) ;
plot(f_shift,20*log(abs(f_output))./log(10),'-k') ;
title('Frequency power of the output signal') ;
xlabel('Relative frequency') ; ylabel('Intensity [dB]') ;

subplot(2,2,4) ;
plot(f_shift,angle(f_output),'-k') ;
title('Frequency phase of the output signal') ;
xlabel('Relative frequency') ; ylabel('Phase [rad]') ;
axis([-inf inf -4 4]) ;