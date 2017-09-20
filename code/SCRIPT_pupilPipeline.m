%% SCRIPT performing processing of the entire pupil video.

% This analysis script makes the following assumptions: 
% 
% 1. all videos have already gone through the `convertRawToGray` stage. This is to
% save both processing time and hard drive space on analysis machines,
% since the gray videos are much smaller than the raw ones. The convertRawToGray
% stage was performed using this command for all sessions.
pupilPipelineWrapper(pathParams, 'lastStage', 'convertRawToGray')

% 2. an operator predetermined the optimal keyValuesPairs for the analysis
% using this function
testParams(pathParams, 'nFrames', 3000, 'glintFrameMask', [100 100 70 100])

% 3. some sessions will require custom keyValuePairs for different runs.
% This custom key values will be explicitely declared within the script.

% 4. session for which only LowRes Size calibration videos are available are 
% properly flagged.

%% Formatting convention for the custom keyValues
%  To make the script easier to read, we follow this convention for adding
%  customKeyValues.
% 
%  RUN-SPECIFIC CUSTOM KEY VALUES
%  These will be listed in a cell array in the order they will be used by
%  the pipeline stages, each on its own line, like this:
%       customKeyValue1 = {RUN NAMES, ...
%           findGlint CUSTOM PARAMETERS ...
%           findPupilPerimeter CUSTOM PARAMETERS ...
%           makeControlFile CUSTOM PARAMETERS ...
%           fitPupilPerimeter CUSTOM PARAMETERS};
%       customKeyValue2 =  { .... } ;
%       customKeyValues = {customKeyValue1; customKeyValue2};
% 
%  SESSION-SPECIFIC CUSTOM KEY VALUES
%  Custom key values referred to the whole session  will be added as
%  options in the call to pupilPipelineWrapper. The last optional params
%  assigned to pupilPipelineWrapper should be customKeyValues. 
%  For example:
%        pupilPipelineWrapper(pathParams, ...
%           'skipStage', {'convertRawToGray'}, ...
%           'customKeyValues', customKeyValues);
% 

%% Common to all script lines to define the dropbox directories

% set dropbox directory
[~,hostname] = system('hostname');
hostname = strtrim(lower(hostname));
if strcmp(hostname,'melchior.uphs.upenn.edu') %melchior has some special dropbox folder settings
    dropboxDir = '/Volumes/Bay_2_data/giulia/Dropbox-Aguirre-Brainard-Lab';
else % other machines use the standard dropbox location
    [~, userName] = system('whoami');
    userName = strtrim(userName);
    dropboxDir = ...
        fullfile('/Users', userName, ...
        '/Dropbox (Aguirre-Brainard Lab)');
end

% set common path params
pathParams.dataSourceDirRoot = fullfile(dropboxDir,'TOME_data');
pathParams.dataOutputDirRoot = fullfile(dropboxDir,'TOME_processing');
pathParams.controlFileDirRoot = fullfile(dropboxDir,'TOME_processing');
pathParams.eyeTrackingDir = 'EyeTracking';


%% SESSION 1 HERE
pathParams.projectSubfolder = 'session1_restAndStructure';

% TOME_3001 session1 - good
pathParams.subjectID = 'TOME_3001';
pathParams.sessionDate = '081916';
customKeyValue1 = {'rfMRI_REST_*', ...
    'glintFrameMask',[60 100 90 80], ...
    'exponentialTauParams', [.25, .25, 10, 1, 1],'likelihoodErrorExponent',[1.25 1.25 2 2 2]};
customKeyValue2 = {'LowResScaleCal*', ...
    'pupilFrameMask', [70 50 70 100]};
customKeyValue3 = {{'dMRI_dir99_PA*','dMRI_dir98*','T1*','T2*'}, ...
    'glintFrameMask',[110 100 70 100]};
customKeyValue4 = {'dMRI_dir99_AP', ...
    'glintFrameMask',[130 100 70 100]};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4};
