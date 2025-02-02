function nurbs = getModel5Data(R, eta1, eta2, L, l, alignWithAxis)

error('Depricated use getBeTSSiM5Data')


Xi = [0 0 0 1 1 2 2 3 3 4 4 4]/4;
Eta = [0, 0, eta1, eta2, 1, 1];

controlPts = zeros(4,9,4);

% outer surface
controlPts(:,1,1) = [ -L/2   0     0      1           ];
controlPts(:,2,1) = [ -L/2   0     0      1/sqrt(2)   ];
controlPts(:,3,1) = [ -L/2   0     0      1           ];
controlPts(:,4,1) = [ -L/2   0     0      1/sqrt(2)   ];
controlPts(:,5,1) = [ -L/2   0     0      1           ];
controlPts(:,6,1) = [ -L/2   0     0      1/sqrt(2)   ];
controlPts(:,7,1) = [ -L/2   0     0      1           ];
controlPts(:,8,1) = [ -L/2   0     0      1/sqrt(2)   ];
controlPts(:,9,1) = [ -L/2   0     0      1           ];

controlPts(:,1,2) = [ -L/2     R   0    	1           ];
controlPts(:,2,2) = [ -L/2     R   R   	1/sqrt(2)   ];
controlPts(:,3,2) = [	-L/2     0   R  	1           ];
controlPts(:,4,2) = [	-L/2    -R   R  	1/sqrt(2)   ];
controlPts(:,5,2) = [	-L/2    -R   0    	1           ];
controlPts(:,6,2) = [	-L/2    -R  -R   	1/sqrt(2)   ];
controlPts(:,7,2) = [	-L/2     0    -R   	1           ];
controlPts(:,8,2) = [	-L/2     R  -R   	1/sqrt(2)   ];
controlPts(:,9,2) = [	-L/2     R   0    	1           ];

controlPts(:,1,3) = [  L/2     R   0    	1           ];
controlPts(:,2,3) = [  L/2     R   R   	1/sqrt(2)   ];
controlPts(:,3,3) = [	L/2     0     R  	1           ];
controlPts(:,4,3) = [	L/2    -R   R  	1/sqrt(2)   ];
controlPts(:,5,3) = [	L/2    -R   0    	1           ];
controlPts(:,6,3) = [	L/2    -R  -R   	1/sqrt(2)   ];
controlPts(:,7,3) = [	L/2     0    -R   	1           ];
controlPts(:,8,3) = [	L/2     R  -R   	1/sqrt(2)   ];
controlPts(:,9,3) = [	L/2     R   0    	1           ];

controlPts(:,1,4) = [  L/2   0     0      1           ];
controlPts(:,2,4) = [  L/2   0     0      1/sqrt(2)   ];
controlPts(:,3,4) = [  L/2   0     0      1           ];
controlPts(:,4,4) = [  L/2   0     0      1/sqrt(2)   ];
controlPts(:,5,4) = [  L/2   0     0      1           ];
controlPts(:,6,4) = [  L/2   0     0      1/sqrt(2)   ];
controlPts(:,7,4) = [  L/2   0     0      1           ];
controlPts(:,8,4) = [  L/2   0     0      1/sqrt(2)   ];
controlPts(:,9,4) = [  L/2   0     0      1           ];

nurbs = createNURBSobject(controlPts,{Xi, Eta});
nurbs = translateNURBS(nurbs,[0,0,l/2]);
nurbs(2) = translateNURBS(nurbs,[0,0,-l]);

switch alignWithAxis
    case 'Xaxis' 
        % Nothing to be done
    case 'Yaxis' 
        nurbs = rotateNURBS(nurbs,pi/2,'Zaxis');
    case 'Zaxis'
        nurbs = rotateNURBS(nurbs,pi/2,'Yaxis');
end
