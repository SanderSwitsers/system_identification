function H=Hankel(h,nr,nc);
Nout=size(h,1);
H=zeros(nr*Nout,nc);
for n=1:nr
  H((n-1)*Nout+1:n*Nout,:)=[h(:,(n-1)+1:nc+n-1)];
end;
