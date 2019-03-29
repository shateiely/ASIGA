function nurbs = getTorusData(R,r)


Xi = [0 0 0 1 1 2 2 3 3 4 4 4]/4;
Eta = [0 0 0 1 1 2 2 3 3 4 4 4]/4;
Zeta = [0 0 1 1];

controlPts = zeros(4,9,9,2);

% inner "surface"
controlPts(:,1,1,1) = [ R     0        0      1           ];
controlPts(:,2,1,1) = [ R     R      0      1/sqrt(2)	];
controlPts(:,3,1,1) = [ 0       R      0      1       	];
controlPts(:,4,1,1) = [-R     R      0      1/sqrt(2)	];
controlPts(:,5,1,1) = [-R     0        0  	1       	];
controlPts(:,6,1,1) = [-R    -R      0  	1/sqrt(2)	];
controlPts(:,7,1,1) = [ 0      -R      0  	1       	];
controlPts(:,8,1,1) = [ R    -R      0   	1/sqrt(2)	];
controlPts(:,9,1,1) = [ R     0        0  	1           ];

controlPts(:,1,2,1) = [ R     0        0      1/sqrt(2)  	];
controlPts(:,2,2,1) = [ R     R      0      1/2         ];
controlPts(:,3,2,1) = [ 0       R      0      1/sqrt(2) 	];
controlPts(:,4,2,1) = [-R     R      0      1/2         ];
controlPts(:,5,2,1) = [-R     0        0  	1/sqrt(2)  	];
controlPts(:,6,2,1) = [-R    -R      0  	1/2         ];
controlPts(:,7,2,1) = [ 0      -R      0  	1/sqrt(2)  	];
controlPts(:,8,2,1) = [ R    -R      0   	1/2         ];
controlPts(:,9,2,1) = [ R     0        0  	1/sqrt(2)  	];

controlPts(:,1,3,1) = [ R     0       0       1           ];
controlPts(:,2,3,1) = [ R     R     0       1/sqrt(2)	];
controlPts(:,3,3,1) = [ 0       R     0       1       	];
controlPts(:,4,3,1) = [-R     R     0       1/sqrt(2)	];
controlPts(:,5,3,1) = [-R     0       0       1       	];
controlPts(:,6,3,1) = [-R    -R     0       1/sqrt(2)	];
controlPts(:,7,3,1) = [ 0      -R     0       1       	];
controlPts(:,8,3,1) = [ R    -R     0   	1/sqrt(2)	];
controlPts(:,9,3,1) = [ R     0       0       1           ];

controlPts(:,1,4,1) = [ R     0       0       1/sqrt(2)  	];
controlPts(:,2,4,1) = [ R     R     0       1/2         ];
controlPts(:,3,4,1) = [ 0       R     0       1/sqrt(2) 	];
controlPts(:,4,4,1) = [-R     R     0       1/2         ];
controlPts(:,5,4,1) = [-R     0       0       1/sqrt(2)  	];
controlPts(:,6,4,1) = [-R    -R     0       1/2         ];
controlPts(:,7,4,1) = [ 0      -R     0       1/sqrt(2)  	];
controlPts(:,8,4,1) = [ R    -R     0   	1/2         ];
controlPts(:,9,4,1) = [ R     0       0       1/sqrt(2)  	];

controlPts(:,1,5,1) = [ R     0       0       1           ];
controlPts(:,2,5,1) = [ R     R     0       1/sqrt(2)	];
controlPts(:,3,5,1) = [ 0       R     0       1       	];
controlPts(:,4,5,1) = [-R     R     0       1/sqrt(2)	];
controlPts(:,5,5,1) = [-R     0       0       1       	];
controlPts(:,6,5,1) = [-R    -R     0       1/sqrt(2)	];
controlPts(:,7,5,1) = [ 0      -R     0       1       	];
controlPts(:,8,5,1) = [ R    -R     0   	1/sqrt(2)	];
controlPts(:,9,5,1) = [ R     0       0       1           ];

controlPts(:,1,6,1) = [ R     0       0       1/sqrt(2)  	];
controlPts(:,2,6,1) = [ R     R     0       1/2         ];
controlPts(:,3,6,1) = [ 0       R     0       1/sqrt(2) 	];
controlPts(:,4,6,1) = [-R     R     0       1/2         ];
controlPts(:,5,6,1) = [-R     0       0       1/sqrt(2)  	];
controlPts(:,6,6,1) = [-R    -R     0       1/2         ];
controlPts(:,7,6,1) = [ 0      -R     0       1/sqrt(2)  	];
controlPts(:,8,6,1) = [ R    -R     0   	1/2         ];
controlPts(:,9,6,1) = [ R     0       0       1/sqrt(2)  	];

