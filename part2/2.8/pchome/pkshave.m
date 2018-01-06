%
% Peak shaving utility
%
% y_out=pkshave(y,level,show_plot)
%
% level is a 2 element vector with:
%
%	level=[lower level,higher level]
%
% show_plot (optional) will display the intermediate results when
% equal to 1(defaults to 0).
%
% Copyright	Peter Van Overschee
%		January 4, 1994
% Revised	Jeroen Buijs
%		April 5, 2000
%
% Feel free to copy and alter

function y_out=pkshave(y,level,show_plot)

if nargin < 3;show_plot=0;end

N=length(y);
smin=level(1);smax=level(2);
ax=[1:N];

% Possible plotting
if show_plot
  hold off;subplot;subplot(221)
  plot(ax,y,[1,N],[smax,smax],'-.',[1,N],[smin,smin],'-.')
  title('Original + clipping levels')
end

%%%% clip
fcl=((smin < y) & (smax > y)) + (y >= smax).*(smax*ones(N,1)./y) + ...
	(y <= smin).*(smin*ones(N,1)./y);
y1=fcl.*y;

% Possible plotting
if show_plot
  subplot(222);plot(y1)
  title('Clipped Signal')
end

%%%% detrend
[bf,af]=butter(4,0.05);
y2=filtfilt(bf,af,y1);

% Possible plotting
% plot(ax,y1,'--',ax,y2,'-')


%%%% standard deviation
sig=std(y1-y2);
% Take 2 sigma:
fac=2;
up=y2+fac*sig*ones(N,1);
low=y2-fac*sig*ones(N,1);

% Possible plotting
if show_plot
  subplot(223);plot(ax,y,ax,up,'--',ax,low,'--')
  title('Upper and lower bound')
end

%%%% interpolation
iok=((up-y) > 0) & ((y-low) > 0);
inok=ones(N,1)-iok;
% next two lines added on April 5, 2000
ioknz = find(iok);
inoknz = find(inok);
axok=ax(ioknz);axnok=ax(inoknz);
sok=y(ioknz);
snok=spline(axok,sok,axnok);
y_out=y;y_out(inoknz)=snok;

% Possible plotting
if show_plot
  subplot(224);plot(ax,y_out);
  title('Peak shaved signal');
end
