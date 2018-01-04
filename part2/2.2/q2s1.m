notch_signal ;

T=1/N; %in sec
freq = 1 ; %in Hz

% BOTH WORKING WITH SAME RESULT !
%y_filtered = least_squares_notch(y,freq,T) ;
y_filtered = least_squares_frequency(y,freq,T) ;

f_source = fft(y,L) ;
f_filtered = fft(y_filtered,L) ;
f_diff = f_source-f_filtered ;

f_source = f_source/L ;
f_source = f_source(1:L/2+1) ;
f_source(2:end-1) = 2*f_source(2:end-1);

f_filtered = f_filtered/L ;
f_filtered = f_filtered(1:L/2+1) ;
f_filtered(2:end-1) = 2*f_filtered(2:end-1);

f_diff = f_diff/L ;
f_diff = f_diff(1:L/2+1) ;
f_diff(2:end-1) = 2*f_diff(2:end-1);

f_shift = (0:(L/2))/L/T;

subplot(1,2,1) ;
plot(f_shift,20*log(abs(f_filtered)./abs(f_source))/log(10),'-k') ;
title('Reduction of the filtered part') ;
xlabel('Frequency [Hz]') ; ylabel('Reduction [dB]') ;

subplot(1,2,2) ;
plot(f_shift,angle(round(f_diff,3)),'-k') ;
title('Phase of the filtered part') ;
xlabel('Frequency [Hz]') ; ylabel('Phase [rad]') ;
axis([0 max(f_shift) -pi pi]) ;