function [ varargout ] = arm( varargin )
%ARM Autoregressive modelling
%   sys = arm(data,n)
%   (n: order of the model, default 1)
%
%System Identification & Modeling
%
%Author:
%HENRI DE PLAEN
%r0681349
%KULeuven
%
%Date:
%6-1-2018 (new version after crash)

%% init
assert(nargin<=2,'Bad number of input arguments: 2 required') ;
assert(nargout==1,'Bad number of output arguments: 1 required') ;
data = varargin{1} ;
if nargin==1
    n = 1 ;
else
    n = varargin{2} ;
end

%% least squares
input = data.InputData ;
output = data.OutputData ;


sys = tf(numerator,denominator,-1) ;

%% finalize
varargout{1} = sys ;


end

