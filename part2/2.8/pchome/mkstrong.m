%[Bs,Ds]=mkstrong(As,Gs,Cs,L0s,Ps)
%makes a strong realization (forward innovation) of the covariance model.
function [Bs,Ds] = mkstrong(As,Gs,Cs,L0s,Ps) 
Qs=Ps-As*Ps*As';
Ss=Gs-As*Ps*Cs';
Rs=L0s-Cs*Ps*Cs';
Bs=Ss*inv(Rs);
Ds=sqrtm(Rs);
Bs=Bs*Ds;
  
