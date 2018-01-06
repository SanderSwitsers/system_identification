function [A, B, C] = HankToSys(Y)
%HankToSys converts a hankel matrix into an autonomous system
%
%   INPUT:
%   Y = the hankel matrix for the system
%   OUTPUT:
%   [A B C] = the minimal state respresentation of the system
%       mathcing the hankel matrix
%
%Author: SANDER SWITSERS (r0462339)
%Date: 05-01-2018
%Katholieke Universiteit Leuven

r = rank(Y);
[U, S, V] = svd(Y);
sigma = sqrt(S);
sigma = sigma(1:r,1:r);
U_1 = U(1:end,1:r);
V_1 = V(1:end,1:r);
O = U_1*sigma;
T = sigma*transpose(V_1);
O_k = O(1:end-1,:);
O_ks = O(2:end,:);
A = pinv(O_k) * O_ks;
C = O(1,:);
B = T(:,1);
end