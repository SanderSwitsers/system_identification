%Noise offset 
%System Identification and Modeling
%Exercise - Part 2
%
%HENRI DE PLAEN
%r0681349
%KULeuven
%
%Date: 1-5-2018

%% init
clear all ; clc ; close all ;

%% expes
n_expe = 2 ;
input = zeros(1000,1) ;
output = zeros(1000,n_expe) ; %prealloc

for idx = 1:n_expe
output(:,idx) = exercise2(input) ;
end

%% calculate offset
offset = mean(mean(output,2)) ;
offset_variance = var(mean(output,1)) ;