controlPts(:,1,7,1) = [ R     0       0       1           ];
controlPts(:,2,7,1) = [ R     R     0       1/sqrt(2)	];
controlPts(:,3,7,1) = [ 0       R     0       1       	];
controlPts(:,4,7,1) = [-R     R     0       1/sqrt(2)	];
controlPts(:,5,7,1) = [-R     0       0       1       	];
controlPts(:,6,7,1) = [-R    -R     0       1/sqrt(2)	];
controlPts(:,7,7,1) = [ 0      -R     0       1       	];
controlPts(:,8,7,1) = [ R    -R     0   	1/sqrt(2)	];
controlPts(:,9,7,1) = [ R     0       0       1           ];

controlPts(:,1,8,1) = [ R     0        0     	1/sqrt(2)  	];
controlPts(:,2,8,1) = [ R     R      0    	1/2         ];
controlPts(:,3,8,1) = [ 0       R      0    	1/sqrt(2) 	];
controlPts(:,4,8,1) = [-R     R      0     	1/2         ];
controlPts(:,5,8,1) = [-R     0        0     	1/sqrt(2)  	];
controlPts(:,6,8,1) = [-R    -R      0     	1/2         ];
controlPts(:,7,8,1) = [ 0      -R      0     	1/sqrt(2)  	];
controlPts(:,8,8,1) = [ R    -R      0     	1/2         ];
controlPts(:,9,8,1) = [ R     0        0     	1/sqrt(2)  	];

controlPts(:,1,9,1) = [ R     0        0      1           ];
controlPts(:,2,9,1) = [ R     R      0      1/sqrt(2)	];
controlPts(:,3,9,1) = [ 0       R      0      1       	];
controlPts(:,4,9,1) = [-R     R      0      1/sqrt(2)	];
controlPts(:,5,9,1) = [-R     0        0      1       	];
controlPts(:,6,9,1) = [-R    -R      0      1/sqrt(2)	];
controlPts(:,7,9,1) = [ 0      -R      0      1       	];
controlPts(:,8,9,1) = [ R    -R      0   	1/sqrt(2)	];
controlPts(:,9,9,1) = [ R     0        0      1           ];


% outer surface
controlPts(:,1,1,2) = [ R     0       -r      1           ];
controlPts(:,2,1,2) = [ R     R     -r      1/sqrt(2)	];
controlPts(:,3,1,2) = [ 0       R     -r      1       	];
controlPts(:,4,1,2) = [-R     R     -r      1/sqrt(2)	];
controlPts(:,5,1,2) = [-R     0       -r  	1       	];
controlPts(:,6,1,2) = [-R    -R     -r  	1/sqrt(2)	];
controlPts(:,7,1,2) = [ 0      -R     -r  	1       	];
controlPts(:,8,1,2) = [ R    -R     -r   	1/sqrt(2)	];
controlPts(:,9,1,2) = [ R     0       -r  	1           ];

controlPts(:,1,2,2) = [ R+r     0       -r      1/sqrt(2)  	];
controlPts(:,2,2,2) = [ R+r     R+r     -r      1/2         ];
controlPts(:,3,2,2) = [ 0       R+r     -r      1/sqrt(2) 	];
controlPts(:,4,2,2) = [-(R+r)     R+r     -r      1/2         ];
controlPts(:,5,2,2) = [-(R+r)     0       -r  	1/sqrt(2)  	];
controlPts(:,6,2,2) = [-(R+r)    -(R+r)     -r  	1/2         ];
controlPts(:,7,2,2) = [ 0      -(R+r)     -r  	1/sqrt(2)  	];
controlPts(:,8,2,2) = [ R+r    -(R+r)     -r   	1/2         ];
controlPts(:,9,2,2) = [ R+r     0       -r  	1/sqrt(2)  	];

controlPts(:,1,3,2) = [ R+r     0       0       1           ];
controlPts(:,2,3,2) = [ R+r     R+r     0       1/sqrt(2)	];
controlPts(:,3,3,2) = [ 0       R+r     0       1       	];
controlPts(:,4,3,2) = [-(R+r)     R+r     0       1/sqrt(2)	];
controlPts(:,5,3,2) = [-(R+r)     0       0       1       	];
controlPts(:,6,3,2) = [-(R+r)    -(R+r)     0       1/sqrt(2)	];
controlPts(:,7,3,2) = [ 0      -(R+r)     0       1       	];
controlPts(:,8,3,2) = [ R+r    -(R+r)     0   	1/sqrt(2)	];
controlPts(:,9,3,2) = [ R+r     0       0       1           ];

