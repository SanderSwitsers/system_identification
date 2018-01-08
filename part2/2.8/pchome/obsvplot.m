% 
% This function will calculate the observability plot 
% of a 2 state system.
%
% [x,y]=obsvplot(A,C)
%
% plot(x,y) will show the observability plot
%
% Copyright 	Peter Van Overschee
%		January 3, 1994
%
%		Feel free to copy and alter
%

function [x,y]=obsvplot(A,C)

% Calculate the Grammian
Q=dgram(A',C');

% Make a vector of unit vectors (xs):
xst=exp(j*2*[0:0.01:1]*pi);
xs=[real(xst);imag(xst)];

% Calculate the energy:
en=diag(xs'*Q*xs);

% Designate the right outputs:
x=xs(1,:)'.*en;
y=xs(2,:)'.*en;
