%NOISE VISUALIZATION
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

%% signal
L = 1000 ;

input = zeros(L,1) ;
output = exercise2(input) ;

%% plot
figure ;
subplot(1,2,1) ;
plot(1:L,input,'-k') ;
title('Input') ;
xlabel('Sample') ; ylabel('Magnitude') ;
axis([0 L -5 25]) ;

subplot(1,2,2) ;
plot(1:L,output,'-k') ;
title('Output') ;
xlabel('Sample') ; ylabel('Magnitude') ;
axis([0 L -5 25]) ;
