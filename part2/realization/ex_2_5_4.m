Data = dlmread('data.txt');
W = zeros(18,19);
for i=1:6
   W(3*(i-1)+1,1:19) = Data(i:i+18,2)';
   W(3*(i-1)+2,1:19) = Data(i:i+18,3)';
   W(3*(i-1)+3,1:19) = Data(i:i+18,4)';
end
W_p = W(1:9,:);
W_f = W(10:18,:);
r_W_p = rank(W_p)
r_W_f = rank(W_f)
r_W = rank(W)

%finding a, b and x
U = transpose(W_p);
V = transpose(W_f);
T = null([U V]);

a = T(1:9,1)
b = T(10:18,1)
x = transpose(transpose(a)*W_p)

% input-output subspace realization
Y = W(3:3:18,:);
U = W;
U(3:3:18,:) = [];
Y_f = Y(4:6,:);
Y_fm = Y(5:6,:);
U_f = U(7:12,:);
U_fm = U(9:12,:);
U_ii = U(7:8,:);
Y_ii = Y(4,:);
W_pp = W(1:12,:);
W_1 = eye(3);
%W_2 = eye(size(U_f,2)) - transpose(U_f) * pinv(U_f*transpose(U_f)) * U_f;
W_2 = eye(size(U_f,2));

O_i = obl_proj(Y_f, U_f, W_p);
O_im = obl_proj(Y_fm, U_fm, W_pp);

%[U_svd, S, V] = svd(W_1 * O_i * W_2);
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
n = 1;
m = 2;
l = 1;

A = sol(1:n,1:n)
B = sol(1:n,n+1:n+m)
C = sol(n+1:n+l,1:n)
D = sol(n+1:n+l,n+1:n+m)

