function varCol = setAndDefineParameters(varCol,task)
switch task.model
    case {'SS', 'PS', 'S1', 'S1_P2', 'S3', 'S5', 'S13', 'S15', 'S35', 'IL'}
        analyticSolutionExist = true;
        isSphericalShell = true;
    case {'Safjan2002tdi'}
        analyticSolutionExist = true;
        isSphericalShell = false;
    otherwise
        analyticSolutionExist = false;
        isSphericalShell = false;
end
applyLoad = task.applyLoad;
if strcmp(applyLoad,'pointPulsation') || strcmp(applyLoad,'SimpsonTorus') || strcmp(applyLoad,'radialPulsation')
    analyticSolutionExist = true;
end    
if (task.calculateSurfaceError || task.calculateVolumeError) && ~analyticSolutionExist
    error('The errors cannot be computed without an analytic solution')
end

for m = 1:numel(varCol)
    if strcmp(varCol{m}.media,'solid')
        varCol{m}.C = elasticityMatrix(varCol{m}.E,varCol{m}.nu);
    end
end


switch task.method
    case {'IE','ABC'}
        boundaryMethod = false;
    case {'IENSG','BEM','KDT','MFS','RT'}
        boundaryMethod = true;
    case 'BA'
        switch formulation
            case {'SL2E','SL2Etot'}
                boundaryMethod = true;
            case {'VL2E','VL2Etot'}
                boundaryMethod = false;
            otherwise
                error('Not implemented')
        end
end
for i = 1:numel(varCol)
    if mod(i,2)
        varCol{i}.boundaryMethod = boundaryMethod; % Assume only 3D elasticity is implemented
    else
        varCol{i}.boundaryMethod = false; % Assume only 3D elasticity is implemented
    end
end

varCol{1}.analyticSolutionExist = analyticSolutionExist;
varCol{1}.isSphericalShell = isSphericalShell;
varCol{1}.alpha          = task.alpha;
varCol{1}.beta           = task.beta;
switch task.scatteringCase
    case {'MS','Sweep'}
        varCol{1}.alpha_s = task.alpha;
        varCol{1}.beta_s  = task.beta;
    otherwise
        varCol{1}.alpha_s = task.alpha_s;
        varCol{1}.beta_s  = task.beta_s;
end
if varCol{1}.useROM
    varCol{1}.noRHSs = varCol{1}.noVecs;
else
    varCol{1}.noRHSs = numel(varCol{1}.alpha_s);
end
    
