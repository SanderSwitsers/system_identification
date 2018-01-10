function [best_armax_sys,best_red_armax_sys] = select_armax(varargin)
%SELECT ARMAX
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
na_range = 16:22 ;
nb_range = 11:16 ;
nc_range = 14:16 ;

%misc
delay = 14 ;
opt = simOptions('AddNoise',false);

%% init
%set sizes
L_val = 200 ;
L_test_1 = 200 ;
L_test_2 = 200 ;
L_learn = 1000 ;

%parameter search ranges
na_range = 2:3:32 ;%23
nb_range = 22:4:32 ;%25

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
nc_length = length(nc_range) ;
armax_fit_results = zeros(na_length,nb_length,nc_length) ;
armax_aic_results = zeros(na_length,nb_length,nc_length) ;
armax_orders = zeros(na_length,nb_length,nc_length,4) ;

%loop
for idx_na = 1:na_length
    for idx_nb = 1:nb_length
        for idx_nc = 1:nc_length
            na = na_range(idx_na) ;
            nb = nb_range(idx_nb) ;
            nc = nc_range(idx_nc) ;
            nk = 0; %preprocess suppressed the delay
            
            order = [na,nb,nc,nk] ;
            armax_sys = armax (data_learn, order) ;
            output_armax = sim(armax_sys,input_test_2,opt) ;
            
            armax_fit = fit_test(output_armax,output_test_2) ;
            armax_aic = aic(armax_sys) ;
            
            armax_fit_results(idx_na,idx_nb,idx_nc) = armax_fit ;
            armax_aic_results(idx_na,idx_nb,idx_nc) = armax_aic ;
            armax_orders(idx_na,idx_nb,idx_nc,:) = order ;
        end
    end
end

%% select model
[~,index_min] = min(armax_aic_results(:)) ;
[index_min_na,index_min_nb,index_min_nc] = ind2sub(size(armax_aic_results),index_min);
best_order = armax_orders(index_min_na,index_min_nb,index_min_nc,:) ;
best_order = transpose(squeeze(best_order));
best_armax_sys = armax (data_learn, best_order);

%% find reduced model
armax_ss = ss(best_armax_sys);
figure; hsvd(armax_ss);

red_armax_fit_results = zeros(8,2);
red_orders = 8:15;

%values for n chosen from hsvd
for n = 1:length(red_orders)
    order = red_orders(n);
    
    red_armax_ss = balred(armax_ss,order);
    red_armax_sys = idpoly(red_armax_ss) ;
    output_armax = sim(red_armax_sys,input_test_2,opt) ;
        
    red_armax_fit = fit_test(output_armax,output_test_2) ;
    red_armax_fit_results(n,:) = [red_orders(n),red_armax_fit];
end
disp(red_armax_fit_results);
% order 13 is a good compromise
red_armax_ss =balred(armax_ss,12);
best_red_armax_sys = idpoly(red_armax_ss);

%% plots
%bode
output_val_armax = sim(best_armax_sys,input_val,opt) ;
[magnitudes_armax,phases_armax,freqs_armax] = bode(best_armax_sys) ;
magnitudes_armax = squeeze(magnitudes_armax) ;
phases_armax = squeeze(phases_armax) ;

output_val_red_armax = sim(best_red_armax_sys,input_val,opt) ;
[magnitudes_red_armax,phases_red_armax,freqs_red_armax] = bode(best_red_armax_sys) ;
magnitudes_red_armax = squeeze(magnitudes_red_armax) ;
phases_red_armax = squeeze(phases_red_armax) ;

load 'bode_experiment.mat' ;
figure ;
subplot(1,2,1) ; hold on ;
plot(rel_freqs_est,mag2db(magnitudes_est),'--k') ; 
plot(freqs_armax,mag2db(magnitudes_armax),'-k') ;
plot(freqs_red_armax,mag2db(magnitudes_red_armax),'-.k') ;
plot(rel_freqs_est,0*rel_freqs_est,':k') ;
title('Bode plot') ;
xlabel('Relative frequency [f/f_s]') ; ylabel('Intensity [dB]') ;
axis([0 pi -inf inf]) ;
legend('Estimated','ARMAX','red ARMAX') ;
%legend('Estimated','ARMAX') ;

%poles
[p_armax,z_armax] = pzmap(best_armax_sys) ;
p_armax_x = real(p_armax) ; p_armax_y = imag(p_armax) ;
z_armax_x = real(z_armax) ; z_armax_y = imag(p_armax) ;

subplot(1,2,2) ; hold on ;
plot(p_armax_x,p_armax_y,'ok') ; plot(z_armax_x,z_armax_y,'*k') ;
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
compare(data_val,best_armax_sys,best_red_armax_sys);

figure;
%resid(data_val,best_armax_sys);
subplot(1,2,1); 
resid(data_val,best_armax_sys);
 
subplot(1,2,2);
resid(data_val,best_red_armax_sys);