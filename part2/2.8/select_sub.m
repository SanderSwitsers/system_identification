function [best_sub_sys] = select_sub(varargin)
%SELECT SUBSPACE SYSTEM
%System Identification & Modeling
%
%Authors:
%SANDER SWITSERS
%r0462339
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

%% find good model

sub_orders = 8:15;
sub_fit_results = zeros(length(sub_orders),2);

%values for n chosen from hsvd
for n = 1:length(sub_orders)
    order = sub_orders(n);
    
    sub_ss = n4sid(data_learn,order);
    sub_sys = idpoly(sub_ss) ;
    output_sub = sim(sub_sys,input_test_2,opt) ;
        
    sub_fit = fit_test(output_sub,output_test_2) ;
    sub_fit_results(n,:) = [order,sub_fit];
end
disp('sub fit');
disp(sub_fit_results);
% order 10 is a good fit
best_sub_ss = n4sid(data_learn,10);
best_sub_sys = idpoly(best_sub_ss);

%% plots
%bode
output_val_sub = sim(best_sub_sys,input_val,opt) ;
[magnitudes_sub,phases_sub,freqs_sub] = bode(best_sub_sys) ;
magnitudes_sub = squeeze(magnitudes_sub) ;
phases_sub = squeeze(phases_sub) ;

load 'bode_experiment.mat' ;
figure ;
subplot(1,2,1) ; hold on ;
plot(rel_freqs_est,mag2db(magnitudes_est),'--k') ; 
plot(freqs_sub,mag2db(magnitudes_sub),'-k') ;
plot(rel_freqs_est,0*rel_freqs_est,':k') ;
title('Bode plot') ;
xlabel('Relative frequency [f/f_s]') ; ylabel('Intensity [dB]') ;
axis([0 pi -inf inf]) ;
% legend('Estimated','ARMAX','red ARMAX') ;
legend('real output','SUB') ;

%poles
[p_sub,z_sub] = pzmap(best_sub_sys) ;
p_sub_x = real(p_sub) ; p_sub_y = imag(p_sub) ;
z_sub_x = real(z_sub) ; z_sub_y = imag(z_sub) ;

subplot(1,2,2) ; hold on ;
plot(p_sub_x,p_sub_y,'ok') ; plot(z_sub_x,z_sub_y,'*k') ;
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
compare(data_val,best_sub_sys);

figure;
resid(data_val,best_sub_sys);