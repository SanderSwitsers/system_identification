%  
%  This function plots the difference between the transfer function
%  of two theta models.
%  
%  diffth(th1,th2)
%
%  Copyright 	Peter Van Overschee
%		January 5, 1995
%
%		Feel free to copy and alter
%

function diffth(th1,th2)

% the first TF
[num1,den1] = th2tf(th1);
% the second TF
[num2,den2] = th2tf(th2);

% the difference
numd = conv(num1,den2) - conv(num2,den1);
dend = conv(den1,den2);

% Frequency axis
w = [1:128]/128*pi;

% Magnitude of the difference
m = dbode(numd,dend,1,w);

% Plot
hold off;subplot
plot(w/2/pi,m)
title('Magnitude of the difference || G1 - G2 ||');
xlabel('frequency (Hz)');
