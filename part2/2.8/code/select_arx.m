function [best_arx_sys, best_red_arx_sys] = select_arx(varargin)
%SELECT ARX
%System Identification & Modeling
%
%Authors:
%HENRI DE PLAEN, SANDER SWITSERS
%r0681349, r0462339
%KULeuven
%
%Date:
%10-1-2018

%% init
%set sizes
L_val = 200 ;
L_test_1 = 200 ;
L_test_2 = 200 ;
L_learn = 1000 ;

%parameter search ranges
na_range = 8:3:35 ;%23
nb_range = 24:3:32 ;%25

%misc
delay = 14 ;
opt = simOptions('AddNoise',false);

%% datasets
if (nargin == 12)
    input_val = varargin{1};
    input_test_1 = varargin{2};
    input_test_2 = varargin{3};
    input_learn = varargin{4};
    output_val = varargin{5};
    output_test_1 = varargin{6};
    output_test_2 = varargin{7};
    output_learn = varargin{8};
    data_val = varargin{9};
    data_test_1 = varargin{10};
    data_test_2 = varargin{11};
    data_learn = varargin{12};
    
else
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
end

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
        
        arx_ss = arx (data_learn, order) ;
        output_arx = sim(arx_ss,input_test_2,opt) ;
        
        arx_fit = fit_test(output_arx,output_test_2) ;
        arx_aic = aic(arx_ss) ;
        
        arx_fit_results(idx_na,idx_nb) = arx_fit ;
        arx_aic_results(idx_na,idx_nb) = arx_aic ;
        arx_orders(idx_na,idx_nb,:) = order ;
    end
end

%% select model
[~,index_min_na] = min(min(arx_aic_results,[],2)) ;
[~,index_min_nb] = min(min(arx_aic_results,[],1)) ;
best_order = arx_orders(index_min_na,index_min_nb,:) ;
best_order = transpose(squeeze(best_order));
best_arx_sys = arx (data_learn, best_order);

disp('best order');
disp(best_order);
disp('index_best');
disp([index_min_na,index_min_nb]);
disp('arx fit');
disp(arx_fit_results);
disp('arx aic');
disp(arx_aic_results);

%% find reduced model
arx_ss = ss(best_arx_sys);
figure; hsvd(arx_ss);

red_orders = 7:15;
red_arx_fit_results = zeros(length(red_orders),2);

%values for n chosen from hsvd
for n = 1:length(red_orders)
    order = red_orders(n);
    
    red_arx_ss = balred(arx_ss,order);
    red_arx_sys = idpoly(red_arx_ss);
    output_arx = sim(red_arx_sys,input_test_2,opt) ;
    
    red_arx_fit = fit_test(output_arx,output_test_2) ;
    red_arx_fit_results(n,:) = [red_orders(n),red_arx_fit];
end
disp('reduced arx fit');
disp(red_arx_fit_results);
% order 9 is a good compromise
red_arx_ss = balred(arx_ss,9);
best_red_arx_sys = idpoly(red_arx_ss);

%% plots
%bode
output_val_arx = sim(best_arx_sys,input_val,opt) ;
[magnitudes_arx,phases_arx,freqs_arx] = bode(best_arx_sys) ;
magnitudes_arx = squeeze(magnitudes_arx) ;
phases_arx = squeeze(phases_arx) ;

output_val_red_arx = sim(best_red_arx_sys,input_val,opt) ;
[magnitudes_red_arx,phases_red_arx,freqs_red_arx] = bode(best_red_arx_sys) ;
magnitudes_red_arx = squeeze(magnitudes_red_arx) ;
phases_red_arx = squeeze(phases_red_arx) ;

load 'bode_experiment.mat' ;
figure ;
subplot(1,2,1) ; hold on ;
plot(rel_freqs_est,mag2db(magnitudes_est),'--k') ;
plot(freqs_arx,mag2db(magnitudes_arx),'-k') ;
plot(freqs_red_arx,mag2db(magnitudes_red_arx),'-.k') ;
plot(rel_freqs_est,0*rel_freqs_est,':k') ;
title('Bode plot') ;
xlabel('Relative frequency [f/f_s]') ; ylabel('Intensity [dB]') ;
axis([0 pi -inf inf]) ;
legend('real output','ARX','red ARX') ;

%poles
[p_arx,z_arx] = pzmap(best_arx_sys) ;
p_arx_x = real(p_arx) ; p_arx_y = imag(p_arx) ;
z_arx_x = real(z_arx) ; z_arx_y = imag(z_arx) ;

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

figure;
compare(data_val,best_arx_sys,best_red_arx_sys);

figure;
subplot(1,2,1);
resid(data_val,best_arx_sys);

subplot(1,2,2);
resid(data_val,best_red_arx_sys);
% %tf
% load 'tf_experiment.mat' ;
%
%
% subplot(2,2,[3 4]) ;

