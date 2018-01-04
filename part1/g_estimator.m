function varargout = g_estimator(varargin)
%G_ESTIMATE Calculates an estimator for g in the eq y=conv(g,u)
%[g_estimate,cost_ls,cost_aic] = g_estimator(sample_y, sample_u, order, method_name)
%
%   INPUT:
%   sample_y = sample of the output signal y
%   sample_u = sample of the input signal u
%   order = order size
%
%   OUTPUT:
%   g_estimate = FIR estimation of transfer function
%   cost_ls = value of the cost function for Least Squares
%   cost_aic = value of the cost function for Akaike Information Criterion
%
%Author: HENRI DE PLAEN (r0681349)
%Date: 12-08-2017
%Katholieke Universiteit Leuven

assert(nargin==3,'incorrect number of input arguments');

sample_y = varargin{1} ; sample_u = varargin{2} ;
sample_y = sample_y(:) ; sample_u = sample_u(:) ;
order = varargin{3} ;

assert( size(sample_y,1) == size(sample_u,1), ...
    'the samples must have the same size') ;
assert(isscalar(order)&&(order>=0), ...
    'order has to be a positive integer') ;

varargout{1} = g_ls(sample_y,sample_u,order) ;
varargout{2} = cost_ls(sample_y,sample_u,varargout{1}) ;
varargout{3} = (1+2*size(varargout{1},1)/size(sample_u,1))*varargout{2} ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function g_est = g_ls(y, u, order)

K = convmtx(u,order) ; K = K(1:size(u,1),:) ;
g_est = (transpose(K)*K)\(transpose(K)*y) ;

end

function cost = cost_ls(y, u, g)

N= size(u,1) ; yhat = filter(g,1,u) ;
cost = 1/N*sum((y-yhat).^2) ;
end
