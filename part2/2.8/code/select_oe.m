%SELECT OUTPUT ERROR MODEL
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
%set sizes
L_val = 200 ;
L_test_1 = 200 ;
L_test_2 = 200 ;
L_learn = 1000 ;

%parameter search ranges
na_range = 2:3:23 ;
nb_range = 19:3:25 ;

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

%% parameters
%prealloc
na_length = length(na_range) ;
nb_length = length(nb_range) ;
arx_fit_results = zeros(na_length,nb_length) ;
arx_aic_results = zeros(na_length,nb_length) ;
arx_orders = zeros(na_length,nb_length,3) ;

%loop
for idx_na = 1:na_length
    for idx_nb = 1:nb_length
        na = na_range(idx_na) ;
        nb = nb_range(idx_nb) ;
        nk = 0; %preprocess suppressed the delay
        
        search_region = struc(na-1:na+1,nb-1:nb+1,nk) ;
        arx_struc = arxstruc(data_learn , data_test_1 , search_region) ;
        order = selstruc(arx_struc,0) ;
        
        arx_sys = arx (data_learn, order) ;
        output_arx = sim(arx_sys,input_test_2,opt) ;
        
        arx_fit = fit_test(output_arx,output_test_2) ;
        arx_aic = aic(arx_sys) ;
        
        arx_fit_results(idx_na,idx_nb) = arx_fit ;
        arx_aic_results(idx_na,idx_nb) = arx_aic ;
        arx_orders(idx_na,idx_nb,:) = order ;
    end
end