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

n_expe = 100 ;
approx_offset = 14.95 ;

%% signal
L = 1000 ;

input = zeros(L,1) ;
outputs = zeros(L,n_expe) ;
output = exercise2(input) ;

for idx = 1:n_expe
    output_temp = pkshave(exercise2(input), [0.8 1.2]*approx_offset,false);
    outputs(:,idx) = output_temp ;
end

mean_output = mean(outputs,1) ;

%% claculate offset
offset_mean = mean(mean_output)
offset_variance = var(mean_output)
