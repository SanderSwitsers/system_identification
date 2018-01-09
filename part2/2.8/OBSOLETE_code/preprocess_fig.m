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
clear all ; close all ; clc ; figure ;
T = 1 ;
L = 1000 ;

input = zeros(L,1) ;
output_raw = exercise2(input) ;
output_pre = preprocess(output_raw) ;

%% plot
subplot(2,1,1) ;
plot(1:L,output_raw,'-k') ;
title('Output signal before preprocessing') ;
xlabel('Samples') ; ylabel('Magnitude') ;
axis([0 L -5 25]);

subplot(2,1,2) ;
plot(1:(L-14),output_pre,'-k') ;
title('Output signal after preprocessing') ;
xlabel('Samples') ; ylabel('Magnitude') ;
axis([0 L -5 25]);