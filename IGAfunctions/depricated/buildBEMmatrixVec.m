function [A, FF, varCol] = buildBEMmatrixVec(varCol)
error('Used buildCBEMmatrix instead')

degree = varCol.degree; % assume degree is equal in all patches

index = varCol.index;
noElems = varCol.noElems;
elRange = varCol.elRange;
element = varCol.element;
element2 = varCol.element2;
weights = varCol.weights;
controlPts = varCol.controlPts;
knotVecs = varCol.knotVecs;
pIndex = varCol.pIndex;
noElemsPatch = varCol.noElemsPatch;
noPatches = varCol.noPatches;
dofsToRemove = varCol.dofsToRemove;
noDofs = varCol.noDofs;

extraGP = varCol.extraGP;
extraGPBEM = varCol.extraGPBEM;
agpBEM = varCol.agpBEM;
exteriorProblem = varCol.exteriorProblem;
model = varCol.model;
colMethod = varCol.colMethod;

quadMethodBEM = varCol.quadMethodBEM;

Eps = 1e4*eps;

k = varCol.k;
alpha = 1i/k;

formulation = varCol.formulation;
if strcmp(formulation(end),'C')
    formulation = formulation(1:end-1);
end
switch formulation(2:end)
    case 'BM'
        useCBIE = true;
        useHBIE = true;
        psiType = NaN;
    case 'CBIE'
        useCBIE = true;
        useHBIE = false;
        psiType = NaN;
    case 'HBIE'
        useCBIE = false;
        useHBIE = true;
        psiType = NaN;
    otherwise
        useCBIE = true;
        useHBIE = false;
        psiType = str2double(formulation(end));  
end
useRegul = ~isnan(psiType);

if strcmp(varCol.coreMethod, 'XI')
    useEnrichedBfuns = true;
    d_vec = varCol.d_vec;
else
    useEnrichedBfuns = false;
    d_vec = NaN;
end

SHBC = strcmp(varCol.BC, 'SHBC');
if SHBC
    no_angles = length(varCol.alpha_s);
else
    no_angles = 1;
end
solveForPtot = varCol.solveForPtot;
if solveForPtot
    p_inc = varCol.p_inc;
    dp_inc = varCol.dp_inc;
    dpdn = @(x,n) 0;
else
    p_inc = NaN;
    dp_inc = varCol.dp_inc;
    if SHBC
        dpdn = @(x,n) -dp_inc(x,n);
    else
        dpdn = varCol.dpdn;
    end
end

if exteriorProblem
    sgn = 1;
else
    sgn = -1;
end

%% Create collocation points
colBEM_C0 = varCol.colBEM_C0;
if all(degree == 1)
    eps_greville = colBEM_C0./(2*degree);
else
    eps_greville = colBEM_C0./degree;
end
n_cp = noDofs - length(dofsToRemove);
counter2 = 1;
counter = 1;
cp_p = zeros(n_cp,2);
patchIdx = zeros(n_cp,1);
patches = varCol.patches;

[~, ~, diagsMax] = findMaxElementDiameter(patches);
centerPts = findCenterPoints(patches);

for patch = 1:noPatches
    nurbs = patches{patch}.nurbs;
    n_xi = nurbs.number(1);
    n_eta = nurbs.number(2);
    Xi_y = nurbs.knots{1};
    Eta_y = nurbs.knots{2};
    
    switch colMethod
        case 'Grev'
            for j = 1:n_eta
                eta_bar = sum(Eta_y(j+1:j+degree(2)))/degree(2);
                if Eta_y(j+1) == Eta_y(j+degree(2))
                    if Eta_y(j+1) == Eta_y(j+degree(2)+1)
                        eta_bar = eta_bar - eps_greville(2)*(Eta_y(j+degree(2)+1)-Eta_y(j));
                    else
                        eta_bar = eta_bar + eps_greville(2)*(Eta_y(j+degree(2)+1)-Eta_y(j+1));
                    end
                end
                for i = 1:n_xi
                    if ~any(dofsToRemove == counter)
                        xi_bar = sum(Xi_y(i+1:i+degree(1)))/degree(1);
                        if Xi_y(i+1) == Xi_y(i+degree(1))
                            if Xi_y(i+1) == Xi_y(i+degree(1)+1)
                                xi_bar = xi_bar - eps_greville(1)*(Xi_y(i+degree(1)+1)-Xi_y(i));
                            else
                                xi_bar = xi_bar + eps_greville(1)*(Xi_y(i+degree(1)+1)-Xi_y(i+1));
                            end
                        end

                        cp_p(counter2,:) = [xi_bar, eta_bar];
                        patchIdx(counter2) = patch;
                        counter2 = counter2 + 1;
                    end
                    counter = counter + 1;
                end
            end
        case 'CG'
            cg_xi = CauchyGalerkin(degree(1), n_xi, Xi_y);
            cg_eta = CauchyGalerkin(degree(2), n_eta, Eta_y);
            for j = 1:n_eta
                eta_bar = cg_eta(j);
                for i = 1:n_xi
                    if ~any(dofsToRemove == counter)
                        xi_bar = cg_xi(i);
                        cp_p(counter2,:) = [xi_bar, eta_bar];
                        patchIdx(counter2) = patch;
                        counter2 = counter2 + 1;
                    end
                    counter = counter + 1;
                end
            end
        case 'GL'
            cg_xi = splinesGL(Xi_y,degree(1));
            cg_eta = splinesGL(Eta_y,degree(2));
            for j = 1:n_eta
                eta_bar = cg_eta(j);
                for i = 1:n_xi
                    if ~any(dofsToRemove == counter)
                        xi_bar = cg_xi(i);
                        cp_p(counter2,:) = [xi_bar, eta_bar];
                        patchIdx(counter2) = patch;
                        counter2 = counter2 + 1;
                    end
                    counter = counter + 1;
                end
            end
    end
