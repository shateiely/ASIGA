function g = tu(x)

g = zeros(size(x));
g(x >= 1) = 1;
indices = and(0 < x, x < 1);
x = x(indices);

f1 = exp(-1./x);
f2 = exp(-1./(1-x));
g(indices) = f1./(f1+f2);

return

x = linspace(-1,2,1000);
plot(x,tu(x));
