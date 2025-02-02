scatteringCase = 'BI';

model = 'S1';  % Spherical shell

coreMethod = 'IGA';


f = 1e3;

alpha_s = 0;
beta_s = 0;   

M = 1:6;
parm = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ABC simulation
method = {'ABC'};
% formulation = {'HH','BGT'};
formulation = {'BGT'};
prePlot.plot2Dgeometry = 0;
prePlot.plot3Dgeometry = 0;
degree = 2;
% calculateVolumeError = 1;
calculateSurfaceError = 1;
computeCondNumber = false;
calculateFarFieldPattern = 0;
applyLoad = 'planeWave';
N = 1:2;

loopParameters = {'M','N','degree','formulation','method'};
% collectIntoTasks

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IE simulation
method = {'IE'};
formulation = {'BGU'};
N = 1:3;
% collectIntoTasks

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IENSG simulation
method = {'IENSG'};
formulation = {'BGC','BGU','PGU','PGC'};
N = [1,3,6,9];
collectIntoTasks

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BA simulation
method = {'BA'};
formulation = {'SL2E'};
N = NaN;
collectIntoTasks


