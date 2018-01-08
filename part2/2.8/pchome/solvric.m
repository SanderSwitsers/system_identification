% [P,flag,ew]=solvric(Ah,G,Ch,L0)
% solves the ricatti equation :
% P=Ah*P*Ah'+(G-Ah*P*Ch')*inv(L0-Ch*P*Ch')*(G-Ah*P*Ch')'
% ew contains the eigenvalues of the hamiltonian
% flag = 1 if the ricatti equation has no solution (otherwise flag = 0) 
function [P,flag,ew] = solvric(A,G,C,L0)
[n,n]=size(A);
L0i=inv(L0);
AA=[A'-C'*L0i*G' zeros(n,n);-G*L0i*G' eye(n)];
BB=[eye(n) -C'*L0i*C;zeros(n,n) A-G*L0i*C];
[v,d]=eig(AA,BB);
ew=diag(d);
if prod(abs(abs(ew)-ones(2*n,1)) > 1e-9) < 1
	flag = 1;
else 
	flag=0;
end
[dum,I]=sort(abs(ew));
P=real(v(n+1:2*n,I(1:n))/v(1:n,I(1:n)));


