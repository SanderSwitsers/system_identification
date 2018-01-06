%BODE ESTIMATE
%System Identification & Modeling
%
%Author:
%HENRI DE PLAEN
%r0681349
%KULeuven
%
%Date:
%6-1-2018 (new version after crash)

%NOISE OFFSET
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
clear all ; close all ; clc ; figure ;
delay = 14 ;

L = 200 ;
n_expe = 100 ;
n_points = 50 ;

t = 0:L/(L-1):L ;
rel_freqs = linspace(0,1/2,n_points) ;

%prealloc
outputs = zeros(L-delay,n_expe) ;
magnitudes = zeros(n_points,1) ;
phases = zeros(n_points,1) ;

%% calculate
h = waitbar(0,'Processing...') ;
for idx_points = 1:n_points
    %signal
    input = 3*sin(2*pi*t*rel_freqs(idx_points)) ;

    %experiments
    for idx_expe = 1:n_expe
        outputs(:,idx_expe) = preprocess(exercise2(input)) ;
        waitbar(((idx_points-1)*n_expe + idx_expe)/n_expe/n_points,h) ;
    end

    %fft
    output = mean(outputs,2) ;
    f_output = abs(fft(output)/L) ;
    f_output = f_output(1:L/2+1) ;
    f_output(2:end-1) = 2*f_output(2:end-1) ;

    %analyze
    magnitude = max(abs(f_output)) ;
    pos = find(abs(f_output)==magnitude) ;
    
    %store
    magnitudes(idx_points) = magnitude ;
    phases(idx_points) = angle(pos(1)) ;
end
close(h) ;

%% plot
figure ;
subplot(1,2,1) ;
plot(rel_freqs,mag2db(magnitudes),'--k',rel_freqs,0*rel_freqs,':k') ;
title('Bode estimation') ;
xlabel('Relative frequency [f/f_s]') ; ylabel('Intensity [dB]') ;
axis([0 .5 -40 10]) ;

subplot(1,2,2) ;
plot(rel_freqs,phases,'--k',rel_freqs,0*rel_freqs,':k') ;
title('Phase change estimation') ;
xlabel('Relative frequency [f/f_s]') ; ylabel('Phase change [rad]') ;
axis([0 .5 -4 4]) ;

    
    
