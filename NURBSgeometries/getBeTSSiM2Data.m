function nurbs = getBeTSSiM2Data(varargin)
options = struct('R', 3,...
                 'L', 40,...
                 't', 0.02, ....
                 'theta1', 60*pi/180, ...
                 'theta2', 30*pi/180); 
if nargin > 0
    if numel(varargin) > 1
        newOptions = varargin;
    else
        newOptions = varargin{1};
    end
    options = updateOptions(options,newOptions);
end
R = options.R;
t = options.t;
L = options.L;

options.parm = 1;
nurbs = getQuarterDiskData('R',R,'parm',options.parm);
nurbs(2) = rotateNURBS(nurbs(1),'rotAxis',[1,1,1],'theta',2*pi/3);
nurbs(3) = rotateNURBS(nurbs(2),'rotAxis',[1,1,1],'theta',2*pi/3);
nurbs(1:3) = rotateNURBS(nurbs(1:3),'rotAxis',[1,0,0],'theta',pi/2);

nurbs(4) = rotateNURBS(getOctSphereData('R',R,'parm',options.parm),'rotAxis',[1,1,1],'theta',2*pi/3);
nurbs(5) = rotateNURBS(nurbs(4),'rotAxis',[1,0,0],'theta',-pi/2);
nurbs(6) = rotateNURBS(nurbs(5),'rotAxis',[1,0,0],'theta',-pi/2);
options.d_p = 2;
options.Xi = [0,0,0,1,1,2,2,3,3,4,4,4]/4;
nurbs(7:10) = explodeNURBS(getCylinderData(options));
nurbs(7:10) = rotateNURBS(nurbs(7:10),'rotAxis',[0,1,0],'theta',-pi/2);

nurbsArc = getArcData('Xi',[0,0,0,1,1,1],'R',R,'theta',pi/2);
xi = invertNURBS(nurbsArc{1},[sqrt(R^2-t^2/4),t/2],10*eps);
xiKnots = [xi*ones(1,2),(1-xi)*ones(1,2)];
knots = {xiKnots,xiKnots,[]};
nurbs = insertKnotsInNURBS(nurbs,knots);
    
nurbs(11) = translateNURBS(getQuarterDiskData('R',sqrt(R^2-t^2/4)-t/2),[1,1,0]*t/2);

nurbsArc = insertKnotsInNURBS(nurbsArc,{xiKnots});
nurbsArc = explodeNURBS(nurbsArc);
nurbsArc = ensure3DNURBS(nurbsArc);

coeffs = zeros(4,3,2);
coeffs(:,:,1) = nurbsArc{2}.coeffs;
coeffs(1:2,:,2) = t/2;
coeffs(4,:,2) = coeffs(4,:,1);
nurbs(12) = createNURBSobject(coeffs,{[0,0,0,1,1,1],[0,0,1,1]});
nurbs{11}.coeffs(4,:,:) = nurbs{11}.coeffs(4,:,:)*nurbs{12}.coeffs(4,1,1);
nurbs(11) = flipNURBSparametrization(rotateNURBS(nurbs(11),'rotAxis',[1,0,0],'theta',pi/2,'x_0',[1,1,0]*t/2));
nurbs(13) = flipNURBSparametrization(rotateNURBS(nurbs(11),'rotAxis',[0,0,1],'theta',pi/2,'x_0',[1,1,0]*t/2));

nurbs(11:13) = translateNURBS(rotateNURBS(nurbs(11:13),'rotAxis',[0,1,0],'theta',-pi/2),[-L,0,0]);
nurbs(14:16) = rotateNURBS(nurbs(11:13),'rotAxis',[1,0,0],'theta',pi/2);
nurbs(17:19) = rotateNURBS(nurbs(14:16),'rotAxis',[1,0,0],'theta',pi/2);
nurbs(20:22) = rotateNURBS(nurbs(17:19),'rotAxis',[1,0,0],'theta',pi/2);

arc1 = nurbsArc(1);
arc3 = rotateNURBS(arc1,'rotAxis',[0,1,0],'theta',-pi/2,'x_0',[t/2,0,0]);
coeffs = zeros(4,3,3);
coeffs(:,:,1) = arc1{1}.coeffs;
coeffs(:,:,3) = arc3{1}.coeffs;
coeffs([1,3],:,2) = arc1{1}.coeffs([1,3],:)+arc3{1}.coeffs([1,3],:);
coeffs(1,:,2) = coeffs(1,:,2)-t/2;
coeffs(2,:,2) = arc1{1}.coeffs(2,:);
coeffs(4,:,2) = arc3{1}.coeffs(4,:)/sqrt(2);

nurbs(23) = createNURBSobject(coeffs,{[0,0,0,1,1,1],[0,0,0,1,1,1]});
nurbs(24) = flipNURBSparametrization(mirrorNURBS(nurbs(23),'y'));

nurbs(23:24) = translateNURBS(rotateNURBS(nurbs(23:24),'rotAxis',[0,1,0],'theta',-pi/2),[-L,0,0]);
nurbs(25:26) = rotateNURBS(nurbs(23:24),'rotAxis',[1,0,0],'theta',pi/2);
nurbs(27:28) = rotateNURBS(nurbs(25:26),'rotAxis',[1,0,0],'theta',pi/2);
nurbs(29:30) = rotateNURBS(nurbs(27:28),'rotAxis',[1,0,0],'theta',pi/2);

coeffs = zeros(4,3,3);
coeffs(4,:,:) = 1;
coeffs(1,2:end,2:end) = nurbs{30}.coeffs(1,end,end);
coeffs(4,2:end,2:end) = nurbs{30}.coeffs(4,end,end);

coeffs(:,:,1) = nurbs{30}.coeffs(:,:,end);
coeffs(:,1,:) = nurbs{23}.coeffs(:,end:-1:1,end);
coeffs(4,end,end) = nurbs{30}.coeffs(4,1,end);
x1 = nurbs{30}.coeffs(1:3,2,end);
x2 = nurbs{30}.coeffs(1:3,2,end-1);
x3 = nurbs{23}.coeffs(1:3,2,end);
x4 = nurbs{23}.coeffs(1:3,2,end-1);
coeffs(1:3,2,2) = lineIntersection(x1,x2,x3,x4);
coeffs(:,end,2) = mean(coeffs(:,end,[1,3]),3);
coeffs(:,2,end) = mean(coeffs(:,[1,3],end),2);

coeffs(4,2,2) = mean(coeffs(4,[1,3],2),2);

nurbs(31) = createNURBSobject(coeffs,{[0,0,0,1,1,1],[0,0,0,1,1,1]});
nurbs(32) = rotateNURBS(nurbs(31),'rotAxis',[1,0,0],'theta',pi/2);
nurbs(33) = rotateNURBS(nurbs(32),'rotAxis',[1,0,0],'theta',pi/2);
nurbs(34) = rotateNURBS(nurbs(33),'rotAxis',[1,0,0],'theta',pi/2);

nurbs = rotateNURBS(nurbs,'rotAxis',[1,0,0],'theta',options.theta2);
nurbs = makeUniformNURBSDegree(nurbs);
nurbs = explodeNURBS(nurbs);



