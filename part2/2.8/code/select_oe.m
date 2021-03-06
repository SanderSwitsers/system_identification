function [best_oe_sys,best_red_oe_sys] = select_oe(varargin)
%SELECT OUTPUT ERROR MODEL
%System Identification & Modeling
%
%Author:
%SANDER SWITSERS
%r00462339
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
nb_range = 13:19 ;
nf_range = 13:19 ;

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
nb_length = length(nb_range) ;
nf_length = length(nf_range) ;
oe_fit_results = zeros(nb_length,nf_length) ;
oe_aic_results = zeros(nb_length,nf_length) ;
oe_orders = zeros(nb_length,nf_length,3) ;

%loop
for idx_nb = 1:nb_length
    for idx_nf = 1:nf_length
        nb = nb_range(idx_nb) ;
        nf = nf_range(idx_nf) ;
        nk = 0; %preprocess suppressed the delay
        
        order = [nb,nf,nk] ;
        
        oe_sys = oe (data_learn, order) ;
        output_oe = sim(oe_sys,input_test_2,opt) ;
        
        oe_fit = fit_test(output_oe,output_test_2) ;
        oe_aic = aic(oe_sys) ;
        
        oe_fit_results(idx_nb,idx_nf) = oe_fit ;
        oe_aic_results(idx_nb,idx_nf) = oe_aic ;
        oe_orders(idx_nb,idx_nf,:) = order ;
    end
end

%% select model
[~,index_min] = min(oe_aic_results(:)) ;
[index_min_nb,index_min_nf] = ind2sub(size(oe_aic_results),index_min);
best_order = oe_orders(index_min_nb,index_min_nf,:) ;
best_order = transpose(squeeze(best_order));
best_oe_sys = oe (data_learn, best_order);

disp('best order');
disp(best_order);
disp('index_best');
disp([index_min_nb,index_min_nf]);
disp('oe fit');
disp(oe_fit_results);
disp('oe aic');
disp(oe_aic_results);

%% find reduced model
oe_ss = ss(best_oe_sys);
figure; hsvd(oe_ss);

red_orders = 8:15;
red_oe_fit_results = zeros(length(red_orders),2);

%values for n chosen from hsvd
for n = 1:length(red_orders)
    order = red_orders(n);
    
    red_oe_ss = balred(oe_ss,order);
    red_oe_sys = idpoly(red_oe_ss) ;
    output_oe = sim(red_oe_sys,input_test_2,opt) ;
        
    red_oe_fit = fit_test(output_oe,output_test_2) ;
    red_oe_fit_results(n,:) = [red_orders(n),red_oe_fit];
end
disp('reduced oe fit');
disp(red_oe_fit_results);
% order 8 is a good compromise
red_oe_ss =balred(oe_ss,8);
best_red_oe_sys = idpoly(red_oe_ss);

%% plots
%bode
output_val_oe = sim(best_oe_sys,input_val,opt) ;
[magnitudes_oe,phases_oe,freqs_oe] = bode(best_oe_sys) ;
magnitudes_oe = squeeze(magnitudes_oe) ;
phases_oe = squeeze(phases_oe) ;

output_val_red_oe = sim(best_red_oe_sys,input_val,opt) ;
[magnitudes_red_oe,phases_red_oe,freqs_red_oe] = bode(best_red_oe_sys) ;
magnitudes_red_oe = squeeze(magnitudes_red_oe) ;
phases_red_oe = squeeze(phases_red_oe) ;

load 'bode_experiment.mat' ;
figure ;
subplot(1,2,1) ; hold on ;
plot(rel_freqs_est,mag2db(magnitudes_est),'--k') ; 
plot(freqs_oe,mag2db(magnitudes_oe),'-k') ;
plot(freqs_red_oe,mag2db(magnitudes_red_oe),'-.k') ;
plot(rel_freqs_est,0*rel_freqs_est,':k') ;
title('Bode plot') ;
xlabel('Relative frequency [f/f_s]') ; ylabel('Intensity [dB]') ;
axis([0 pi -inf inf]) ;
legend('real output','OE','red OE') ;

%poles
[p_oe,z_oe] = pzmap(best_oe_sys) ;
p_oe_x = real(p_oe) ; p_oe_y = imag(p_oe) ;
z_oe_x = real(z_oe) ; z_oe_y = imag(z_oe) ;

subplot(1,2,2) ; hold on ;
plot(p_oe_x,p_oe_y,'ok') ; plot(z_oe_x,z_oe_y,'*k') ;
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
compare(data_val,best_oe_sys,best_red_oe_sys);

figure;
%resid(data_val,best_oe_sys);
subplot(1,2,1);
resid(data_val,best_oe_sys);

subplot(1,2,2);
resid(data_val,best_red_oe_sys);