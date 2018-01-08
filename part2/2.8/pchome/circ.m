% circ(m,r,n,type) : plots a circle with radius r, midllepoint m, and n points
function dum = circ(m,r,n,type)
p=r*exp(i*[0:2*pi/n:2*pi]);
plot(m(1)+real(p),m(2)+imag(p),type)
