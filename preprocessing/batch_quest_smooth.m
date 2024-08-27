% Define the top directory containing the preprocessed data
top_directory = '/projects/b1108/studies/rise/data/processed/neuroimaging/fmriprep';

% Specify the session and run numbers
ses = 1;  % Adjust the session number as needed
run = 1;  % Adjust the run number as needed

% Initialize lists for all files, smoothed subjects, and new subjects
file_list = {};
smoothed_list = {};
new_list = {};

% Construct the search pattern for the .nii.gz files
search_pattern = fullfile(top_directory, ['ses-', num2str(ses)], 'sub-*', ['ses-', num2str(ses)], 'func', ['*run-0', num2str(run), '*bold.nii.gz']);
disp(['Looking for files with pattern: ', search_pattern]);

% Get a list of all .nii.gz files in the func/ folders for the specified session and run
file_list = dir(search_pattern);

% Iterate over each file in the list to categorize subjects
for i = 1:length(file_list)
    % Extract the full path and filename
    fullpath = fullfile(file_list(i).folder, file_list(i).name);
    [~, filename, ext] = fileparts(fullpath);
    filepath = file_list(i).folder;
    
    % Extract the subject ID from the file path
    parts = strsplit(filepath, filesep);
    subject_id = parts{end-2};  % Extracts the subject folder name, e.g., 'sub-50001'

    if startsWith(filename, 'ssub-')
        % If the file starts with "ssub-", mark the subject as smoothed
        if ~ismember(subject_id, smoothed_list)
            smoothed_list{end+1} = subject_id;
        end
    else
        % If the file does not start with "ssub-", check if the subject has a corresponding smoothed file
        smoothed_file = fullfile(filepath, ['ssub-', filename, ext]);
        if exist(smoothed_file, 'file')
            if ~ismember(subject_id, smoothed_list)
                smoothed_list{end+1} = subject_id;
            end
        else
            % Add to new_list only if no smoothed file exists
            if ~ismember(subject_id, new_list) && ~ismember(subject_id, smoothed_list)
                new_list{end+1} = subject_id;
            end
        end
    end
end

% Run/submit batch script for each subject in new_list
scriptdir = '/home/nck1870/repos/RISE_CREST';
repodir = '/home/nck1870/repos';
overwrite = 0; % Set overwrite option

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
