%Y = hankel(1:10,10:19);
function [A, C] = HankToSys(Y)
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
end