controlPts(:,1,4,2) = [ R+r     0       r       1/sqrt(2)  	];
controlPts(:,2,4,2) = [ R+r     R+r     r       1/2         ];
controlPts(:,3,4,2) = [ 0       R+r     r       1/sqrt(2) 	];
controlPts(:,4,4,2) = [-(R+r)     R+r     r       1/2         ];
controlPts(:,5,4,2) = [-(R+r)     0       r       1/sqrt(2)  	];
controlPts(:,6,4,2) = [-(R+r)    -(R+r)     r       1/2         ];
controlPts(:,7,4,2) = [ 0      -(R+r)     r       1/sqrt(2)  	];
controlPts(:,8,4,2) = [ R+r    -(R+r)     r   	1/2         ];
controlPts(:,9,4,2) = [ R+r     0       r       1/sqrt(2)  	];

controlPts(:,1,5,2) = [ R     0       r       1           ];
controlPts(:,2,5,2) = [ R     R     r       1/sqrt(2)	];
controlPts(:,3,5,2) = [ 0       R     r       1       	];
controlPts(:,4,5,2) = [-R     R     r       1/sqrt(2)	];
controlPts(:,5,5,2) = [-R     0       r       1       	];
controlPts(:,6,5,2) = [-R    -R     r       1/sqrt(2)	];
controlPts(:,7,5,2) = [ 0      -R     r       1       	];
controlPts(:,8,5,2) = [ R    -R     r   	1/sqrt(2)	];
controlPts(:,9,5,2) = [ R     0       r       1           ];

controlPts(:,1,6,2) = [ R-r     0       r       1/sqrt(2)  	];
controlPts(:,2,6,2) = [ R-r     R-r     r       1/2         ];
controlPts(:,3,6,2) = [ 0       R-r     r       1/sqrt(2) 	];
controlPts(:,4,6,2) = [-(R-r)     R-r     r       1/2         ];
controlPts(:,5,6,2) = [-(R-r)     0       r       1/sqrt(2)  	];
controlPts(:,6,6,2) = [-(R-r)    -(R-r)     r       1/2         ];
controlPts(:,7,6,2) = [ 0      -(R-r)     r       1/sqrt(2)  	];
controlPts(:,8,6,2) = [ R-r    -(R-r)     r   	1/2         ];
controlPts(:,9,6,2) = [ R-r     0       r       1/sqrt(2)  	];

controlPts(:,1,7,2) = [ R-r     0       0       1           ];
controlPts(:,2,7,2) = [ R-r     R-r     0       1/sqrt(2)	];
controlPts(:,3,7,2) = [ 0       R-r     0       1       	];
controlPts(:,4,7,2) = [-(R-r)     R-r     0       1/sqrt(2)	];
controlPts(:,5,7,2) = [-(R-r)     0       0       1       	];
controlPts(:,6,7,2) = [-(R-r)    -(R-r)     0       1/sqrt(2)	];
controlPts(:,7,7,2) = [ 0      -(R-r)     0       1       	];
controlPts(:,8,7,2) = [ R-r    -(R-r)     0   	1/sqrt(2)	];
controlPts(:,9,7,2) = [ R-r     0       0       1           ];

controlPts(:,1,8,2) = [ R-r     0       -r     	1/sqrt(2)  	];
controlPts(:,2,8,2) = [ R-r     R-r     -r    	1/2         ];
controlPts(:,3,8,2) = [ 0       R-r     -r    	1/sqrt(2) 	];
controlPts(:,4,8,2) = [-(R-r)     R-r     -r     	1/2         ];
controlPts(:,5,8,2) = [-(R-r)     0       -r     	1/sqrt(2)  	];
controlPts(:,6,8,2) = [-(R-r)    -(R-r)     -r     	1/2         ];
controlPts(:,7,8,2) = [ 0      -(R-r)     -r     	1/sqrt(2)  	];
controlPts(:,8,8,2) = [ R-r    -(R-r)     -r     	1/2         ];
controlPts(:,9,8,2) = [ R-r     0       -r     	1/sqrt(2)  	];

controlPts(:,1,9,2) = [ R     0       -r      1           ];
controlPts(:,2,9,2) = [ R     R     -r      1/sqrt(2)	];
controlPts(:,3,9,2) = [ 0       R     -r      1       	];
controlPts(:,4,9,2) = [-R     R     -r      1/sqrt(2)	];
controlPts(:,5,9,2) = [-R     0       -r      1       	];
controlPts(:,6,9,2) = [-R    -R     -r      1/sqrt(2)	];
controlPts(:,7,9,2) = [ 0      -R     -r      1       	];
controlPts(:,8,9,2) = [ R    -R     -r   	1/sqrt(2)	];
controlPts(:,9,9,2) = [ R     0       -r      1           ];


nurbs = createNURBSobject(controlPts,{Xi, Eta, Zeta});
