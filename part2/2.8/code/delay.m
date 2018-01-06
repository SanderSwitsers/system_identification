%DELAY
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
clear all ; close all ; clc ; figure ;

n_expe = 200 ;
offset = 14.95 ;
L = 30 ;

w_c = .1 ;
butter_order = 2 ;

%% signal
impulse_signal = zeros(L,1) ;
impulse_signal(1) = 3 ;
response_signals = zeros(L,n_expe) ;

[filter_b, filter_a] = butter(butter_order,w_c,'high') ;

for idx = 1:n_expe
    response_signal_temp = exercise2(impulse_signal)-offset ;
    response_signal_temp = pkshave(response_signal_temp, [-2 2],false);
    response_signal_temp = filter(filter_b, filter_a,response_signal_temp) ;
    response_signals(:,idx) = response_signal_temp ;
end

mean_response_signal = mean(response_signals,2)/3 ;

%% plot
subplot(2,2,1) ;
stem(1:L,impulse_signal,'-k') ;
title('Impulse') ;
xlabel('Sample') ; ylabel('Magnitude') ;
axis([0 L -1 4]) ;
line([15 15], get(gca, 'ylim'),'Color','black','LineStyle',':');

subplot(2,2,2) ;
stem(1:L,mean_response_signal,'-k') ;
title('Response') ;
xlabel('Sample') ; ylabel('Magnitude') ;
axis([0 L -.5 .5]) ;
line([15 15], get(gca, 'ylim'),'Color','black','LineStyle',':');

%% cra
input = randn(2000,1) ;
output = exercise2(input)-offset ;
output = pkshave(output, [-2 2],false);
output = filter(filter_b, filter_a,output) ;
data = iddata(output,input) ;

subplot(2,2,[3 4]) ;
ir = cra(data,L,0,1) ;
title('CRA analysis') ;
xlabel('Sample') ; ylabel('Magnitude') ;
line([15 15], get(gca, 'ylim'),'Color','black','LineStyle',':');
axis([0 L -.5 .5]) ;