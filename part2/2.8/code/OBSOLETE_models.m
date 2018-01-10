%MODELS
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
L_val = 200 ;
L_learn = 1000 ;

%% validation set
input_val = randn(L_val,1) ;
output_val = exercise2(input_val) ;
output_val = preprocess(output_val) ;
data_val = iddata(output_val, input_val) ;

%% learning set
input_learn = randn(L_learn,1) ;
output_learn = exercise2(output_learn) ;
output_learn = preprocess(output_learn) ;
data_learn = iddata(output_learn, input_learn) ;

%% arx
na_arx = 1 ;
nb_arx = 1 ;
nk_arx = 1 ;
sys_arx = arx(data,[na_arx nb_arx nk_arx]) ;






