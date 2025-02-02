function h = plotNURBSinfElement2(nurbs, resolution, plotElementEdges, color, alphaValue,c_xy,c_z,x_0)
error('Depricated')
if nargin < 3
    plotElementEdges = true;
end
if nargin < 4
    % Plots the surface of a NURBS volume
    % colors = colormap('summer');
    color = getColor(1); % colors(end,:);
    mycolor = [33 76 161]/255;
end
if nargin < 5
    alphaValue = 1;
end
% color = [33 76 161]/255; %214CA1
lineColor = 'black';

A_2 = [0 1 0;
       0 0 1;
       1 0 0];
unique_xiKnots = unique(nurbs.knots{1});
unique_etaKnots = unique(nurbs.knots{2});

% To reconstruct any interpolatory points, any p repeated knot should be
% included in the abscissa values to plot
% Xi_values = insertUniform3(nurbs.knots{1}, resolution(1), nurbs.degree(1));
% Eta_values = insertUniform3(nurbs.knots{2}, resolution(2), nurbs.degree(2));
%     %% Plot surface where zeta = 1
% X = zeros(length(Xi_values), length(Eta_values));
% Y = zeros(length(Xi_values), length(Eta_values));
% Z = zeros(length(Xi_values), length(Eta_values));
% for i = 1:length(Xi_values)
%     for j = 1:length(Eta_values)
%         xi = Xi_values(i);
%         eta = Eta_values(j);
%         v = evaluateNURBS(nurbs, [xi eta]);
%         X(i,j) = v(1);
%         Y(i,j) = v(2);
%         Z(i,j) = v(3);
%     end
% end
% if plotElementEdges
%     if alphaValue < 1
%         surf(Z,X,Y, 'FaceColor', color,'EdgeColor','none','LineStyle','none','FaceAlpha',alphaValue, 'FaceLighting', 'none')
%     else
%         surf(Z,X,Y, 'FaceColor', color,'EdgeColor','none','LineStyle','none','FaceAlpha',alphaValue)
%     end
% else
%     surf(Z,X,Y, 'FaceColor', color)
% end
% hold on
% 
% if plotElementEdges        
%     x = zeros(length(Xi_values),1);
%     y = zeros(length(Xi_values),1);
%     z = zeros(length(Xi_values),1);
% 
%     for j = 1:length(unique_etaKnots)
%         eta = unique_etaKnots(j);
%         for i = 1:length(Xi_values)
%             xi = Xi_values(i);
%             v = evaluateNURBS(nurbs, [xi eta]);
%             x(i) = v(1);
%             y(i) = v(2);
%             z(i) = v(3);
%         end
%         plot3(z,x,y,'color',lineColor)
%     end
% 
%     x = zeros(length(Eta_values),1);
%     y = zeros(length(Eta_values),1);
%     z = zeros(length(Eta_values),1);
%     for i = 1:length(unique_xiKnots)
%         xi = unique_xiKnots(i);
%         for j = 1:length(Eta_values)
%             eta = Eta_values(j);
%             v = evaluateNURBS(nurbs, [xi eta]);
%             x(j) = v(1);
%             y(j) = v(2);
%             z(j) = v(3);
%         end
%         plot3(z,x,y,'color',lineColor)
%     end
% end
hold on
Ups = sqrt(c_z^2-c_xy^2);
[R_a, ~, ~] = evaluateProlateCoords(c_xy,0,0,Ups);
xi_start = unique_xiKnots(6);
xi_end = unique_xiKnots(7);
eta_start = unique_etaKnots(length(unique_etaKnots)-3);
eta_end = unique_etaKnots(length(unique_etaKnots)-2);

xi_arr = [xi_start xi_end];
eta_arr = [eta_start eta_end];

theta_arr = zeros(4,1);
phi_arr = zeros(4,1);
r_arr = zeros(4,1);
counter = 1;

for i = 1:2
    xi = xi_arr(i);
    for j = 1:2
        eta = eta_arr(j);
        v = evaluateNURBS(nurbs, [xi eta]);
        
        Xt = A_2*(v-x_0);
        xt = Xt(1);
        yt = Xt(2);
        zt = Xt(3);
        [r, theta, phi] = evaluateProlateCoords(xt,yt,zt,Ups);
        r_arr(counter) = r;
        theta_arr(counter) = theta;
        phi_arr(counter) = phi;
        counter = counter + 1;
    end
end
        
