function [nurbs, nurbs2, nurbs3, nurbs4, nurbs5] = getBCDataParts2(a, b, l, g2, g3, alpha, beta, s, c)
h = g2*tan(alpha/2); % = g2/tan((pi-alpha)/2)

x1 = tan(alpha/2)*(g2/tan(alpha) + h);
x2 = g3*tan(alpha);

lowerCpts = [  -l-g2-g3,    0,  0,          1; % 0
               -l-g2-g3,    0, (-b+h+x2)/2, 1;
               -l-g2-g3,    0, -b+h+x2,     1; % 1
               -l-g2-g3/2,  0, -b+h+x2/2,   1;
               -l-g2,       0, -b+h,        1; % 2
               -l-x1,       0, -b,          cos(alpha/2);
               -l,          0, -b,          1; % 3
               -l/2,        0, -b,          1;
                0,          0, -b,          1; % 4
                a,          0, -b,          1/sqrt(2);
                a,          0,  0,          1];% 5
            
righ_sCpts1 = lowerCpts;
righ_sCpts1(:,2) = abs(lowerCpts(:,3))/tan(pi/2-beta/4);
righ_sCpts1(:,4) = righ_sCpts1(:,4)*cos(beta/4);


R_x = rotationXaxis(beta/2);

righ_sCpts2 = lowerCpts;
righ_sCpts2(:,1:3) = (R_x*righ_sCpts2(:,1:3).').';

coeffs = zeros(4,3,11);
coeffs(:,1,:) = lowerCpts.';
coeffs(:,2,:) = righ_sCpts1.';
coeffs(:,3,:) = righ_sCpts2.';

Xi = [0 0 0 1 1 1];
Eta = [0 0 0 1 1 2 2 3 3 4 4 5 5 5]/5;

nurbs_lower = createNURBSobject(coeffs,{Xi, Eta});
nurbs_lower = insertKnotsInNURBS(nurbs_lower,{[] 0.5});

%% Create back top
t1 = 120*pi/180;
p2 = t1/12;

w2 = cos(p2/2);
w3 = cos(2*p2/2);
cptsCircle = zeros(23,3);

p1 = t1-pi/2;
cptsCircle(1:12,:) = [cos(p1),  sin(p1),    1;
                      NaN,      NaN,        w2;
                      cos(p1+p2),  sin(p1+p2),    1;
                      NaN,      NaN,        w2;
                      cos(p1+2*p2),  sin(p1+2*p2),    1;
                      NaN,      NaN,        w2;
                      cos(p1+3*p2),  sin(p1+3*p2),    1;
                      NaN,      NaN,        w2;
                      cos(p1+4*p2),  sin(p1+4*p2),    1;
                      NaN,      NaN,        w2;
                      cos(p1+5*p2),  sin(p1+5*p2),    1;
                      NaN,      NaN,        w3];
cptsCircle(13:end,:) = flipud(cptsCircle(1:11,:));
cptsCircle(13:end,1) = -cptsCircle(13:end,1);
for i = 1:11
    y1 = cptsCircle(2*i-1,1);
    z1 = cptsCircle(2*i-1,2);
    y2 = cptsCircle(2*i+1,1);
    z2 = cptsCircle(2*i+1,2);
    detrm = y1*z2-y2*z1;
    y3 = -z2^2*z1+(y1^2+z1^2)*z2-y2^2*z1;
    z3 = -y2*y1^2+(y2^2+z2^2)*y1-y2*z1^2;
    cptsCircle(2*i,1:2) = [y3,z3]/detrm;
end

coeffs_backTop = zeros(4,23,5);
for i = 1:5
    coeffs_backTop(2:4,:,i) = cptsCircle.';
end
coeffs_backTop(2:3,:,1) = 0;
coeffs_backTop(2:3,:,2) = coeffs_backTop(2:3,:,2)*abs(-b+h+x2)/2;
coeffs_backTop(2:3,:,3) = coeffs_backTop(2:3,:,3)*abs(-b+h+x2);
coeffs_backTop(2:3,:,4) = coeffs_backTop(2:3,:,4)*abs(-b+h+x2/2);
coeffs_backTop(2:3,:,5) = coeffs_backTop(2:3,:,5)*abs(-b+h);

coeffs_backTop(1,:,1:3) = -l-g2-g3;
coeffs_backTop(1,:,4) = -l-g2-g3/2;
coeffs_backTop(1,:,5) = -l-g2;

%% Upper main body
C_4 = c + b*cos(beta/2);
C_3 = b*sin(beta/2)-s;
C_2 = (2*C_4+C_3*tan(beta/2))/C_3^3;
C_1 = -(3*C_4+C_3*tan(beta/2))/C_3^2;

P = @(y) c + C_1*(y-s).^2 + C_2*(y-s).^3;

npts = 6;
dy = C_3/(npts-1);

coeffs_mainTop = zeros(4,23,5);

y = s + (npts-1)*dy;
for i = 1:npts
    line = zeros(5,4);
    line(1,:)   = [-l,   y, P(y), 1];
    line(2,:)   = [-l/2, y, P(y), 1];
    line(3:5,:) = [0,    y, P(y), 1;
                   a,    y, P(y), 1/sqrt(2);
                   a,    0,   0 , 1];
    coeffs_mainTop(:,2*i-1,:) = line.';
    y = y - dy;
end

coeffs_mainTop(:,2*npts+1:end,:) = coeffs_mainTop(:,2*npts-1:-1:1,:);
coeffs_mainTop(2,2*npts+1:end,:) = -coeffs_mainTop(2,2*npts+1:end,:);

t1 = 120*pi/180;
p2 = t1/12;
w2 = cos(p2/2);
w3 = cos(2*p2/2);
for i = 1:11
    coeffs_mainTop(1:3,2*i,:) = (coeffs_mainTop(1:3,2*i-1,:)+coeffs_mainTop(1:3,2*i+1,:))/2;
    if i == 6
        coeffs_mainTop(4,2*i,[1,2,3,5]) = w3;
        coeffs_mainTop(4,2*i,4) = w3/sqrt(2);
    else
        coeffs_mainTop(4,2*i,[1,2,3,5]) = w2;
        coeffs_mainTop(4,2*i,4) = w2/sqrt(2);
    end
end
hyp = norm(coeffs_mainTop(1:3,1,1)-coeffs_mainTop(1:3,3,1));



%% Create transition and combine into upper main body
coeffs_top = zeros(4,23,12);
coeffs_top(:,:,1:5) = coeffs_backTop;
coeffs_top(:,:,8:end) = coeffs_mainTop;

for i = 1:2*npts
    idx = 2*npts-i+1;
    pts = zeros(2,4);
    pts(2,:) = coeffs_top(:,idx,8);
    pts(2,1) = nurbs_lower.coeffs(1,1,7);
    
    v1 = coeffs_top(1:3,idx,4);
    v2 = coeffs_top(1:3,idx,5);
    
    g4 = nurbs_lower.coeffs(1,1,6)-nurbs_lower.coeffs(1,1,5);
    
    pts(1,1:3) = (v2-v1)/norm(v2-v1)*g4/cos(alpha)+v2;
    pts(1,4) = coeffs_top(4,idx,5);
    coeffs_top(:,idx,6:7) = pts.';
end
coeffs_top(4,1,6:7) = 0.5*(1+cos(alpha/2));
coeffs_top(:,13:end,6:7) = coeffs_top(:,11:-1:1,6:7);
coeffs_top(2,13:end,6:7) = -coeffs_top(2,13:end,6:7);

%% Combine all coefficients
coeffs = zeros(4,27,12);
coeffs(:,1:2,:) = nurbs_lower.coeffs(:,1:2,:);
coeffs(:,3:25,:) = coeffs_top;
coeffs(:,26:27,:) = nurbs_lower.coeffs(:,2:-1:1,:);
coeffs(2,26:27,:) = -coeffs(2,26:27,:);


%% Xi knot vector based on the arclength of the rotationally summetric back of submarine
Xi = zeros(1,30);
Xi(28:30) = 1;
Xi(26:27) = 2/3;
Xi(4:5) = 1/3;
for i = 1:5
    Xi(6+2*(i-1):7+2*(i-1)) = 1/3 + i/3/12;
    Xi(24-2*(i-1):25-2*(i-1)) = 2/3 - i/3/12;
end

%% Create complete nurbs surface parametrization
Xi = [0 0 0 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10 11 11 11]/11;
Eta = [0 0 0 1 2 2 2]/2;
nurbs = createNURBSobject(coeffs(:,3:end-2,5:8),{Xi, Eta});
Eta = [0 0 0 2 2 2]/2;
nurbs2 = createNURBSobject(coeffs(:,3:end-2,end-2:end),{Xi, Eta});

Eta = [0 0 0 1 1 2 2 2]/2;
nurbs3 = createNURBSobject(coeffs(:,3:end-2,1:5),{Xi, Eta});

Xi = [0 0 0 1 1 1];
Eta = [0 0 0 1 1 2 2 2]/2;
nurbs4 = createNURBSobject(coeffs(:,1:3,1:5),{Xi, Eta});
nurbs5 = createNURBSobject(coeffs(:,end-2:end,1:5),{Xi, Eta});



function R_x = rotationXaxis(alpha)

R_x = [1, 0,           0;
       0, cos(alpha), -sin(alpha);
       0, sin(alpha),  cos(alpha)];
