

scatteringCase = 'Sweep'; % 'BI' = Bistatic scattering, 'MS' = Monostatic scattering

model = 'M3'; % BeTSSi model 5A

method = {'IE','IENSG'};
% method = {'IENSG'};
formulation = 'BGU';

f = linspace(1e2,2e2,2); %[1e2 5e2 1e3];             % Frequency
omega = 2*pi*f;
k = omega/1500;
N = 3;

M = 1;
degree = 2:3;
loopParameters = {'f','M','degree','N','alpha','method'};
alpha = [90,180]*pi/180;

alpha_s = 240*pi/180;
beta_s = 0*pi/180;        
% beta_s = 30*pi/180;
prePlot.plot3Dgeometry = 1;

prePlot.plot2Dgeometry = 1;  % Plot cross section of mesh and geometry
% collectIntoTasks

method = {'KDT'};
collectIntoTasks
