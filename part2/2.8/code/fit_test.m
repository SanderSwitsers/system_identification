function [ varargout ] = fit_test( varargin )
%FIT TEST tests how well the data is fitted to the model
%fit function : lsq
%   fit = fit_test(y_estimate,y_real) ;
%
%System Identification and Modeling
%Exercise - Part 2
%
%HENRI DE PLAEN
%r0681349
%KULeuven
%
%Date: 1-6-2018

%% init
assert(nargin==2,'Bad number of input parameters') ;
assert(nargout==1,'Bad number of output parameters') ;
y_estimate = varargin{1} ;
y_real = varargin{2} ;

%% fit
fit = sqrt( sum((y_real-y_estimate).^2)./sum(y_real.^2)) ;
varargout{1} = fit ;

end

