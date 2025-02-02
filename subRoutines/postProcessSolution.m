function [varCol,U,Uc] = postProcessSolution(varCol,task,UU)

%% Sort data from UU into Uc{1}, Uc{2}, and Uc{3}
if strcmp(method,'MFS')
    Uc{1} = UU;
else
    U = zeros(noDofs_tot,size(UU,2),size(UU,3));
    U(setdiff(1:noDofs_tot, dofsToRemove'),:,:) = UU;   

    switch numel(varCol)
        case 1
        %         Uc{1} = U(1:varCol_fluid_o.noDofs,:,:); 
            Uc{1} = U; 
            Uc{1} = addSolutionToRemovedNodes_new(Uc{1}, varCol{1});
        case 2
            Uc{1} = U((varCol{2}.noDofs+1):end,:,:);
            Uc{2} = U(1:varCol{2}.noDofs,:,:); 

            Uc{1} = addSolutionToRemovedNodes_new(Uc{1}, varCol{1});
            Uc{2} = addSolutionToRemovedNodes_new(Uc{2}, varCol{2});
        case 3
            Uc{1} = U((varCol{3}.noDofs+varCol{2}.noDofs+1):end,:,:); 
            Uc{2} = U((varCol{3}.noDofs+1):(varCol{3}.noDofs + varCol{2}.noDofs),:,:);
            Uc{3} = U(1:varCol{3}.noDofs,:,:);

            Uc{1} = addSolutionToRemovedNodes_new(Uc{1}, varCol{1});
            Uc{2} = addSolutionToRemovedNodes_new(Uc{2}, varCol{2});
            Uc{3} = addSolutionToRemovedNodes_new(Uc{3}, varCol{3});
    end
    % save([resultsFolderName '/' saveName  '_' coreMethod method '_mesh' num2str(M) '_degree' num2str(max(varCol.nurbs.degree)) ...
    %                         '_formulation' varCol.formulation '.mat'], 'varCol', 'Uc{1}')
end

%% Find h_max and store results
if i_f == 1
    h_max_fluid = findMaxElementDiameter(varCol{1}.patches);
    h_max = h_max_fluid;
    if numel(varCol) > 1
        h_max_solid = findMaxElementDiameter(varCol{2}.patches);
        h_max = max([h_max, h_max_solid]);
    end
    if numel(varCol) > 2
        h_max_fluid_i = findMaxElementDiameter(varCol{3}.patches);
        h_max = max([h_max, h_max_fluid_i]);
    end
    varCol{1}.h_max = h_max;
    varCol{1}.nepw = varCol{1}.lambda./h_max;
    varCol{1}.surfDofs = getNoSurfDofs(varCol{1});
    if task.storeSolution
        varCol{1}.U = Uc{1};
    end
end