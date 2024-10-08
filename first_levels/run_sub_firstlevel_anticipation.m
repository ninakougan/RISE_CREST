function run_sub_firstlevel_anticipation(PID)
%% var set up
if nargin==0 % defaults just for testing 
    % Define some 
    PID = "50001"; 
    
end

overwrite = 1;
ses = 1;
run = 2;
ndummies = 0;

contrast = 'anticipation'; % consumption

% Define some paths
basedir = '/projects/b1108/studies/rise/data/processed/neuroimaging';

preproc_dir = fullfile(basedir, '/fmriprep/ses-1/smoothed_data');

numPID = num2str(PID);
PID = strcat('sub-',numPID);


fprintf(['Preparing 1st level model for ' PID ' / ' ses], ['Overwrite = ' num2str(overwrite)]);

%% Model for MID task. First pass at first levels --> activation
% FL directory for saving 1st level results: beta images, SPM.mat, contrasts, etc.
in{1} = {fullfile(basedir, '/august24_T1/fl/', PID, strcat('ses-',num2str(ses)), 'anticipation/', strcat('run-0', num2str(run)))};
%keyboard

% preproc images
in{2} = cellstr(spm_select('ExtFPList', preproc_dir, strcat('^ssub-',num2str(numPID),'_ses-',num2str(ses),'_task-mid_run-0',num2str(run),'_space-MNI152NLin2009cAsym_desc-preproc_bold.nii'), ndummies+1:9999));
%keyboard

if isempty(in{2}{1})
    warning('No preprocd functional found')
    return
end

% onset files
in{3} = filenames(fullfile(basedir, '/fmriprep/ses-1/spm_timing/', strcat(PID,'_ses-',num2str(ses),'_task-mid_run-0',num2str(run), '_timing_anticipation.mat')));
%keyboard

if isempty(in{3})
    warning('No modeling found (behav data might be missing)')
    return
end
%% nuisance covs

% fmriprep output
confound_fname = filenames(fullfile(basedir, '/fmriprep/ses-1/spm_confounds/', strcat(PID,'_ses-',num2str(ses),'_mid_run-0',num2str(run),'.mat')));
%keyboard 

in{4} = {confound_fname{1}};
%keyboard

% checks
if any(cellfun( @(x) isempty(x{1}), in))
    in
    error('Some input to the model is missing')
end

% check for SPM.mat and overwrite if needed

if exist(fullfile(in{1}{1},'SPM.mat'),'file')
    if overwrite
        fprintf('\n\nWARNING: EXISTING SPM.MATAND BETA FILES WILL BE OVERWRITTEN\n%s\n\n',fullfile(in{1}{1},'SPM.mat'));
        rmdir(in{1}{1},'s');
    else
        fprintf('\n\nFirst levels already exist, wont ovewrite: %s\n\n',fullfile(in{1}{1},'SPM.mat'));
        skip=1;
    end
end

% run spm FL estimation
cwd = pwd;
job = strcat('RISE_spm_anticipation_template.m');
%%
%keyboard
spm('defaults', 'FMRI')
spm_jobman('serial',job,'',in{:});