function [ varargout ] = least_squares( varargin )
%LEAST_SQUARES Implements a basic version of the linear least squares
%predictor of a system.
%
%x = least_squares(y,n)
%
%   Author:
%   HENRI DE PLAEN
%   Date: 1-4-18
%   KULeuven

%% init
assert(nargin==2,'Bad number of input arguments: 2 required');
assert(nargout==1,'Bad number of output arguments: 1 required') ;
y = varargin{1} ;
n = varargin{2} ;
N = length(y)-1 ;
assert(n<=N,'The wanted estimator length is too big for given data') ;

%% generate A
c = y(n:N) ;
r = flip(y(1:n)) ;
A = toeplitz(c,r) ;

%% generate b
b = y(n+1:N+1) ;

%% minimize
x = lsqlin(A,b) ;

%% solution
varargout{1} = x;

end

