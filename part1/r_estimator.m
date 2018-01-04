function varargout = r_estimator(varargin)
%R_ESTIMATE Calculates an estimator for R in the eq u=R*i
%r_estimate = r_estimator(sample_u, sample_i, method_name, parameters)
%
%   INPUT:
%   sample_u = samples of the tension u
%   sample_i = samples of the current i
%   method_name = choice between 3 methods
%       'ls' Least Square
%           Parameters:
%               none
%       'iv' Instumental Variables
%           Parameters:
%               s = shift parameter
%       'eiv' Errors-In-Variable
%           Parameters:
%               sigma_nu = standard deviation of the tension noise
%               sigma_ni = standard deviation of the current noise
%   OUTPUT:
%   r_estimate = estimation of R
%
%Author: HENRI DE PLAEN (r0681349)
%Date: 12-08-2017
%Katholieke Universiteit Leuven

sample_u = varargin{1} ; sample_i = varargin{2} ;
sample_u = sample_u(:) ; sample_i = sample_i(:) ;
assert( size(sample_u,1) == size(sample_i,1), 'The samples must have the same size') ;

switch varargin{3}
    case 'iv'
        assert(nargin==4, 'Method iv: parameters not correct') ;
        varargout{1} = iv_r(sample_u, sample_i, varargin{4}) ;
    case 'eiv'
        assert(nargin==5, 'Method eiv: parameters not correct') ;
        varargout{1} = eiv_r(sample_u, sample_i, varargin{4}, varargin{5}) ;
    case 'ls'
        assert(nargin==3, 'Method ls: parameters not correct') ;
        varargout{1} = iv_r(sample_u, sample_i, 0) ;
    otherwise, error('Unkwnown method name') ;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function r_estimate = iv_r(sample_u, sample_i, s)

assert(isscalar(s) && s>=0, 's has to be a positive scalar') ;

u_k  = sample_u(1:end-s) ;
i_ks = sample_i(1+s:end) ;
i_k  = sample_i(1:end-s) ;

num = sum(u_k.*i_ks) ; denom = sum(i_k.*i_ks) ;
r_estimate = num/denom ;

end

function r_estimate = eiv_r(sample_u, sample_i, sigma_nu, sigma_ni )

assert(isscalar(sigma_nu) && isscalar(sigma_ni), 'sigma has to be a scalar') ;

r_estimate = ( sum(sample_u.^2)/sigma_nu^2 - sum(sample_i.^2)/sigma_ni^2 + ...
    sqrt( (sum(sample_u.^2)/sigma_nu^2 - sum(sample_i.^2)/sigma_ni^2)^2 + ...
    4*sum(sample_u.*sample_i)^2/sigma_nu^2/sigma_ni^2 ) ) / ...
    ( 2*sum(sample_u.*sample_i)/sigma_nu^2 ) ;
end
