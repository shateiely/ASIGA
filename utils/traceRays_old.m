function varCol = traceRays_old(varCol)

d_inc = varCol.d_vec.';
O = zeros(size(varCol.o,1),3,2);

objectHit = zeros(size(varCol.o,1),1,'logical');

N = size(varCol.o,1);
O(:,:,1) = varCol.o;

p_inc = varCol.p_inc;
Eps = 1e-13;
d = zeros(N,3);
% plotRays = 1;

for n = 1:size(O,1)
% parfor n = 1:size(O,1)
    Otemp = O(n,:,:);
    o = Otemp(1,:,1);
    if false
        do = dot(d_inc,o);
        discriminant = do^2-norm(o)^2+R^2;
        if discriminant >= 0
            s = -do - sqrt(discriminant);
            x_n = o + d_inc*s;

            n_vec = x_n;
            d(n,:) = d_inc-2*dot(d_inc,n_vec)*n_vec; % reflected ray

            O(n,:,2) = x_n;

    %         normals(n,:) = n_vec;
    %         O(n,:,3) = O(n,:,2) + 1.1*r;
            objectHit(n) = true;
    %         if plotRays
    %             hold on
    %             x = O(n,1,1:2);
    %             y = O(n,2,1:2);
    %             z = O(n,3,1:2);
    %             plot3(x(:),y(:),z(:),'black')
    %             x = [varCol.o(n,1); reshape(O(n,1,2:end),size(O,3)-1,1)];
    %             y = [varCol.o(n,2); reshape(O(n,2,2:end),size(O,3)-1,1)];
    %             z = [varCol.o(n,3); reshape(O(n,3,2:end),size(O,3)-1,1)];
    %             plot3(x(:),y(:),z(:),'black')
    %         end
        end
    else
        

%         normals(n,:) = n_vec;
%         O(n,:,3) = O(n,:,2) + 1.1*r;
        [O,d] = reflectM3(O,d,o,i,Q);
        objectHit(n) = true;
%             if plotRays
%                 hold on
%                 x = O(n,1,1:2);
%                 y = O(n,2,1:2);
%                 z = O(n,3,1:2);
%                 plot3(x(:),y(:),z(:),'black')
%                 x = [O(n,1,2); x_n(1)+3*d(n,1)];
%                 y = [O(n,2,2); x_n(2)+3*d(n,2)];
%                 z = [O(n,3,2); x_n(3)+3*d(n,3)];
%                 plot3(x(:),y(:),z(:),'red')
%                 keyboard
%             end
    end
end

% if plotRays
%     axis equal
%     [X,Y,Z] = sphere(1000);
% %     surf(R2*X,R2*Y,R2*Z, 'FaceColor', 1.5*[44 77 32]/255,'LineStyle','none')
% %     axis off
%     camlight
%     keyboard
% end

temp = zeros(N,1);
temp(objectHit) = 1:sum(objectHit);

beams = varCol.beams;
beams = reshape(temp(beams(:)),size(beams,1),size(beams,2));
beams(any(~beams,2),:) = [];

varCol.O = O(objectHit,:,:);
varCol.o = varCol.o(objectHit,:);
varCol.d = d(objectHit,:);
dofs = size(varCol.O,1);
varCol.dofs = dofs;
varCol.beams = beams;
% varCol.A = p_inc(O(objectHit,:,end-1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% close all
% XX = varCol.o;
% XX2 = varCol.O(:,1:3,1);
% d_vec = varCol.d_vec;
% XX_m = orthogonalTransform(XX, d_vec);
% XX2_m = orthogonalTransform(XX2, d_vec);
% YY_m = XX_m(:,2);
% XX_m = XX_m(:,1);
% YY2_m = XX2_m(:,2);
% XX2_m = XX2_m(:,1);
%    
% oXX_m = varCol.oXX_m;
% oYY_m = varCol.oYY_m;
% X_m = varCol.X_m;
% convexHull = varCol.convexHull;
% close all
% figure(1)
% hold on
% axis equal
% t = linspace(0,2*pi,10000);
% plot(cos(t),sin(t))
% plot(oXX_m,oYY_m,'*','color','cyan')
% plot(XX_m,YY_m,'*','color','blue')
% plot(XX2_m,YY2_m,'*','color','green')
% plot(X_m(convexHull,1),X_m(convexHull,2),'*-','color','red')
% % for i = 1:size(XX2_m,1)
% %     text(XX2_m(i),YY2_m(i),num2str(i))
% % end
% % for i = 1:size(beams,1)
% %     indices = beams(i,:);
% %     h = plot(XX2_m(indices([2,3,4,5,6,7,2])),YY2_m(indices([2,3,4,5,6,7,2])),'r');
% %     pause(0.5)
% %     set(h,'Visible','off')
% % end     
% keyboard


function [O,d] = reflectM3(O,d,o,i,Q)

if i <= Q && any(isnan(O(1,:,i-1)))
    L = 41;
    R1 = 5;
    R2 = 3;
    x0 = L*R2/(R1-R2);

    do = dot(d,o);
    s = zeros(1,3);
    discriminant = do^2-norm(o)^2+R2^2;
    stemp = -do - sqrt(discriminant);
    x_n = o + d*stemp;
    if discriminant >= 0 && x_n(1) >= -Eps
        s(1) = stemp;
    else
        s(1) = inf;
    end
    a = 1;
    b = 2*d(1)*L+2*do;
    c = norm(o)^2 + 2*o(1)*L+L^2-R1^2;

    discriminant = b^2-4*a*c;
    stemp = (-b-sqrt(discriminant))/(2*a);
    x_n = o + d*stemp;
    if discriminant >= 0 && x_n(1)+L <= Eps
        s(2) = stemp;
    else
        s(2) = inf;
    end
    mu = (R2/x0)^2;
    a = d(2)^2+d(3)^2-mu*d(1)^2;
    b = 2*o(3)*d(3)+2*o(2)*d(2)-2*mu*o(1)*d(1)+2*d(1)*x0*mu;
    c = o(2)^2+o(3)^2 - mu*o(1)^2 + 2*mu*o(1)*x0 - mu*x0^2;

    discriminant = b^2-4*a*c;
    stemp = (-b-sqrt(discriminant))/(2*a);
    x_n = o + d*stemp;
    if discriminant >= 0 && x_n(1) < 0 && x_n(1) > -L
        s(3) = stemp;
    else
        s(3) = inf;
    end
    if any(~isinf(s))
        [mins,I] = min(s);
        x_n = o + d_inc*mins;

        switch I
            case 1
                n_vec = x_n/norm(x_n);
            case 2
                n_vec = (x_n+[L,0,0]);
                n_vec = n_vec/norm(n_vec);
            case 3
                theta = atan2(x_n(2),x_n(3));
                n_vec = [1,sin(theta)/sqrt(mu),cos(theta)/sqrt(mu)];
                n_vec = n_vec/norm(n_vec);
        end
        d(1,:,i+1) = d_inc-2*dot(d_inc,n_vec)*n_vec; % reflected ray

        O(1,:,i+1) = [o; x_n].';
        [O,d] = reflectM3(O,d,o,i,Q);
        [O,d] = reflectM3(O,d,o,i,Q);
    end
end