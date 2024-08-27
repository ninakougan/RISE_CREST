scriptdir = '/home/nck1870/repos/RISE_CREST';
repodir = '/home/nck1870/repos';

% Directory containing the preprocessed data
directories = '/projects/b1108/studies/rise/data/processed/neuroimaging/fmriprep/ses-1';

% Task run and session parameters
run = 1;
ses = 1;

% Overwrite control: 1 overwrites, 0 adds to existing data
overwrite = 0;

% Length of participant IDs (e.g., 10234 has length 5)
ID_length = 5;

% List of files corresponding to the specific run and session
file_list = filenames(fullfile(directories, strcat('*/ses-', num2str(ses), '/func/sub*chatroom_run-0', num2str(run), '*preproc_bold.nii')));
sublist = cellfun(@(x) x(98:98+ID_length-1), file_list, 'UniformOutput', false);

% Initialize the list of new subjects to be processed
new_list = {};

if overwrite == 0
    % List of already smoothed subjects
    smooth_list = filenames(fullfile(directories, strcat('*/ses-', num2str(ses), '/func/ssub*chatroom_run-0', num2str(run), '*preproc_bold.nii')));
    
    % Identify unsmoothed subjects
    new_list = sublist(~ismember(sublist, cellfun(@(x) x(98:98+ID_length-1), smooth_list, 'UniformOutput', false)));
else
    % If overwriting, process all subjects
    new_list = sublist;
end

keyboard
% Run/submit batch script for each subject in new_list
cd(scriptdir)
for sub = 1:length(new_list)
    PID = new_list{sub};
    
    % Create the batch script for the current subject
    script_name = sprintf('smoothing_script_%s.sh', PID);
    s = sprintf(['#!/bin/bash\n\n'...
                 '#SBATCH -A p31589\n'...
                 '#SBATCH -p short\n'...
                 '#SBATCH -t 00:20:00\n'...  
                 '#SBATCH --mem=30G\n\n'...
                 'matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath(''%s'')); single_sub_smooth(''%s'', %d, %d, %d); quit"\n\n'], ...
                 repodir, PID, ses, run, overwrite);
   
    % Write and execute the batch script
    scriptfile = fullfile(scriptdir, script_name);
    fout = fopen(scriptfile, 'w');
    fprintf(fout, '%s', s);
    fclose(fout);
    
    system(['chmod 777 ', scriptfile]);
    system(['sbatch ', scriptfile]);
end
