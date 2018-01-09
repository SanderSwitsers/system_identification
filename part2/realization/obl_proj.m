function result = obl_proj(varargin)
%obl_proj Calculates the projecton of a vector space A, on a vector space C
%along another vector space B
%[result] = obl_proj(A,B,C)
%
%   INPUT:
%   A = vector space to be projected
%   B = vector space along which is projected
%   C = vector space on which is projected
%
%   OUTPUT:
%   result = the projection of A along B on C.
%
%Author: SANDER SWITSERS (r0462339)
%Date: 07/01/2018
%Katholieke Universiteit Leuven

    assert(nargin==3,'incorrect number of input arguments');
    A = varargin{1};
    B = varargin{2};
    C = varargin{3};
    result = pinv([C*transpose(C) C*transpose(B); B*transpose(C) B*transpose(B)]);
    result = result(:,1:size(C,1));
    result = A * [transpose(C) transpose(B)] * result * C;
%    result = A/B*pinv(C/B)*(C/B);
end