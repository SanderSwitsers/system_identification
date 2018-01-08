% 
% This function will calculate the controllability plot 
% of a 2 state system.
%
% [x,y]=ctrbplot(A,B)
%
% plot(x,y) will show the controllability plot
%
% Copyright 	Peter Van Overschee
%		January 3, 1994
%
%		Feel free to copy and alter
%

function [x,y]=ctrbplot(A,B)

% Calculate the Grammian
P=dgram(A,B);

% Make a vector of unit vectors (xs):
xst=exp(j*2*[0:0.01:1]*pi);
xs=[real(xst);imag(xst)];

% Calculate the energy:
en=diag(xs'*inv(P)*xs);

% Designate the right outputs:
x=xs(1,:)'.*en;
y=xs(2,:)'.*en;
