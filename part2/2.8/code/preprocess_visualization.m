%PREPROCESS VISUALIZATION
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

%% signals
L = 1000 ;

input = zeros(L,1) ;
before = exercise2(input) ;
after = preprocess(before) ;

%% plot
figure ;
subplot(1,2,1) ;
plot(1:L,before,'-k') ;
title('Before preprocess') ;
xlabel('Sample') ; ylabel('Magnitude') ;
axis([0 L -2 25]) ;

subplot(1,2,2) ;
plot(1:L-14,after,'-k') ;
title('After preprocess') ;
xlabel('Sample') ; ylabel('Magnitude') ;
axis([0 L -2 25]) ;