pupilPipelineWrapper(pathParams, ...
    'pupilRange', [20 90], 'pupilCircleThresh', 0.035, 'pupilGammaCorrection', .50, ...
    'useLowResSizeCalVideo',true,'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3002 session1 - good
pathParams.subjectID = 'TOME_3002';
pathParams.sessionDate = '082616';
customKeyValue1 = {{'T1*', 'T2*'}, ...
    'glintFrameMask',[110 110 70 110], ...
    'pupilRange', [30 90], 'pupilCircleThresh', 0.03, 'pupilGammaCorrection', .5};
customKeyValue2 = {'rfMRI_REST_*', ...
    'glintFrameMask',[85 100 90 80], ...
    'maskBox', [.8 1.5],'pupilGammaCorrection', 1.3, 'pupilRange', [50 150] ...
    'exponentialTauParams', [.25, .25, 10, 1, 1] };
customKeyValue3 = {'dMRI_*', ...
    'glintFrameMask',[100 110 90 110] };
customKeyValue4 = {'*ScaleCal*', ...
    'pupilFrameMask', [50 30]};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4};
pupilPipelineWrapper(pathParams, ...
    'useLowResSizeCalVideo',true, 'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3003 session1
pathParams.subjectID = 'TOME_3003';
pathParams.sessionDate = '090216';
customKeyValue1 = {{'rfMRI_REST_AP_run01*','rfMRI_REST_AP_run03*','rfMRI_REST_PA_run02_*'} ...
    'glintFrameMask',[70 70 95 100], ...
    'pupilRange', [50 100], 'pupilCircleThresh', 0.05, 'pupilGammaCorrection', 1.3, ...
    'exponentialTauParams', [.25, .25, 10, 1, 1]};
customKeyValue2 = {'rfMRI_REST_AP_run04*', ...
    'glintFrameMask',[60 70 130 100], ...
    'pupilRange', [50 100], 'pupilCircleThresh', 0.05, 'pupilGammaCorrection', 1.3, ...
    'exponentialTauParams', [.25, .25, 10, 1, 1]};
customKeyValue3 = {{'LowResScaleCalibration_3Mm*','LowResScaleCalibration_4Mm*'}, ...
    'pupilFrameMask', [70 50 90 100], 'pupilGammaCorrection',1,'pupilRange',[40 90]};
customKeyValue4 = {'LowResScaleCalibration_5Mm*', ...
    'pupilFrameMask', [70 50 70 100], 'pupilGammaCorrection',1,'pupilRange',[40 90]};
customKeyValue5 = {{'dMRI__dir98*','T1*','T2*'}, ...
    'glintFrameMask',[90 80 100 90] ...
    'pupilRange', [30 100], 'pupilCircleThresh', 0.05, 'pupilGammaCorrection', 1.3};
customKeyValue6 = {'dMRI__dir99*', ...
    'glintFrameMask',[60 80 120 90] ...
    'pupilRange', [30 100], 'pupilCircleThresh', 0.05, 'pupilGammaCorrection', 1.3};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4;  customKeyValue5; customKeyValue6};
pupilPipelineWrapper(pathParams, ...
    'useLowResSizeCalVideo',true, 'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3004 session1 A - good
pathParams.subjectID = 'TOME_3004';
pathParams.sessionDate = '091916';
customKeyValue1 = {'LowResScaleCal*', ...
    'pupilCircleThresh', 0.02, 'pupilRange', [20 60], 'pupilFrameMask', [60 40],'perimeterColor','r'};
customKeyValue2 = {'rfMRI_REST_*', ...
    'glintFrameMask',[40 100 110 130], ...
    'pupilRange', [30 100], 'pupilGammaCorrection', 1.8, ...
    'exponentialTauParams', [.25, .25, 10, 1, 1], 'likelihoodErrorExponent',[1.25 1.25 2 2 2]};
customKeyValue3 = {'dMRI_*', ...
    'glintFrameMask', [30 110 140 130], ...
    'pupilRange', [30 100], 'pupilCircleThresh', 0.05};
customKeyValue4 = {{'T1_*','T2_*'}, ...
    'glintFrameMask', [25 110 150 130], ...
    'pupilRange', [30 100], 'pupilCircleThresh', 0.05};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4};
