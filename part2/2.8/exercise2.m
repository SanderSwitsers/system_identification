% Simulate your system with input u
% The result is stored in the vector y
%
% y = exercise3(u)
%
% Copyright : Stan De Schepper
% Revised : Tom Bellemans 03/2000
% Revised : Evelyne Dewitte 04/2003
% Revised : Niels Haverbeke 02/2006
% Revised : Philippe Dreesen 11/2011
% Revised : Antoine Vandermeersch 10/2014

function y = exercise2(u)

[~,username] = unix('whoami');
%username = username(1:end-1);
username = 'r0462339' ;

% Select for Matlab version
matlabversion = version('-release');
mexfunc = str2func(['exercise2_mex_',matlabversion]);

y = mexfunc(u,username);

end
