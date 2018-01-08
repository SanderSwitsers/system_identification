% L=kalm(A,C,Q,R)
% Will calculate the staedy Kalman gain L
%
% Copyright : P. Van Overschee
function L=kalm(A,C,Q,R)
P=dlyap(A,Q);
G=A*P*C';
L0=C*P*C'+R;
P=solvric(A,G,C,L0);
[E,F]=mkstrong(A,G,C,L0,P);
L=E*inv(F);

