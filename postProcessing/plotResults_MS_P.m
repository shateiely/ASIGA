
for study_i = 1:numel(studies)  
    study = studies(study_i);
    options = struct('xname',           'h_max',  ...
                     'yname',           'energyError', ...
                     'plotResults', 	1, ... 
                     'printResults',	1, ... 
                     'axisType',        'loglog', ... 
                     'lineStyle',       '*-', ... 
                     'xLoopName',       'M', ...
                     'subFolderName',   'results/_studies/MS_P', ...
                     'noXLoopPrms',     1); 

    figure(2)
    printResultsToTextFiles(study,options)

    options.xname = 'dofs';
    options.yname = 'cond_number';
    figure(4)
    printResultsToTextFiles(study,options)
% 
%             options.xname = 'tot_time';
%             options.yname = 'energyError';
%             options.axisType = 'loglog';
%             options.printResults = 0;
%             figure(3)
%             printResultsToTextFiles(study,options)
end
%         for study_i = 1:numel(studies)  
%             study = studies(study_i);
%             options = struct('xname',           'dofs',  ...
%                              'yname',           'energyError', ...
%                              'plotResults', 	1, ... 
%                              'printResults',	0, ... 
%                              'axisType',        'loglog', ... 
%                              'lineStyle',       '*-', ... 
%                              'xLoopName',       'M', ...
%                              'noXLoopPrms',     1); 
% 
%             figure(2)
%             printResultsToTextFiles(study,options)
% 
%             options = struct('xname',           'parm',  ...
%                              'yname',           'energyError', ...
%                              'plotResults', 	1, ... 
%                              'printResults',	0, ... 
%                              'axisType',        'semilogy', ... 
%                              'lineStyle',       '*-', ... 
%                              'xLoopName',       'parm', ...
%                              'noXLoopPrms',     1); 
% 
%             figure(3)
%             printResultsToTextFiles(study,options)
%             options.xname = 'dofs';
%             options.yname = 'cond_number';
%             figure(4)
%             printResultsToTextFiles(study,options)
% 
%             options.xname = 'tot_time';
%             options.yname = 'energyError';
%             options.axisType = 'loglog';
%             options.printResults = 0;
%             figure(3)
%             printResultsToTextFiles(study,options)
%         end