% Define the top directory containing the preprocessed data
top_directory = '/projects/b1108/studies/rise/data/processed/neuroimaging/fmriprep';

% Specify the session, run numbers, and task
ses = 1;          % Adjust the session number as needed
run = 1;          % Adjust the run number as needed
task = 'chatroom'; % Set the task type; either 'chatroom' or 'mid'

% Initialize lists for smoothed subjects and new subjects
smoothed_list = {};
new_list = {};

% Construct the search pattern for the .nii files
search_pattern = fullfile(top_directory, ['ses-', num2str(ses)], 'sub-*', ['ses-', num2str(ses)], 'func', ...
    ['*task-', task, '_run-0', num2str(run), '_space-MNI152NLin2009cAsym_desc-preproc_bold.nii']);

% Get a list of all .nii files in the func/ folders for the specified session, run, and task
file_structs = dir(search_pattern);

% Check if files were found
if isempty(file_structs)
    disp('No .nii files found with the specified pattern.');
else
    disp(['Found ', num2str(length(file_structs)), ' .nii files.']);
end

% Iterate over each file in the list
for i = 1:length(file_structs)
    % Extract the full path and filename
    fullpath = fullfile(file_structs(i).folder, file_structs(i).name);
    [~, filename, ext] = fileparts(fullpath);
    filepath = file_structs(i).folder;
    
    % Extract the subject ID from the file path
    parts = strsplit(filepath, filesep);
    subject_id = parts{end-2};  % Extracts the subject folder name, e.g., 'sub-50001'
    
    % Define the smoothed file path with an 'ssub-' prefix
    smoothed_filename = ['ssub-', filename, ext];
    smoothed_file = fullfile(filepath, smoothed_filename);
    
    % Check if both the original and smoothed files exist
    if exist(fullpath, 'file') && exist(smoothed_file, 'file')
        smoothed_list{end+1} = subject_id;
        disp(['Subject already smoothed: ', subject_id]);
    else
        % Add to new_list only if no smoothed file exists
        if ~ismember(subject_id, new_list)
            new_list{end+1} = subject_id;
            disp(['Added to new_list: ', subject_id]);
        end
    end
end

% Display lists for verification
disp('Smoothed subjects:');
disp(smoothed_list);
disp('New subjects:');
disp(new_list);

% Run/submit batch script
keyboard
scriptdir = '/home/nck1870/repos/RISE_CREST';
repodir = '/home/nck1870/repos';
overwrite = 0; % Set overwrite option

cd(scriptdir)
for sub = 1:length(new_list)
    PID = new_list{sub};
    
    % Create the sbatch command for the current subject
    sbatch_command = sprintf(['#!/bin/bash\n'...
                              '#SBATCH -A p31589\n'...
                              '#SBATCH -p short\n'...
                              '#SBATCH -t 00:20:00\n'...  
                              '#SBATCH --mem=30G\n\n'...
                              'matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath(''%s'')); single_sub_smooth(''%s'', %d, %d, %d); quit"\n'], ...
                              repodir, PID, ses, run, overwrite);
    
    % Write or update the sbatch command in the smoothing_script.sh file
    scriptfile = fullfile(scriptdir, 'smoothing_script.sh');
    fout = fopen(scriptfile, 'w');
    fprintf(fout, sbatch_command);
    fclose(fout);
    
    % Make the script executable and submit it
    system(['chmod 777 ', scriptfile]);
    system(['sbatch ', scriptfile]);
end
