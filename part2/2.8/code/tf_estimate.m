%TRANSFER FUNCTION ESTIMATE
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
clear all ; close all ; clc ;

L = 2000 ;
delay = 15 ;
n_expe = 50 ;

%% estimate
input = randn(L,1) ;

tfs = zeros(257,n_expe) ;

for idx_expe = 1:n_expe
    output = exercise2(input) ;
    output = preprocess(output) ;
    input = input(1:end-delay+1) ;
    [tf_est,freqs_tf_est] = tfestimate(input,output) ;
    tfs(:,idx_expe) = tf_est ;
end

tf_est = mean(tfs,2) ;

%% plot
figure ;
plot(freqs_tf_est,abs(tf_est),'-k') ;
title('Estimated transfer function') ;
xlabel('Normalized frequency [f/f_s]') ; ylabel('Magnitude') ;
axis([0 pi -inf inf]) ;

%% save
filename = 'tf_estimate.mat' ;
save(filename,'tf_est','freqs_tf_est') ;