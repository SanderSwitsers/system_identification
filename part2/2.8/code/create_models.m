%CREATE MODELS
%System Identification & Modeling
%
%creates graphs of all models and saves the models
%comment out select_model if that patricular model isn't necesarry
%this was made to create all the models with the same input
%
%Author:
%SANDER SWITSERS
%r00462339
%KULeuven
%
%Date:
%10-1-2018

%% init
clear all ; close all ; clc ;L_val = 200 ;
L_test_1 = 200 ;
L_test_2 = 200 ;
L_learn = 1000 ;

%misc
delay = 14 ;
opt = simOptions('AddNoise',false);


%% datasets
%validation set
input_val = randn(L_val,1) ;
output_val = exercise2(input_val) ;
output_val = preprocess(output_val) ;
input_val = input_val(1:end-delay) ;
data_val = iddata(output_val, input_val) ;

%test set #1
input_test_1 = randn(L_test_1,1) ;
output_test_1 = exercise2(input_test_1) ;
output_test_1 = preprocess(output_test_1) ;
input_test_1 = input_test_1(1:end-delay) ;
data_test_1 = iddata(output_test_1, input_test_1) ;

%test set #2
input_test_2 = randn(L_test_2,1) ;
output_test_2 = exercise2(input_test_2) ;
output_test_2 = preprocess(output_test_2) ;
input_test_2 = input_test_2(1:end-delay) ;
data_test_2 = iddata(output_test_2, input_test_2) ;

%learning set
input_learn = randn(L_learn,1) ;
output_learn = exercise2(input_learn) ;
output_learn = preprocess(output_learn) ;
input_learn = input_learn(1:end-delay) ;
data_learn = iddata(output_learn, input_learn) ;

% [barx,brarx] = select_arx(input_val,input_test_1,input_test_2,input_learn ...
%     ,output_val,output_test_1,output_test_2,output_learn ...
%     ,data_val,data_test_1,data_test_2,data_learn);
% 
% [barmax,brarmax] = select_armax(input_val,input_test_1,input_test_2,input_learn ...
%     ,output_val,output_test_1,output_test_2,output_learn ...
%     ,data_val,data_test_1,data_test_2,data_learn);
% 
% [boe,broe] = select_oe(input_val,input_test_1,input_test_2,input_learn ...
%     ,output_val,output_test_1,output_test_2,output_learn ...
%     ,data_val,data_test_1,data_test_2,data_learn);
% 
% [bbj,brbj] = select_bj(input_val,input_test_1,input_test_2,input_learn ...
%     ,output_val,output_test_1,output_test_2,output_learn ...
%     ,data_val,data_test_1,data_test_2,data_learn);

[A,B,C,D] = deter_sys(output_test_1,input_test_1,50,12);
