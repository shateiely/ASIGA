%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main file of ASIGA
% Author: Jon Vegard Ven�s
% E-mail: JonVegard.Venas@sintef.no
% Institute: SINTEF Digital
% Release: 2
% Release date: 29/07/2020

startup
startMatlabPool
availableStudies

%% Extract tasks
if ~iscell(studyName)
    studyName = {studyName};
end
studiesCol = getTasks(studyName);

%% Perform studies
t_start_study = tic;
for i_col = 1:numel(studiesCol)
    studies = studiesCol{i_col};
    for i_study = 1:numel(studies)    
        loopParameters = studies(i_study).loopParameters;
        loopParametersArr = studies(i_study).loopParametersArr;
        noTasks = length(studies(i_study).tasks);

        tasks = studies(i_study).tasks;
        resultsFolder = [folderName '/' studies(i_study).subFolderName];
        if ~exist(resultsFolder, 'dir')
            mkdir(resultsFolder)
        end

        runTasksInParallel = studies(i_study).runTasksInParallel;
        if runTasksInParallel
            parfor i_task = 1:length(tasks)
                tasks(i_task).task = main_sub(tasks(i_task).task,loopParameters,runTasksInParallel,resultsFolder);
                fprintf('\nCase %s: Completed task %d/%d in study %d/%d\n\n', studyName{i_col}, i_task, noTasks, i_study,length(studies)) 
            end
            studies(i_study).tasks = tasks;
        else
            for i_task = 1:noTasks
                tasks(i_task).task = main_sub(tasks(i_task).task,loopParameters,runTasksInParallel,resultsFolder);
                task = tasks(i_task).task;
                if (task.prePlot.plot3Dgeometry || task.prePlot.plot2Dgeometry) && task.prePlot.abortAfterPlotting
                    return
                end
                if task.useROM
                    computeROMsolution
                end
                studies(i_study).tasks(i_task,1).task = tasks(i_task,1).task;
                fprintf('\nCase %s: Completed task %d/%d in study %d/%d\n\n', studyName{i_col}, i_task, noTasks, i_study,length(studies)) 
                save([resultsFolder '/studies'], 'studies')
            end
            if task.useROM
                studies(i_study).loopParameters{end+1} = 'noVecs';
                studies(i_study).loopParametersArr{end+1} = noVecsArr;
                studies(i_study).loopParameters{end+1} = 'basisROM';
                studies(i_study).loopParametersArr{end+1} = basisROMcell;
                studies(i_study).tasks = tasks(:);
            end
            studies(i_study).resultsFolder = resultsFolder;
        end 
        save([resultsFolder '/studies'], 'studies')
    end
    fprintf('\n\nTotal time spent on study "%s": %12f seconds\n', studyName{1}, toc(t_start_study)) 
    close all
    for i_study = 1:numel(studies)  
        study = studies(i_study);
        for i = 1:numel(study.postPlot)
            figure(i)
            printResultsToTextFiles(study,study.postPlot(i))
            if isa(study.postPlot(i).addCommands,'function_handle')
                figure(i)
                study.postPlot(i).addCommands(study,i_study,studies)
            end
        end
    end 
end

