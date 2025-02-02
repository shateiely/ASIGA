function I = radialIntegral3(n, varrho1, varrho2, infiniteElementFormulation, type)

switch infiniteElementFormulation
    case {'PGC', 'BGC', 'WBGC'}
        if type == 1
%             I = integral(1/rho^n) from 1 to infinity
            I = 1/(n-1);
        elseif type == 2
%             I = integral(1/(rho^(n-1)*(rho^2-varrho^2)) from 1 to infinity
            if varrho1 == 0
                I = 1/n;
            else
%                 I = hypergeom([1, n/2], (n+2)/2, varrho^2)/n; %equivalent
                I = 0;
                I_j = inf;
                j = 0;
                pFact = 1;
                varrho1Squared = varrho1^2;
                while abs(I_j/I) > eps
                    I_j = pFact/(2*j+n);
                    I = I + I_j;
                    j = j + 1;
                    pFact = pFact*varrho1Squared;
                end
            end
        end
    case {'PGU', 'BGU', 'WBGU'}
        z = -2*1i*varrho2;
        if type == 1
%             I = integral(exp(-z*r)/r^n) from 1 to infinity
            I = expint_n(z,n);
        elseif type == 2
%               I = integral(exp(-z*rho)/(rho^(n-1)*(rho^2-varrho^2)) from 1 to infinity
            if varrho1 == 0
                I = expint_n(z,n+1);
            else
                if abs(z) > 0.001 % This seems to work better than series also for small z
                    I = 0;
                    I_j = inf;
                    j = 0;
                    varrho1Squared = varrho1^2;
                    pFact = 1;
                    while abs(I_j/I) > eps
                        I_j = pFact*expint_n(z,2*j+n+1);
                        I = I + I_j;
                        j = j + 1;
                        pFact = pFact*varrho1Squared;
                    end
                else
                    gamma = 0.5772156649015328606065120900824;
                    I = -1/(2*varrho1^n)*(exp(-varrho1*z)*(log((1-varrho1)*z)+gamma) + (-1)^n*exp(varrho1*z)*(log((1+varrho1)*z)+gamma));
                    m = 0;
                    pFact = 1;
                    term = inf;
                    lnz = log(z);
                    while abs(term/I) > eps
                        D_m = 0;
                        for j = 0:floor(n/2)-1
                            if m == n-2*j-2
                                temp2 = lnz + gamma - sum(1./(1:m));
                            else
                                temp2 = 1/(m-n+2*j+2);
                            end
                            D_m = D_m + 1/varrho1^(2*(j+1))*temp2;
                        end
                        if m ~= 0
                            C_m = -(exp(-varrho1*z)*(1-varrho1)^m+(-1)^n*exp(varrho1*z)*(1+varrho1)^m)/(2*m*varrho1^n);
                        else
                            C_m = 0;
                        end
                        term = pFact*(C_m+D_m);
                        I = I + term;
                        m = m + 1;
                        pFact = -z*pFact/m;
                    end
                end
            end
        end
end
