function [svout,w] = sigma(Z1,Z2,Z3,Z4,Z5,Z6)
%SIGMA Singular value frequency response of continuous linear systems.
%	SIGMA(A,B,C,D) (or optional SIGMA(SS_) in RCT) produces a singular 
%       value plot of matrix    -1
%                G(jw) = C(jwI-A) B + D 
%	as a function of frequency.  The singular values are an extension
%	of Bode magnitude response for MIMO systems.  The frequency range
%	and number of points are chosen automatically.  For square systems, 
%       SIGMA(A,B,C,D,'inv') produces the singular values of the inverse 
%       matrix     -1               -1      -1
%                 G (jw) = [ C(jwI-A) B + D ]
%
%	SIGMA(A,B,C,D,W) or SIGMA(A,B,C,D,W,'inv') uses the user-supplied
%	frequency vector W which must contain the frequencies, in 
%	radians/sec, at which the singular value response is to be 
%	evaluated. When invoked with left hand arguments,
%	    [SV,W] = SIGMA(A,B,C,D,...)
%	or  [SV,W] = SIGMA(SS_,...)      (for Robust Control Toolbox user)
%	returns the frequency vector W and the matrix SV with as many 
%	columns	as MIN(NU,NY) and length(W) rows, where NU is the number
%	of inputs and NY is the number of outputs.  No plot is drawn on 
%	the screen.  The singular values are returned in descending order.
%
%	See also: LOGSPACE,SEMILOGX,NICHOLS,NYQUIST and BODE.

%	Andrew Grace  7-10-90
%	Revised ACWG 6-21-92
%	Revised by Richard Chiang 5-20-92
%	Revised by W.Wang 7-20-92
%	copyright (c) 1990-92 by the MathWorks, Inc.


if nargin==0, eval('exresp(''sigma'',1)'), return, end

if exist('mkargs') == 2, %If RCT installed
  inargs='(a,b,c,d,w,invflag)';
  eval('mkargs(inargs,nargin,ss)')
else
   if nargin<4,
     error('Too few input arguments')
   else
     a=Z1; b=Z2; c=Z3; d=Z4;
     if nargin > 5
       invflag = Z6;
     elseif nargin > 4,
       w=Z5;
     end;
   end;
end;

if nargin==6,      % Trap call to RCT function
  if ~isstr(invflag),
    eval('svout = sigma2(a,b,c,d,w,invflag);')
    return
  end
  if ~length(invflag)
	nargin = nargin - 1;
  end
end

error(nargchk(4,6,nargin));
error(abcdchk(a,b,c,d));

% Detect null systems
if ~(length(d) | (length(b) &  length(c)))
       return;
end

% Determine status of invflag
if nargin==4, 
  invflag = [];
  w = [];
elseif (nargin==5)
  if (isstr(w)),
    invflag = w;
    w = [];
    [ny,nu] = size(d);
    if (ny~=nu), error('The state space system must be square when using ''inv''.'); end
  else
    invflag = [];
  end
else
  [ny,nu] = size(d);
    if (ny~=nu), error('The state space system must be square when using ''inv''.'); end
end

% Generate frequency range if one is not specified.

% If frequency vector supplied then use Auto-selection algorithm
% Fifth argument determines precision of the plot.
if ~length(w)
  w=freqint(a,b,c,d,30);
end

[nx,na] = size(a);
[no,ns] = size(c);
nw = max(size(w));

% Balance A
[t,a] = balance(a);
b = t \ b;
c = c * t;

% Reduce A to Hessenberg form:
[p,a] = hess(a);

% Apply similarity transformations from Hessenberg
% reduction to B and C:
b = p' * b;
c = c * p;

s = w * sqrt(-1);
I=eye(length(a));
if nx > 0,
  for i=1:length(s)
    if isempty(invflag),
      sv(:,i)=svd(c*((s(i)*I-a)\b) + d);
    else
      sv(:,i)=svd(inv(c*((s(i)*I-a)\b) + d));
    end
  end
else
  for i=1:length(s)
    if isempty(invflag),
      sv(:,i)=svd(d);
    else
      sv(:,i)=svd(inv(d));
    end
  end
end
  
% If no left hand arguments then plot graph.
if nargout==0
  semilogx(w, 20*log10(sv), [w(1), w(length(w))], [0, 0],'w:')
  xlabel('Frequency (rad/sec)')
  ylabel('Singular Values dB')
  return % Suppress output
end
svout = sv; 