pupilPipelineWrapper(pathParams, ...
    'useLowResSizeCalVideo',true, 'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3004 session1 B
pathParams.subjectID = 'TOME_3004';
pathParams.sessionDate = '101416';
customKeyValue1 = {'LowResScaleCal*', 'pupilCircleThresh', 0.02,'pupilRange', [10 60], 'pupilFrameMask', [60 40],'perimeterColor','r'};
customKeyValue2 = {'rfMRI_REST_*', 'pupilRange', [30 100], 'pupilCircleThresh', 0.05, 'exponentialTauParams', [.25, .25, 10, 1, 1], 'glintFrameMask', [30 80 90 90]};
customKeyValue3 = {'GazeCal*', 'pupilRange', [30 100], 'pupilCircleThresh', 0.05, 'glintFrameMask', [40 60 120 100]};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3};
pupilPipelineWrapper(pathParams, ...
    'useLowResSizeCalVideo',true, 'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3005 session1
pathParams.subjectID = 'TOME_3005';
pathParams.sessionDate = '092316';
customKeyValue1 = {'rfMRI_REST_*','exponentialTauParams', [.25, .25, 10, 1, 1], 'likelihoodErrorExponent',[1.25 1.25 2 2 2], 'glintFrameMask', [20 120 80 80]};
customKeyValue2 = {'dMRI_*', 'glintFrameMask',[90 110 50 100],'pupilFrameMask', [50 50],'ellipseTransparentLB',[0, 0, 300, 0, -0.5*pi]};
customKeyValue3 = {{'T1_*','T2_*'}, 'glintFrameMask',[120 110 70 100],'pupilFrameMask', [50 50],'ellipseTransparentLB',[0, 0, 300, 0, -0.5*pi]};
customKeyValue4 = {'*ScaleCal*', 'pupilFrameMask', [50 50],'pupilGammaCorrection', 1,'pupilCircleThresh', 0.03};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4};
pupilPipelineWrapper(pathParams, ...
    'pupilRange', [30 100], ...
    'useLowResSizeCalVideo',true, 'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3007 session1
pathParams.subjectID = 'TOME_3007';
pathParams.sessionDate = '101116';
% REST RUNS NOT TRACKED GREAT: low contrast between iris and pupil.
customKeyValue1 = {'rfMRI_REST_*','exponentialTauParams', [.25, .25, 10, 1, 1],  'likelihoodErrorExponent',[1.25 1.25 2 2 2],...
    'glintFrameMask', [30 80 80 70], ...
    'pupilFrameMask', [20 70],'pupilGammaCorrection', 0.6,'pupilCircleThresh', 0.05,'maskBox', [0.5 0.8]};
customKeyValue2 = {'GazeCal*','glintFrameMask', [55 100 140 100], ...
    'pupilGammaCorrection', 1.4,'pupilCircleThresh', 0.05,'maskBox', [0.7 1]};
customKeyValue3 = {{'dMRI_dir98_AP*', 'dMRI_dir99_AP*'}, 'glintFrameMask',[30 100 150 100], ...
    'pupilGammaCorrection', 1.4,'pupilCircleThresh', 0.05,'maskBox', [0.7 1]};
customKeyValue4 = {{'dMRI_dir98_PA*','dMRI_dir99_PA*'}, 'glintFrameMask',[65 100 130 100], ...
    'pupilGammaCorrection', 1.4,'pupilCircleThresh', 0.05,'maskBox', [0.7 1]};
customKeyValue5 = {'T1_*', 'glintFrameMask',[85 100 110 100], ...
    'pupilGammaCorrection', 1.4,'pupilCircleThresh', 0.05,'maskBox', [0.7 1]};
customKeyValue6 = {'T2_*','glintFrameMask',[55 100 140 100], ...
    'pupilGammaCorrection', 1.4,'pupilCircleThresh', 0.05,'maskBox', [0.7 1]};
customKeyValue7 = {'*ScaleCal*', 'pupilFrameMask', [55 100 14 10]};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4; customKeyValue5; customKeyValue6; customKeyValue7};
pupilPipelineWrapper(pathParams, ...
    'useLowResSizeCalVideo',true, 'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3008 session1
pathParams.subjectID = 'TOME_3008';
pathParams.sessionDate = '102116';
customKeyValue1 = {'rfMRI_REST_*','exponentialTauParams', [.25, .25, 10, 1, 1], ...
    'glintFrameMask', [10 60 30 100], ...
    'maskBox', [.8 1.5],'pupilGammaCorrection', 1.3, 'pupilRange', [50 150]};
customKeyValue2 = {'GazeCal*','glintFrameMask', [10 70 110 100]};
customKeyValue3 = {'dMRI_*', 'glintFrameMask',[10 70 110 100]};
customKeyValue4 = {'T1_*', 'glintFrameMask',[10 70 110 100]};
customKeyValue5 = {'T2_*','glintFrameMask',[10 70 110 100]};
customKeyValue6 = {'*ScaleCal*', 'pupilFrameMask', [30 30]};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4; customKeyValue5; customKeyValue6};
pupilPipelineWrapper(pathParams, ...
    'useLowResSizeCalVideo',true, 'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3009 session1
pathParams.subjectID = 'TOME_3009';
pathParams.sessionDate = '100716';
customKeyValue1 = {'rfMRI_REST_*','exponentialTauParams', [.25, .25, 10, 1, 1]};
customKeyValues = {customKeyValue1};
pupilPipelineWrapper(pathParams, ...
    'pupilCircleThresh', 0.04, 'pupilGammaCorrection', .75, ...
    'useLowResSizeCalVideo',true, 'skipStage', {'convertRawToGray'}, ...
    'glintFrameMask',[50 70 60 130], ...
    'customKeyValues', customKeyValues);

% TOME_3011 session1
pathParams.subjectID = 'TOME_3011';
pathParams.sessionDate = '111116';
customKeyValue1 = {'T1*','pupilRange', [40 120], 'pupilCircleThresh', 0.07,'glintFrameMask', [20 90 70 80]};
customKeyValue2 = {'T2*','pupilRange', [40 120], 'pupilCircleThresh', 0.07,'glintFrameMask', [20 90 70 80]};
customKeyValue3 = {'rfMRI_REST_*', 'pupilRange', [50 150], 'pupilCircleThresh', 0.06, 'exponentialTauParams', [.25, .25, 10, 1, 1]};
customKeyValue4 = {'dMRI*','pupilRange', [40 120], 'pupilCircleThresh', 0.07,'glintFrameMask', [20 90 70 80]};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4};
pupilPipelineWrapper(pathParams, ...
    'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3013 session1
pathParams.subjectID = 'TOME_3013';
pathParams.sessionDate = '121216';
customKeyValue1 = {'GazeCal','pupilRange', [20 120], 'pupilCircleThresh', 0.03, 'pupilGammaCorrection', .5,'glintFrameMask', [20 90 70 80]};
customKeyValue2 = {'rfMRI_REST_*','pupilRange', [20 200], 'pupilCircleThresh', 0.03, 'exponentialTauParams', [.25, .25, 10, 1, 1],'glintFrameMask', [20 100 70 60]};
customKeyValue3 = {'dMRI_*', 'glintFrameMask',[20 90 70 80]};
customKeyValue4 = {'T1_', 'glintFrameMask',[20 90 70 80]};
customKeyValue5 = {'T2_','glintFrameMask',[20 90 70 80]};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4; customKeyValue5};
pupilPipelineWrapper(pathParams, ...
    'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3014 session1
pathParams.subjectID = 'TOME_3014';
pathParams.sessionDate = '021517';
customKeyValue1 = {'rfMRI_REST_*','exponentialTauParams', [.25, .25, 10, 1, 1],'glintFrameMask', [20 40 80 100]};
customKeyValue2 = {'GazeCal*','glintFrameMask', [20 90 70 80]};
customKeyValue3 = {'dMRI_*', 'glintFrameMask',[20 90 70 80]};
customKeyValue4 = {'T1_', 'glintFrameMask',[20 90 70 80]};
customKeyValue5 = {'T2_','glintFrameMask',[20 90 70 80]};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4; customKeyValue5};
pupilPipelineWrapper(pathParams, ...
    'pupilRange', [30 280], 'pupilCircleThresh', 0.03, ...
    'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3015 session1
pathParams.subjectID = 'TOME_3015';
pathParams.sessionDate = '030117';
%for calibration runs
customKeyValue1 = {'*Cal*', 'pupilRange', [20 180], 'pupilCircleThresh', 0.05,'glintFrameMask',[60 60 80 100]};
customKeyValue2 = {'T1*', 'pupilRange', [30 200], 'pupilCircleThresh', 0.04,'glintFrameMask',[60 60 80 100]};
customKeyValue3 = {'T2*', 'pupilRange', [30 200], 'pupilCircleThresh', 0.04,'glintFrameMask',[60 60 80 100]};
customKeyValue4 = {'dMRI_*', 'pupilRange', [20 200], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', 1,'glintFrameMask',[60 60 80 100]};
customKeyValue5 = {'rfMRI_REST_*','exponentialTauParams', [.25, .25, 10, 1, 1],'glintFrameMask',[50 80 40 90]};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4; customKeyValue5};
pupilPipelineWrapper(pathParams, ...
    'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3016 session1
pathParams.subjectID = 'TOME_3016';
pathParams.sessionDate = '031017';
customKeyValue1 = {'RawScaleCal*', 'pupilGammaCorrection', .7,'pupilFrameMask', [60 40],'glintFrameMask', [70 60 80 150]};
customKeyValue2 = {'GazeCal*', 'pupilGammaCorrection', .7,'cutErrorThreshold', 35};
customKeyValue3 = {'T1*', 'pupilGammaCorrection', 1,'glintFrameMask', [70 60 80 150],'cutErrorThreshold', 25};
customKeyValue4 = {'T2*', 'pupilGammaCorrection', 1,'glintFrameMask', [70 60 80 150],'cutErrorThreshold', 25};
customKeyValue5 = {'dMRI_*', 'pupilGammaCorrection', 1,'glintFrameMask', [70 60 80 150],'cutErrorThreshold', 25};
customKeyValue6 = {'rfMRI_REST_*', ...
    'pupilRange', [30 330], 'pupilCircleThresh', 0.06, 'pupilGammaCorrection', 1,...
    'glintFrameMask',[70 80 70 120], ...
    'cutErrorThreshold', 27,  'exponentialTauParams',[.25 .25 10 1 1],...
    'likelihoodErrorExponent',[1.25 1.25 2 2 2], 'ellipseTransparentUB', [320 240 10000 0.35 0.5*pi], ...
    'constrainEccen_x_Theta', [0.35 0.35]};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4; customKeyValue5; customKeyValue6};
pupilPipelineWrapper(pathParams, ...
    'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3017 session1
pathParams.subjectID = 'TOME_3017';
pathParams.sessionDate = '032917';
customKeyValue1 = {'*ScaleCal*', 'pupilRange', [20 100], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', 1.3,'pupilFrameMask', [2 30]};
customKeyValue2 = {'GazeCal*', 'pupilRange', [30 100], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', .7,'cutErrorThreshold', 40, 'glintFrameMask', [20 50 110 160]};
customKeyValue3 = {'T1*', 'pupilRange', [30 150], 'pupilCircleThresh', 0.03,'cutErrorThreshold',30, 'glintFrameMask', [20 50 110 160]};
customKeyValue4 = {'T2*', 'pupilRange', [30 150], 'pupilCircleThresh', 0.03, 'cutErrorThreshold',30, 'glintFrameMask', [20 50 110 160]};
customKeyValue5 = {'rfMRI_REST_*', 'pupilRange', [30 180], 'pupilCircleThresh', 0.03, 'pupilGammaCorrection', .75,'pupilFrameMask', [2 40],'glintFrameMask', [10 80 90 100],'cutErrorThreshold',30, ...
    'exponentialTauParams',[.25 .25 10 1 1],'likelihoodErrorExponent',[1.25 1.25 2 2 2], 'ellipseTransparentUB', [320 240 10000 0.35 0.5*pi],'constrainEccen_x_Theta', [0.35 0.35]};
customKeyValue6 = {'dMRI_*', 'pupilRange', [30 150], 'pupilCircleThresh', 0.03,'cutErrorThreshold',30, 'glintFrameMask', [20 50 110 160] };
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4; customKeyValue5; customKeyValue6};
pupilPipelineWrapper(pathParams, ...
    'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3018 session1 -- first date
pathParams.subjectID = 'TOME_3018';
pathParams.sessionDate = '040717';
customKeyValue1 = {'*Cal*', 'pupilRange', [15 100], 'pupilCircleThresh', 0.03, 'glintFrameMask', [40 80 60 100]};
customKeyValue2 = {'dMRI_*', 'pupilRange', [15 100], 'pupilCircleThresh', 0.03,'glintFrameMask', [40 80 60 100]};
customKeyValue3 = {'rfMRI_REST_*', 'glintFrameMask', [40 80 60 80],...
    'pupilRange', [15 200], 'pupilCircleThresh', 0.05,...
    'exponentialTauParams', [.25, .25, 10, 1, 1]};
customKeyValue4 = {'T1*', 'glintFrameMask', [40 80 60 100]};
customKeyValue5 = {'T2*', 'glintFrameMask', [40 80 60 100]};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4; customKeyValue5};
pupilPipelineWrapper(pathParams, ...
    'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3018 session1 -- second date
pathParams.subjectID = 'TOME_3018';
pathParams.sessionDate = '041817';
customKeyValue1 = {'*Cal*', 'pupilRange', [10 100], 'pupilCircleThresh', 0.03, 'glintFrameMask', [40 60 60 110]};
customKeyValue2 = {'dMRI_*', 'pupilRange', [10 100], 'pupilCircleThresh', 0.03, 'glintFrameMask', [40 60 60 110]};
customKeyValue3 = {'rfMRI_REST_*', 'glintFrameMask', [40 60 60 110] ...
    'pupilRange', [10 140], 'pupilCircleThresh', 0.04, 'exponentialTauParams', [.25, .25, 10, 1, 1]};
customKeyValue4 = {'T1*', 'glintFrameMask', [40 70 80 100]};
customKeyValue5 = {'T2*', 'glintFrameMask', [40 60 60 110]};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4; customKeyValue5};
pupilPipelineWrapper(pathParams, ...
    'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3019 session1
pathParams.subjectID = 'TOME_3019';
pathParams.sessionDate = '042617a';
customKeyValue1 = {'rfMRI_REST_*','exponentialTauParams', [.25, .25, 10, 1, 1]};
customKeyValues = {customKeyValue1};
pupilPipelineWrapper(pathParams, ...
    'pupilCircleThresh', 0.04, ...
    'glintFrameMask', [60 40 50 130], ...
    'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3020 session1
pathParams.subjectID = 'TOME_3020';
pathParams.sessionDate = '042817';
customKeyValue1 = {'*Cal*', 'pupilRange', [15 180], 'pupilCircleThresh', 0.05, 'glintFrameMask', [70 60 40 110]};
customKeyValue2 = {'T1*', 'pupilRange', [15 180], 'pupilCircleThresh', 0.05, 'glintFrameMask', [70 60 40 110]};
customKeyValue3 = {'T2*', 'pupilRange', [15 180], 'pupilCircleThresh', 0.05, 'glintFrameMask', [70 60 40 110]};
customKeyValue4 = {'dMRI_*', 'pupilRange', [15 180], 'pupilCircleThresh', 0.05, 'glintFrameMask', [70 60 40 110]};
customKeyValue5 = {'rfMRI_REST_*', 'glintFrameMask', [70 60 40 110], ...
    'pupilRange', [40 300], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', .5,'exponentialTauParams', [.25, .25, 10, 1, 1]};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4; customKeyValue5};
pupilPipelineWrapper(pathParams, ...
    'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3021 session1
pathParams.subjectID = 'TOME_3021';
pathParams.sessionDate = '060717';
customKeyValue1 = {'*Cal*', 'pupilCircleThresh', 0.04, 'glintFrameMask', [80 80 10 90]};
customKeyValue2 = {'rfMRI_REST_*', 'glintFrameMask',  [70 110 40 70], ...
    'pupilCircleThresh', 0.04, 'likelihoodErrorExponent', [1.25 1.25 2 2 2],'exponentialTauParams', [.25, .25, 10, 1, 1]};
customKeyValues = {customKeyValue1; customKeyValue2};
pupilPipelineWrapper(pathParams, ...
    'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

% TOME_3022 session1
pathParams.subjectID = 'TOME_3022';
pathParams.sessionDate = '061417';
customKeyValue1 = {'*Cal*', 'pupilCircleThresh', 0.04, 'glintFrameMask',  [80 60 50 130]};
customKeyValue2 = {'T1*', 'pupilCircleThresh', 0.03, 'glintFrameMask',  [80 60 50 130]};
customKeyValue3 = {'T2*', 'pupilCircleThresh', 0.03, 'glintFrameMask',  [80 60 50 130]};
customKeyValue4 = {'dMRI_*', 'pupilCircleThresh', 0.03, 'glintFrameMask',  [80 60 50 130]};
customKeyValue5 = {'rfMRI_REST_*', 'glintFrameMask',  [30 60 50 110], ...
    'pupilRange', [30 400], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', 1,...
    'exponentialTauParams', [.25, .25, 10, 1, 1], 'likelihoodErrorExponent', [1.25 1.25 2 2 2]};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3; customKeyValue4; customKeyValue5};
pupilPipelineWrapper(pathParams, ...
    'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);



%% SESSION 2 HERE
pathParams.projectSubfolder = 'session2_spatialStimuli';

%TOME_3001 session2
pathParams.subjectID = 'TOME_3001';
pathParams.sessionDate = '081916';
pupilPipelineWrapper(pathParams, ...
    'pupilRange', [30 200], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', .75, ...
    'glintFrameMask',[70 100 70 100], ...
    'useLowResSizeCalVideo',true,'skipStage', {'convertRawToGray'});

%TOME_3002 session2
pathParams.subjectID = 'TOME_3002';
pathParams.sessionDate = '082616';
pupilPipelineWrapper(pathParams, ...
    'glintFrameMask', [100 140 80 80], ...
    'pupilRange', [30 200], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', .75, ...
    'useLowResSizeCalVideo',true,'skipStage', {'convertRawToGray'});

%TOME_3003 session2
pathParams.subjectID = 'TOME_3003';
pathParams.sessionDate = '091616';
pupilPipelineWrapper(pathParams, ...
    'glintFrameMask', [100 110 40 80], ...
    'pupilRange', [30 200], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', .75, ...
    'useLowResSizeCalVideo',true,'skipStage', {'convertRawToGray'});

%TOME_3004 session2
pathParams.subjectID = 'TOME_3004';
pathParams.sessionDate = '101416';
customKeyValue1 = {'*Cal*', 'pupilRange', [20 200], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', .75};
customKeyValue2 = {'tfMRI_*', 'pupilRange', [20 180], 'pupilCircleThresh', 0.03, 'pupilGammaCorrection', .5};
customKeyValues = {customKeyValue1; customKeyValue2};
pupilPipelineWrapper(pathParams, ...
    'glintFrameMask', [85 65 75 140], ...
    'useLowResSizeCalVideo',true, 'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

%TOME_3005 session2
pathParams.subjectID = 'TOME_3005';
pathParams.sessionDate = '100316';
pupilPipelineWrapper(pathParams, ...
    'pupilRange', [20 180], 'pupilCircleThresh', 0.07, 'pupilGammaCorrection', .5, ...
    'useLowResSizeCalVideo',true,'skipStage', {'convertRawToGray'});

%TOME_3007 session2
pathParams.subjectID = 'TOME_3007';
pathParams.sessionDate = '101716';
customKeyValue1 = {'*Cal*', 'pupilRange', [20 140], 'pupilCircleThresh', 0.02, 'pupilGammaCorrection', .5};
customKeyValue2 = {'tfMRI_*', 'pupilRange', [30 240], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', .75};
customKeyValues = {customKeyValue1; customKeyValue2};
pupilPipelineWrapper(pathParams, ...
    'glintFrameMask', [40 20 20 20], ...
    'useLowResSizeCalVideo',true, 'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

%TOME_3008 session2
pathParams.subjectID = 'TOME_3008';
pathParams.sessionDate = '103116';
customKeyValue1 = {'RawScaleCal*', 'pupilRange', [15 100], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', .75, 'ellipseTransparentLB',[0, 0, 500, 0, -0.5*pi],'perimeterColor','r'};
customKeyValue2 = {'GazeCal*', 'pupilRange', [30 260], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', 0.75, 'glintGammaCorrection', 2.5,'glintRange', [10 40]};
customKeyValue3 = {'tfMRI_*', 'pupilRange', [30 260], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', .75};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3};
pupilPipelineWrapper(pathParams, ...
    'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

%TOME_3009 session2
pathParams.subjectID = 'TOME_3009';
pathParams.sessionDate = '102516';
customKeyValue1 = {'*Cal*', 'pupilRange', [15 250], 'pupilCircleThresh', 0.05, 'pupilGammaCorrection', .75};
customKeyValue2 = {'tfMRI_*', 'pupilRange', [30 250], 'pupilCircleThresh', 0.03, 'pupilGammaCorrection', .75};
customKeyValues = {customKeyValue1; customKeyValue2};
pupilPipelineWrapper(pathParams, ...
    'useLowResSizeCalVideo',true, 'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

%TOME_3011 session2
pathParams.subjectID = 'TOME_3011';
pathParams.sessionDate = '012017';
pupilPipelineWrapper(pathParams, ...
    'pupilRange', [20 180], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', .75, ...
    'skipStage', {'convertRawToGray'});

%TOME_3012 session2
pathParams.subjectID = 'TOME_3012';
pathParams.sessionDate = '020317';
pupilPipelineWrapper(pathParams, ...
    'pupilRange', [20 250], 'pupilCircleThresh', 0.03, 'pupilGammaCorrection', .75, ...
    'skipStage', {'convertRawToGray'});

%TOME_3013 session2
pathParams.subjectID = 'TOME_3013';
pathParams.sessionDate = '011117';
customKeyValue1 = {'RawScaleCal*', 'pupilRange', [20 200], 'pupilCircleThresh', 0.03, 'pupilGammaCorrection', .7};
customKeyValue2 = {'GazeCal*', 'pupilRange', [20 250], 'pupilCircleThresh', 0.03, 'pupilGammaCorrection', .75};
customKeyValue3 = {'tfMRI_*', 'pupilRange', [20 250], 'pupilCircleThresh', 0.03, 'pupilGammaCorrection', .75};
customKeyValues = {customKeyValue1; customKeyValue2; customKeyValue3};
pupilPipelineWrapper(pathParams, ...
    'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

%TOME_3014 session2
pathParams.subjectID = 'TOME_3014';
pathParams.sessionDate = '021717';
pupilPipelineWrapper(pathParams, ...
    'pupilRange', [30 250], 'pupilCircleThresh', 0.03, 'pupilGammaCorrection', .75, ...
    'skipStage', {'convertRawToGray'});

%TOME_3015 session2
pathParams.subjectID = 'TOME_3015';
pathParams.sessionDate = '032417';
pupilPipelineWrapper(pathParams, ...
    'pupilRange', [20 200], 'pupilCircleThresh', 0.05, 'pupilGammaCorrection', 1,'glintFrameMask', [30 5], ...
    'skipStage', {'convertRawToGray'});

%TOME_3016 session2
pathParams.subjectID = 'TOME_3016';
pathParams.sessionDate = '032017';
pupilPipelineWrapper(pathParams, ...
    'pupilRange', [20 200], 'pupilCircleThresh', 0.02, 'pupilGammaCorrection', 1, ...
    'skipStage', {'convertRawToGray'});

%TOME_3017 session2
pathParams.subjectID = 'TOME_3017';
pathParams.sessionDate = '033117';
customKeyValue1 = {'*Cal*', 'pupilRange', [20 200], 'pupilCircleThresh', 0.02, 'pupilGammaCorrection', 1};
customKeyValue2 = {'tfMRI_*', 'pupilRange', [20 180], 'pupilCircleThresh', 0.03, 'pupilGammaCorrection', .75};
customKeyValues = {customKeyValue1; customKeyValue2};
pupilPipelineWrapper(pathParams, ...
    'skipStage', {'convertRawToGray'}, ...
    'customKeyValues', customKeyValues);

%TOME_3019 session2
pathParams.subjectID = 'TOME_3019';
pathParams.sessionDate = '050317';
pupilPipelineWrapper(pathParams, ...
    'pupilRange', [30 100], 'pupilCircleThresh', 0.02, 'pupilGammaCorrection', .3, ...
    'skipStage', {'convertRawToGray'});

% TOME_3020 session2
pathParams.eyeTrackingDir = 'EyeTracking';
pathParams.subjectID = 'TOME_3020';
pathParams.sessionDate = '050517';
pupilPipelineWrapper(pathParams, ...
    'pupilRange', [20 120], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', 1.5, ...
    'skipStage', {'convertRawToGray'});

% TOME_3021 session2
pathParams.subjectID = 'TOME_3021';
pathParams.sessionDate = '060917';
pupilPipelineWrapper(pathParams, ...
    'pupilRange', [20 90], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', 1.5, ...
    'skipStage', {'convertRawToGray'});

% TOME_3022 session2
pathParams.subjectID = 'TOME_3022';
pathParams.sessionDate = '061617';
pupilPipelineWrapper(pathParams, ...
    'pupilRange', [20 90], 'pupilCircleThresh', 0.04, 'pupilGammaCorrection', 1.5, ...
    'ellipseTransparentLB',[0, 0, 500, 0, -0.5*pi], ...
    'skipStage', {'convertRawToGray'});
