%SELECT ARX
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

%% select model
[~,index_min_na] = min(min(arx_aic_results,[],2)) ;
[~,index_min_nb] = min(min(arx_aic_results,[],1)) ;
best_order = arx_orders(index_min_na,index_min_nb,:) ;

%% plots
%bode
best_arx_sys = arx (data_learn, order) ;
output_val_arx = sim(best_arx_sys,input_val,opt) ;
[magnitudes_arx,phases_arx,freqs_arx] = bode(best_arx_sys) ;
magnitudes_arx = squeeze(magnitudes_arx) ;
phases_arx = squeeze(phases_arx) ;

load 'bode_experiment.mat' ;
figure ;
subplot(1,2,1) ; hold on ;
plot(rel_freqs_est,mag2db(magnitudes_est),'--k') ; 
plot(freqs_arx,mag2db(magnitudes_arx),'-k') ;
plot(rel_freqs_est,0*rel_freqs_est,':k') ;
title('Bode plot') ;
xlabel('Relative frequency [f/f_s]') ; ylabel('Intensity [dB]') ;
axis([0 pi -inf inf]) ;
legend('Estimated','ARX') ;

%poles
[p_arx,z_arx] = pzmap(best_arx_sys) ;
p_arx_x = real(p_arx) ; p_arx_y = imag(p_arx) ;
z_arx_x = real(z_arx) ; z_arx_y = imag(p_arx) ;

subplot(1,2,2) ; hold on ;
plot(p_arx_x,p_arx_y,'ok') ; plot(z_arx_x,z_arx_y,'*k') ;
title('Pole-Zero map of estimated model') ;
xlabel('Real part') ; ylabel('Imaginary part') ;
legend('Poles','Zeros') ;
r = 1 ; x = 0 ; y = 0 ;
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x ;
yunit = r * sin(th) + y ;
plot(xunit, yunit,':k') ;
line([0 0], get(gca, 'xlim'),'Color','black','LineStyle',':') ;
line(get(gca, 'ylim'), [0 0],'Color','black','LineStyle',':') ;
axis([-2 2 -2 2]) ;

% %tf
% load 'tf_experiment.mat' ;
% 
% 
% subplot(2,2,[3 4]) ;



