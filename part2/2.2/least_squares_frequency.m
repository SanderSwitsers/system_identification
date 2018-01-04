function [ varargout ] = least_squares_frequency( varargin )
%LEAST_SQUARES Implements a basic version of the linear least squares
%offline notch filter for a specific frequency in frequency domain.
%
%y_filtered = least_squares_notch(y_source freq, T)
%Input:
%   * y_source: signal to be filtered in time domain
%   * freq: frequency to be removed (in Hz)
%   * T: sampling period (1/f_sampling)
%Ouput:
%   * y_filtered: filtered signal in time domain
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
N = length(y_source) ;

%% set to frequency domain
f_source = fft(y_source,N) ;

%% filter
f_shift = (0:(N/2))/N/T;
idx = ~(f_shift==freq) ;
A = diag([idx(1:end-1) flip(idx(2:end))]) ;
f_filter = A*f_source ;

%% set back to time domain
y_filter = ifft(f_filter) ;

%% solution
varargout{1} = y_filter;

end

