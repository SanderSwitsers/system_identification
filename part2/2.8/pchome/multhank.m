 %
% This function will calculate a multivariable Hankel matrix of a two
% output system 
%
% H = multhank(h1,h2,start_index,p,q) 
%
% Inputs: 
%
%   h1 : a N by 2 matrix containing the impulse responses 
%        from the first input to both outputs (from dimpulse).
%   h2 : a N by 2 matrix containing the impulse responses 
%        from the second input to both outputs (from dimpulse).
%   start_index : the index (row number) in h1 (and h2) 
%                 of the first element in the Hankel matrix H (the top 
%                 left element of H)
%   p,q : the number of block rows respectively block columns
%
% Copyright 	Peter Van Overschee
%		January 5, 1995
%
%		Feel free to copy and alter
%

function H=multhank(h1,h2,start_index,p,q)

[N1,du]=size(h1);
if du ~= 2
  error('h1 needs two columns');
end
[N2,du]=size(h2);
if du ~= 2
  error('h2 needs two columns');
end
if N1 ~= N2
  error('h1 and h2 should contain the same namber of rows');
end
N=N1;
if N < start_index+p+q-2
  error('Not enough impulse response samples');
end

% Initialize H
H=zeros(2*p,2*q);

% From the matrix
for kr = 1:p
  for kc = 1:q
    H(2*(kr-1)+1,2*(kc-1)+1) = h1(start_index+kr+kc-2,1);
    H(2*(kr-1)+2,2*(kc-1)+1) = h1(start_index+kr+kc-2,2);
    H(2*(kr-1)+1,2*(kc-1)+2) = h2(start_index+kr+kc-2,1);
    H(2*(kr-1)+2,2*(kc-1)+2) = h2(start_index+kr+kc-2,2);    
  end
end
