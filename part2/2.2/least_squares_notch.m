function [ varargout ] = least_squares_notch( varargin )
%LEAST_SQUARES Implements a basic version of the linear least squares
%offline notch filter for a specific frequency in time domain.
%
%y_filtered = least_squares_notch( y_source freq, T)
%Input:
%   * y_source: signal to be filtered
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
assert(nargin==3,'Bad number of input arguments') ;
y_source = varargin{1} ;
freq = varargin{2} ;
T = varargin{3} ;
n = length(y_source)-1 ;

%% generate A
N = floor((n+1)/20) ;
t = 0:T:T*(N-1);
f_cos = repmat(cos(t*2*pi*freq),[1 20]);
f_sin = repmat(sin(t*2*pi*freq),[1 20]);
A = [f_sin' f_cos'] ;

%% generate b
b = y_source ;

%% minimize
x = lsqlin(A,b) ;

%% solution
varargout{1} = y_source-A*x;

end

