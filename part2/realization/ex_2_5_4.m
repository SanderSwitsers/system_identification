W_k = dlmread('data.txt');
W_k = transpose(W_k(3:21,2:4));
W = [W_k;W_k;W_k;W_k;W_k;W_k];
W_p = W(1:9,:);
W_f = W(10:18,:);
r_W_p = rank(W_p)
r_W_f = rank(W_f)
r_W = rank(W)