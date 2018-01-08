%NOISE PEAKS
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

n_expe = 100 ;
offset = 14.95 ;

%% signal
L = 1000 ;

input = zeros(L,1) ;
outputs = zeros(L,n_expe) ;
output = exercise2(input) ;

for idx = 1:n_expe
    output_temp = exercise2(input)-offset ;
    without_peaks = pkshave(output_temp, [-2 2],false);
    outputs(:,idx) = output_temp-without_peaks ;
end

%% analysis
mean_peaks = mean(outputs,2) ;
mag_peaks = abs(fft(mean_peaks)/L) ;
mag_peaks = mag_peaks(1:L/2+1) ;
mag_peaks(2:end-1) = 2*mag_peaks(2:end-1) ;

%% plot
figure ;
subplot(1,2,1) ;
plot(1:L,mean_peaks,'-k') ;
title('Output peaks') ;
xlabel('Sample') ; ylabel('Magnitude') ;
axis([0 L -1 1]) ;

subplot(1,2,2) ;
plot(1:L/2+1,mag2db(mag_peaks),'-k') ;
title('Frequency') ;
xlabel('z^{-1}') ; ylabel('Intensity [dB]') ;
axis([0 L/2+1 0 inf]) ;
