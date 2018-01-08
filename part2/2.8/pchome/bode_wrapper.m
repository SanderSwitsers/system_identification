function [ mag, phase, freq ] = bode_wrapper( model, opts )
%BODE_WRAPPER Bode plot wrapper
%   Supplied model must be of type idpoly
%
%   opts fields:
%       - normalize: normalizes maximum frequency to 0.5
%       - logscale: plots frequency on a log scale
%       - decibel: plots magnitude as 20*log10(mag)
%       - nvals: discretizes frequency interval in nvals equidistant points
%
%   default: normalize (true), logscale (false), decibel (true)

if nargin < 2
    opts.normalize = true;
    opts.logscale  = false;
    opts.decibel   = true;
end

if isfield(opts,'nvals')
    if isfield(opts,'logscale') && opts.logscale
        [m,p,f] = bode(model, 10.^(linspace(-2,log10(pi/(model.Ts)),opts.nvals)));
    else
        [m,p,f] = bode(model, linspace(0,pi/(model.Ts),opts.nvals));
    end
else
    [m,p,f] = bode(model);
end

% Extract
m = m(:);
p = p(:);
f = f(:);

if isfield(opts,'normalize') && opts.normalize
    f = 0.5*f/(pi/model.Ts);
end

if isfield(opts,'decibel') && opts.decibel
    m = 20*log10(m);
end

if nargout ~= 0
    mag = m;
    phase = p;
    freq = f;
else
    if isfield(opts,'logscale') && opts.logscale
        semilogx(f,m);
        xlim([1e-2 f(end)]);
    else
        plot(f,m);
        xlim([0 f(end)]);
    end
end

end