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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TO DO:
% * choose freq with variance ratio and not maximum

%% init 
clear all ; close all ; clc ; figure ;
delay = 14 ;

L = 200 ;
n_expe = 100 ;
n_points = 50 ;

t = 0:L/(L-1):L ;
rel_freqs_est = linspace(0,pi,n_points) ;

%prealloc
outputs = zeros(L-delay,n_expe) ;
magnitudes_est = zeros(n_points,1) ;
phases_est = zeros(n_points,1) ;

%% calculate
h = waitbar(0,'Processing...') ;
for idx_points = 1:n_points
    %signal
    input = 3*sin(t*rel_freqs_est(idx_points)) ;

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
    magnitudes_est(idx_points) = magnitude ;
    phases_est(idx_points) = angle(pos(1)) ;
end
close(h) ;

%% plot
figure ;
% subplot(1,2,1) ;
plot(rel_freqs_est,mag2db(magnitudes_est),'--k',rel_freqs_est,0*rel_freqs_est,':k') ;
title('Bode estimation') ;
xlabel('Relative frequency [f/f_s]') ; ylabel('Intensity [dB]') ;
axis([0 pi -50 15]) ;

% subplot(1,2,2) ;
% plot(rel_freqs_est,phases_est,'--k',rel_freqs_est,0*rel_freqs_est,':k') ;
% title('Phase change estimation') ;
% xlabel('Relative frequency [f/f_s]') ; ylabel('Phase change [rad]') ;
% axis([0 .5 -4 4]) ;

%% save
filename = 'bode_experiment.mat' ;
save(filename,'magnitudes_est','phases_est','rel_freqs_est') ;
