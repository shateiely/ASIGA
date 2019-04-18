
for study_i = 1:numel(studies)
    study = studies(study_i);
    options = struct('xname',           'dofs',  ...
                     'yname',           'surfaceError', ...
                     'plotResults', 	1, ... 
                     'printResults',	1, ... 
                     'axisType',        'loglog', ... 
                     'lineStyle',       '*-', ... 
                     'xLoopName',       'M', ...
                     'yScale',          1/100, ... 
                     'subFolderName',   '../results/Simpson_Torus', ...
                     'legendEntries',   {{'method','coreMethod','formulation','degree','extraGP','extraGPBEM','agpBEM'}}, ...
                     'noXLoopPrms',     1); 

    figure(2)
    printResultsToTextFiles(study,options)
% 
%             options.xname = 'tot_time';
%             options.axisType = 'loglog';
%             figure(3)
%             printResultsToTextFiles(study,options)
% 
%             options.xname = 'dofs';
%             options.yname = 'cond_number';
%             figure(4)
%             printResultsToTextFiles(study,options)
end

error_simpson = importdata('../results/Simpson_Torus/imageData/Fig24_p2.csv');
semilogy(error_simpson(:,1),error_simpson(:,2),'*-','DisplayName','Simpson p = 2');
error_simpson = importdata('../results/Simpson_Torus/imageData/Fig24_p3.csv');
semilogy(error_simpson(:,1),error_simpson(:,2),'*-','DisplayName','Simpson p = 3');

