function [R, dRdxi, dRdeta] = NURBS2DBasis(xi, eta, p, q, Xi, Eta, weights)
error('Depricated. Use NURBSbasis instead')

n = length(Xi) - (p+1);
m = length(Eta) - (q+1);

i1 = findKnotSpan(n, p, xi, Xi);
i2 = findKnotSpan(m, q, eta, Eta);

[N, dNdxi] = Bspline_basis(i1, xi, p, Xi, 1);
[M, dMdeta] = Bspline_basis(i2, eta, q, Eta, 1);

R = zeros(1, (p+1)*(q+1));
dRdxi = zeros(1, (p+1)*(q+1));
dRdeta = zeros(1, (p+1)*(q+1));

W = 0;
dWdxi = 0;
dWdeta = 0;

counter = 1;
for k2 = 1:q+1
    for k1 = 1:p+1    
        weight = weights(counter);

        W       = W       + N(k1)    *M(k2)     *weight;
        dWdxi   = dWdxi   + dNdxi(k1)*M(k2)     *weight;
        dWdeta  = dWdeta  + N(k1)    *dMdeta(k2)*weight;
        counter = counter + 1;
    end
end

counter = 1;
for k2 = 1:q+1
    for k1 = 1:p+1     
        fact = weights(counter)/(W*W);

        NM = N(k1)*M(k2);
        R(counter) = NM*fact*W;

        dRdxi(counter)   = (dNdxi(k1)  *M(k2)*W - NM*dWdxi)*fact;
        dRdeta(counter)  = (dMdeta(k2) *N(k1)*W - NM*dWdeta)*fact;
        counter = counter + 1;
    end
end

