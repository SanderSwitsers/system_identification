D = dlmread('data.txt');
W = zeros(18,19);
for i=1:6
   W(3*(i-1)+1,1:19) = D(i:i+18,2)';
   W(3*(i-1)+2,1:19) = D(i:i+18,3)';
   W(3*(i-1)+3,1:19) = D(i:i+18,4)';
end
W_p = W(1:9,:);
W_f = W(10:18,:);
r_W_p = rank(W_p)
r_W_f = rank(W_f)
r_W = rank(W)