for i = 1:4
    theta = theta_arr(i);
    phi = phi_arr(i);
    r = r_arr(i);
    r_Arr = linspace(r, 1.6*R_a, 100);
    r_Arr2 = linspace(1.6*R_a, 1.8*R_a, 100);
    xt = sqrt(r_Arr.^2-Ups^2)*sin(theta)*cos(phi);
    yt = sqrt(r_Arr.^2-Ups^2)*sin(theta)*sin(phi);
    zt = r_Arr*cos(theta);

    X = x_0+A_2\[xt;yt;zt];
    plot3(X(1,:),X(2,:),X(3,:),'color',lineColor)
    
    xt = sqrt(r_Arr2.^2-Ups^2)*sin(theta)*cos(phi);
    yt = sqrt(r_Arr2.^2-Ups^2)*sin(theta)*sin(phi);
    zt = r_Arr2*cos(theta);
    X = x_0+A_2\[xt;yt;zt];

    plot3(X(1,:),X(2,:),X(3,:),'--','color',lineColor)
end
Xi_values = linspace(xi_start, xi_end,resolution(1));
Eta_values = linspace(eta_start, eta_end,resolution(2));

X = zeros(length(Xi_values), length(Eta_values));
Y = zeros(length(Xi_values), length(Eta_values));
Z = zeros(length(Xi_values), length(Eta_values));

alphaValue = 0.8;
for i = 1:length(Xi_values)
    xi = Xi_values(i);
    for j = 1:length(Eta_values)
        eta = Eta_values(j);
        v = evaluateNURBS(nurbs, [xi eta]);
        
        X(i,j) = v(1);
        Y(i,j) = 1.0006*v(2);
        Z(i,j) = 1.0006*v(3);
    end
end

surf(X,Y,Z,'FaceColor', [0.8 0 0],'EdgeColor','none','LineStyle','none','FaceAlpha',alphaValue)
    
for n = 2:3
    for i = 1:length(Xi_values)
        xi = Xi_values(i);
        for j = 1:length(Eta_values)
            eta = Eta_values(j);
            v = evaluateNURBS(nurbs, [xi eta]);
            Xt = A_2*(v-x_0);
            xt = Xt(1);
            yt = Xt(2);
            zt = Xt(3);
            [~, theta, phi] = evaluateProlateCoords(xt,yt,zt,Ups);
            r = (1+(n-1)/4+1e-3)*R_a;
            xt = sqrt(r^2-Ups^2)*sin(theta)*cos(phi);
            yt = sqrt(r^2-Ups^2)*sin(theta)*sin(phi);
            zt = r*cos(theta);
            XX = x_0+A_2\[xt;yt;zt];
            
            X(i,j) = XX(1);
            Y(i,j) = XX(2);
            Z(i,j) = XX(3);
        end
    end
%     if n > 1
%         alphaValue = 0.6;
%     end
    surf(X,Y,Z,'FaceColor', [0.8 0 0],'EdgeColor','none','LineStyle','none','FaceAlpha',alphaValue)
%     if n == 1
%     else
%         surf(Z,X,Y, 'FaceColor', [0.8 0 0],'EdgeColor',[84 84 84]/256,'FaceAlpha',alphaValue)
%     end      
    X = zeros(length(Xi_values),1);
    Y = zeros(length(Xi_values),1);
    Z = zeros(length(Xi_values),1);

    for j = 1:length(eta_arr)
        eta = eta_arr(j);
        for i = 1:length(Xi_values)
            xi = Xi_values(i);
            v = evaluateNURBS(nurbs, [xi eta]);
            Xt = A_2*(v-x_0);
            xt = Xt(1);
            yt = Xt(2);
            zt = Xt(3);
            [~, theta, phi] = evaluateProlateCoords(xt,yt,zt,Ups);
            r = (1+(n-1)/4+1e-3)*R_a;
            xt = sqrt(r^2-Ups^2)*sin(theta)*cos(phi);
            yt = sqrt(r^2-Ups^2)*sin(theta)*sin(phi);
            zt = r*cos(theta);
            XX = x_0+A_2\[xt;yt;zt];
            X(i) = XX(1);
            Y(i) = XX(2);
            Z(i) = XX(3);
        end
        plot3(X,Y,Z,'color',lineColor)
    end

    X = zeros(length(Eta_values),1);
    Y = zeros(length(Eta_values),1);
    Z = zeros(length(Eta_values),1);
    for i = 1:length(xi_arr)
        xi = xi_arr(i);
        for j = 1:length(Eta_values)
            eta = Eta_values(j);
            v = evaluateNURBS(nurbs, [xi eta]);
            Xt = A_2*(v-x_0);
            xt = Xt(1);
            yt = Xt(2);
            zt = Xt(3);
            [~, theta, phi] = evaluateProlateCoords(xt,yt,zt,Ups);
            r = (1+(n-1)/4+1e-3)*R_a;
            xt = sqrt(r^2-Ups^2)*sin(theta)*cos(phi);
            yt = sqrt(r^2-Ups^2)*sin(theta)*sin(phi);
            zt = r*cos(theta);
            XX = x_0+A_2\[xt;yt;zt];
            X(j) = XX(1);
            Y(j) = XX(2);
            Z(j) = XX(3);
        end
        plot3(X,Y,Z,'color',lineColor)
    end
        
end

h = gcf;

hold off






