function subnurbs = subNURBS(varargin)
options = struct('outwardPointingNormals',false);
nurbs = varargin{1};
if nargin > 1
    if numel(varargin) > 2
        newOptions = varargin(2:end);
    else
        newOptions = varargin{2};
    end
    options = updateOptions(options,newOptions);
end
noPatches = numel(nurbs);
if isfield(options,'at') && ~iscell(options.at)
    temp = options.at;
    options.at = cell(1,noPatches);
    [options.at(:)] = deal({temp});
end
subnurbs = cell(1,6*noPatches);
counter = 1;
for patch = 1:noPatches
    d = nurbs{patch}.d;
    d_p = nurbs{patch}.d_p;
    coeffs = nurbs{patch}.coeffs;
    dimensions = size(coeffs);
    number = nurbs{patch}.number;
    if isfield(options,'at')
        at = options.at{patch};
    else
        at = true(d_p,2);
    end
    for j = 1:2
        for i = 1:d_p
            if at(i,j)
                if j == 1
                    J = 1;
                else
                    J = dimensions(i+1);
                end
                idx = mod(i:i+1+d_p-2,d_p)+1;
                controlPts = permute(slc(coeffs,J,i+1),[1,idx+1]);
                idx = idx(1:end-1);
                controlPts = reshape(controlPts,[d+1,number(idx)]);
                knots = nurbs{patch}.knots(idx);

                subnurbs(counter) = createNURBSobject(controlPts,knots);
                if options.outwardPointingNormals && j == 1
                    subnurbs(counter) = flipNURBSparametrization(subnurbs(counter));
                end
                counter = counter + 1;
            end
        end
    end
end
subnurbs(counter:end) = [];
