function [A,B,C,D] = deter_sys(y,u,i,n)
%deter_sys calculates the state space matrices of a system using
%deterministic subspace identification
%
%   INPUT:
%       y: matrix of measured outputs
%       u: matrix of measured inputs
%       i: number of block rows in Hankel matrices 
% 
%   OUTPUT:
%       A,B,C,D: deterministic state space system
%              x_{k+1) = A x_k + B u_k        
%                y_k   = C x_k + D u_k
%
%Author: SANDER SWITSERS (r0462339)
%Date: 09/01/2018
%Katholieke Universiteit Leuven

[l, k] = size(y);
m = size(u,1);

%setup matrices
Y = zeros(i*l,k-2*i+1);
U = zeros(i*m,k-2*i+1);
for it = 1:2*i
    Y((it-1)*l+1:it*l,:) =  y(:,it:it+k-2*i);
    U((it-1)*m+1:it*m,:) =  u(:,it:it+k-2*i);
end
W = [U ; Y];
Y_f = Y((i+1)*l:end,:);
Y_fm = Y((i+2)*l:6,:);
Y_ii = Y(i*l+1:(i+1)*l,:);
U_f = U(i*m+1:end,:);
U_fm = U((i+1)*m+1:end,:);
U_ii = U(i*m+1:(i+1)*m,:);
W_p = [U(1:i*m,: ) ; Y(1:i*l,:)];
W_pp = [U(1:(i+1)*m,: ) ; Y(1:(i+1)*l,:)];

O_i = obl_proj(Y_f, U_f, W_p);
O_im = obl_proj(Y_fm, U_fm, W_pp);

[U_svd, S, V] = svd(O_i);
r = rank(S,1e-8);
S_1 = S(1:r,1:r);
U_1 = U_svd(:,1:r);

Gamma =  U_1 * sqrt(S_1);
Gamma_m = Gamma(1:end-1,:);

X_i = pinv(Gamma)*O_i;
X_ip = pinv(Gamma_m)*O_im;

Rhs = [       X_i   ;  U_ii]; 
Lhs = [      X_ip   ;  Y_ii]; 

sol = Lhs/Rhs;

A = sol(1:n,1:n);
B = sol(1:n,n+1:n+m);
C = sol(n+1:n+l,1:n);
D = sol(n+1:n+l,n+1:n+m);