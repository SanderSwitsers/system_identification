function [ varargout ] = least_squares_notch( varargin )
%LEAST_SQUARES Implements a basic version of the linear least squares
%offline notch filter for a specific frequency in time domain.
%
%y_filtered = least_squares_notch( y_source, n, freq, T)
%Input:
%   * y_source: signal to be filtered
%   * n: size of filter
%   * freq: frequency to be removed (in Hz)
%   * T: sampling period (1/f_sampling)
%Ouput:
%   * y_filtered: filtered signal
%
%   Author:
%   HENRI DE PLAEN
%   Date: 1-4-18
%   KULeuven

%% init
assert(nargin==4,'Bad number of input arguments') ;
y_source = varargin{1} ;
n = varargin{2} ;
freq = varargin{3} ;
T = varargin{4} ;
N = length(y_source)-1 ;
assert(n<=N,'The wanted estimator length is too big for given data') ;

%% generate A
N_r = floor(N/20) ; %approximate, must take general input !!
t = 0:T:T*(N_r-1);
f_cos = repmat(cos(t*2*pi*freq),[1 20]);
f_sin = repmat(sin(t*2*pi*freq),[1 20]);
A = [f_sin f_cos] ;

%% generate b
b = y_source ;

%% minimize
x = lsqlin(A,b) ;

%% solution
varargout{1} = x;

end