end
useNeumanProj = varCol.useNeumanProj;
if useNeumanProj
    [U,dU] = projectBC(varCol,SHBC,useCBIE,useHBIE);
else
    U = NaN;
    dU = NaN;
end
eNeighbour = NaN; % to avoid transparency "bug"
createElementTopology

n_en = prod(degree+1);

[Q2D_2,W2D_2,Q,W] = getBEMquadData(degree,extraGP,extraGPBEM,quadMethodBEM);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot_GP = 0;
% nurbs = varCol.nurbs;
% pD = plotBEMGeometry(nurbs,plot_GP,100,1);
% pD = plotBEMGeometry(nurbs,plot_GP,10,0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A = complex(zeros(1000, noDofs));
% FF = complex(zeros(1000, no_angles));
A = complex(zeros(n_cp, noDofs));
FF = complex(zeros(n_cp, no_angles));
totNoQPnonPolar = 0;
totNoQP = 0;
totNoQPprev = 0;
nProgressStepSize = ceil(n_cp/1000);
ppm = ParforProgMon('Building BEM matrix: ', n_cp, nProgressStepSize);
% for i = 14
% for i = 1:n_cp
parfor i = 1:n_cp
     if mod(i,nProgressStepSize) == 0
        ppm.increment();
     end
%     totArea = 0;
    if ~plot_GP % to avoid Matlab bug
        pD.plotGP = false;
    end
    patch = patchIdx(i);
    knots = knotVecs{patch};
    Xi_x = knotVecs{patch}{1}; % New
    Eta_x = knotVecs{patch}{2}; % New
    uniqueXi = unique(Xi_x);
    uniqueEta = unique(Eta_x);
    noElementsXi = length(uniqueXi)-1;
    noElementsEta = length(uniqueEta)-1;
    
    A_row = complex(zeros(1, noDofs));
    xi_x = cp_p(i,1);
    eta_x = cp_p(i,2);

    xi_idx = findKnotSpan(noElementsXi, 0, xi_x, uniqueXi);
    eta_idx = findKnotSpan(noElementsEta, 0, eta_x, uniqueEta);
    e_x = sum(noElemsPatch(1:patch-1)) + xi_idx + noElementsXi*(eta_idx-1);
    
    idXi_x = index(e_x,1);
    idEta_x = index(e_x,2);

    Xi_e_x = elRange{1}(idXi_x,:);
    Eta_e_x = elRange{2}(idEta_x,:);
    if plot_GP
        if numel(pD.h) > 1
            delete(pD.h(2:end))
        end
        if i == 354
            if strcmp(quadMethodBEM,'Simpson')
                xi_x = parent2ParametricSpace(Xi_e_x, Q(1,1));
                eta_x = parent2ParametricSpace(Eta_e_x, Q(1,1));
            else
                xi_x = parent2ParametricSpace(Xi_e_x, Q{degree(1)+1+extraGP}(1,1));
                eta_x = parent2ParametricSpace(Eta_e_x, Q{degree(1)+1+extraGP}(1,1));
            end
        end
    end
    
    sctr_x = element(e_x,:);
    pts_x = controlPts(sctr_x,:);
    wgts_x = weights(element2(e_x,:),:); % New

    if useHBIE || useRegul
        singularMapping = true;
        eps_greville = zeros(1,2);
        while singularMapping
            xi = [xi_x, eta_x];
            I = findKnotSpans(degree, xi(1,:), knots);
            R = NURBSbasis(I, xi, degree, knots, wgts_x);
            R_x = R{1};
            dR_xdxi = R{2};
            dR_xdeta = R{3};
            x = R_x*pts_x;
            J_temp = [dR_xdxi; dR_xdeta]*pts_x;
            m_1 = J_temp(1,:);
            m_2 = J_temp(2,:);
            crossProd_x = cross(m_1,m_2);
            h_xi = norm(m_1);
            if h_xi < Eps
                eps_greville(2) = 1/(2*degree(2))*(Eta_e_x(2)-Eta_e_x(1));
                if eta_x+eps_greville(2) > Eta_e_x(2)
                    eta_x = eta_x - eps_greville(2)*(Eta_e_x(2)-Eta_e_x(1));
                else
                    eta_x = eta_x + eps_greville(2)*(Eta_e_x(2)-Eta_e_x(1));
                end
                continue
            end
            h_eta = norm(m_2);
            if h_eta < Eps
                eps_greville(1) = 1/(2*degree(1))*(Xi_e_x(2)-Xi_e_x(1));
                if xi_x+eps_greville(1) > Xi_e_x(2)
                    xi_x = xi_x - eps_greville(1)*(Xi_e_x(2)-Xi_e_x(1));
                else
                    xi_x = xi_x + eps_greville(1)*(Xi_e_x(2)-Xi_e_x(1));
                end
                continue
            end
            singularMapping = false;
        end
        e_xi = m_1/h_xi;
        e_eta = m_2/h_eta;

        v_1 = m_1/norm(m_1);
        nx = crossProd_x/norm(crossProd_x);
        v_2 = cross(nx,v_1);
        cosT = dot(e_xi,e_eta);
        sinT = dot(v_2,e_eta);
        dXIdv = [1/h_xi, 0; -cosT/sinT/h_xi, 1/h_eta/sinT];
    else
        xi = [xi_x, eta_x];
        I = findKnotSpans(degree, xi(1,:), knots);
        R = NURBSbasis(I, xi, degree, knots, wgts_x);
        R_x = R{1};
        dR_xdxi = NaN;
        dR_xdeta = NaN;
        x = R_x*pts_x;
        nx = NaN;       
        dXIdv = NaN;  
        v_1 = NaN;
        v_2 = NaN;
    end
    [constants, integrals] = initializeBIE(psiType,useRegul,x,nx,k,model);
    
    FF_temp = complex(zeros(1, no_angles));
    if plot_GP
        pD = plotGP(pD,x,'blue');
    end
    [adjacentElements, xi_x_tArr,eta_x_tArr] = getAdjacentElements(e_x,xi_x,eta_x,Xi_e_x,Eta_e_x,eNeighbour,Eps);
    for e_y = 1:noElems  
        [BIE, integrals, FF_temp, sctr_y, noGp, collocationPointIsInElement, pD] = getBEMquadPts(e_y,Q2D_2,W2D_2,Q,W,integrals,FF_temp,...
                useEnrichedBfuns,k,d_vec,useNeumanProj,solveForPtot,useCBIE,useHBIE,dpdn,U,...
                x,nx,xi_x_tArr,eta_x_tArr,adjacentElements,constants,psiType,useRegul,...
                degree,pIndex,knotVecs,index,elRange,element,element2,controlPts,weights,...
                patches,Eps,diagsMax,centerPts,agpBEM,quadMethodBEM,pD);
        for j = 1:n_en
            A_row(sctr_y(j)) = A_row(sctr_y(j)) + BIE(j);
        end
        if ~collocationPointIsInElement
            totNoQPnonPolar = totNoQPnonPolar + noGp;
        end
        totNoQP = totNoQP + noGp;
    end
%     rms(A_row)
    if plot_GP
%         figureFullScreen(gcf)
%         totNoQP-totNoQPprev
%         totNoQPprev = totNoQP;
%         export_fig(['../../graphics/BEM/S1_' num2str(i) '_extraGPBEM' num2str(extraGPBEM) '_agpBEM' num2str(agpBEM) '_' quadMethodBEM], '-png', '-transparent', '-r300')
%         export_fig(['../../graphics/BEM/S1_' num2str(i) '_extraGPBEM' num2str(extraGPBEM) '_agpBEM' num2str(agpBEM) '_' quadMethodBEM], '-png', '-transparent', '-r200')
%         keyboard
    end
    R_xScaled = getR_x_Coeff(R_x,useEnrichedBfuns,k,d_vec,x,useRegul,integrals,sgn,constants,...
                    psiType,useCBIE,useHBIE,dXIdv,dR_xdxi,dR_xdeta,v_1,v_2,alpha);
    for j = 1:n_en
        A_row(sctr_x(j)) = A_row(sctr_x(j)) + R_xScaled(j);
    end     
    A(i,:) = A_row;
    FF(i,:) = getF_eTemp(FF_temp,useNeumanProj,solveForPtot,psiType,useCBIE,useHBIE,useRegul,R_x,sctr_x,x,nx,...
                U,dU,p_inc,dp_inc,dpdn,alpha,integrals,k,constants,sgn);
end

% totNoQP
varCol.totNoQPnonPolar = totNoQPnonPolar;
varCol.totNoQP = totNoQP;
