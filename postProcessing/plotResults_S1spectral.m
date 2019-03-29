
for study_i = 1:numel(studies)
    study = studies(study_i);
    options = struct('xname',           'degreeElev',  ...
                     'yname',           'surfaceError', ...
                     'plotResults', 	1, ... 
                     'printResults',	1, ... 
                     'axisType',        'semilogy', ... 
                     'lineStyle',       '*-', ... 
                     'xLoopName',       'degreeElev', ...
                     'subFolderName',   'results/_studies/spectral', ...
                     'legendEntries',   {{'method'}}, ...
                     'noXLoopPrms',     1); 
% 
    figure(2)
    printResultsToTextFiles(study,options)
    options.yname = 'cond_number';
%             options.axisType = 'loglog';
    figure(3)
    printResultsToTextFiles(study,options)
end
% 