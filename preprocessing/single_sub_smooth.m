function smooth_single_sub(PID,ses,run,overwrite)
%% var set up
if nargin==0 % defaults just for testing
    PID = 50027;  
    overwrite = 1;
    ses = 1;
    run = 2;
end

preproc_dir = '/projects/b1108/studies/rise/data/processed/neuroimaging/fmriprep/ses-1';

if nargin==1
    overwrite = 1;
end  

PID = strcat('sub-',num2str(PID));
ndummies=0;
% FL directory for saving 1st level results: beta images, SPM.mat, etc.
% in{1} = {fullfile(fl_dir, PID, strcat('ses-',num2str(ses)), strcat('run-', num2str(run)), 'MID')};

rundir = fullfile(preproc_dir, strcat(PID, strcat('/ses-', num2str(ses)), '/func'));
%keyboard

in{1} = cellstr(spm_select('ExtFPList', rundir, strcat('.*task-mid_run-0',num2str(run),'_space-MNI152NLin2009cAsym_desc-preproc_bold.nii'), ndummies+1:9999));
%keyboard

if isempty(in{1}{1})
    warning('No preprocd functional found')
    return
end

jobfile = {'/home/nck1870/repos/dissertation_analyses/run_first_levels/smooth_template.m'};
jobs = 'smooth_template.m';


spm('defaults', 'FMRI');
spm_jobman('run', jobs, in{:});


end
