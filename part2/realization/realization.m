Y = hankel(1:10,10:19);
rank(Y)
M = hankel(1:2,2:3);
Ms = hankel(2:3,3:4);
[U, S, V] = svd(M);
sigma = sqrt(S);
sigma = sigma(1:2,1:2);
U_1 = U(1:end,1:2);
V_1 = V(1:end,1:2);
O_2 = U_1*sigma;
