% addpath('/usr/local/AdvanpixMCT/4.6.0.13135')

addpath IGAfunctions
addpath(genpath('NURBS'))
addpath SEM
addpath(genpath('NURBSgeometries'))
addpath NURBSmeshes
addpath(genpath('utils'))
if ~exist('../e3Dss', 'dir')
    error('The e3Dss repository must be downloaded (can be obtained from GitHub: https://github.com/Zetison/e3Dss) and placed at the same level as ASIGA (as ../e3Dss)');
end
addpath(genpath('../e3Dss'))
addpath(genpath('postProcessing'))
addpath(genpath('examples'))
addpath(genpath('integration'))
addpath subRoutines
addpath(genpath('../export_fig'))
set(0,'DefaultLegendAutoUpdate','off')

folderName = '../../results/ASIGA';
if ~exist(folderName, 'dir')
    error('The folder in which results should be stored does not exist. Please make such a folder and alter the variable folderName in startup.m accordingly.')
end