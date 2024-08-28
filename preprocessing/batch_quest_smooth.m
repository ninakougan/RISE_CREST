% 1. Set Up Directories and Parameters
scriptdir = '/home/nck1870/repos/RISE_CREST';
repodir = '/home/nck1870/repos';
directories = '/projects/b1108/studies/rise/data/processed/neuroimaging/fmriprep/ses-1';
run = 1; % Specify run number
ses = 1; % Specify session number
task = 'chatroom'; % Specify task ('chatroom' or 'mid')
overwrite = 0; % 0 = don't overwrite, 1 = overwrite

% Initialize lists
new_list = {};
smoothed_list = {};

% 2. Iterate Over Subjects and Check for Smoothed Files
file_structs = dir(fullfile(directories, 'sub-*/ses-*/func', ...
    ['sub-*', '_ses-', num2str(ses), '_task-', task, '_run-0', num2str(run), ...
    '_space-MNI152NLin2009cAsym_desc-preproc_bold.*']));

for i = 1:length(file_structs)
    % Extract the full path and filename of the file
    fullpath = fullfile(file_structs(i).folder, file_structs(i).name);
    [~, filename, ext] = fileparts(fullpath);
    filepath = file_structs(i).folder;
    
    % Extract the subject ID from the filename
    subject_id = regexp(filename, 'sub-\d+', 'match', 'once');
    
    % Define the smoothed file path with an 'ssub-' prefix
    smoothed_filename = fullfile(filepath, ['ssub-', filename, ext]);
    
    % Debugging: Display the subject ID and file paths being checked
    disp(['Checking subject: ', subject_id]);
    disp(['Original file: ', fullpath]);
    disp(['Smoothed file: ', smoothed_filename]);

    % Check if the smoothed file exists
    if exist(smoothed_filename, 'file')
        % The subject has already been smoothed
        disp('Smoothed file exists. Adding to smoothed_list.');
        smoothed_list{end+1} = subject_id;
        continue; % Skip the rest of the script for this subject
    end

    % If no smoothed file exists, add the subject to new_list
    disp('No smoothed file found. Adding to new_list.');
    new_list{end+1} = subject_id;

    % Define the nii file path
    nii_file = fullfile(filepath, [filename, '.nii']);
    
    % Check if the .nii file exists
    if ~exist(nii_file, 'file')
        % If .nii does not exist, check for .nii.gz and unzip it
        gz_file = fullfile(filepath, [filename, '.gz']);
        if exist(gz_file, 'file')
            disp(['Unzipping file: ', gz_file]);
            gunzip(gz_file);
            % Verify that .nii file was created
            if exist(nii_file, 'file')
                disp(['Successfully created: ', nii_file]);
            else
                warning(['Failed to create .nii file for subject: ', subject_id]);
                % Optionally, you could remove from new_list if .nii could not be created
                % new_list(strcmp(new_list, subject_id)) = [];
                continue; % Skip this subject if the .nii file could not be created
            end
        else
            % If neither .nii nor .nii.gz files exist, skip to the next file
            disp(['No .nii or .nii.gz file found for subject: ', subject_id]);
            % Optionally, you could remove from new_list if no file was found
            % new_list(strcmp(new_list, subject_id)) = [];
            continue;
        end
    end

    % At this point, the .nii file should exist if it was created
end

% Remove duplicates from new_list and smoothed_list (optional)
new_list = unique(new_list);
smoothed_list = unique(smoothed_list);

% Debugging: Display the final lists
disp('Subjects to be smoothed (new_list):');
disp(new_list);

disp('Subjects that have been smoothed (smoothed_list):');
disp(smoothed_list);

% 3. Run/Submit Batch Script
keyboard
cd(scriptdir)
for sub = 1:length(new_list)
    PID = new_list{sub};

    % Define the sbatch script content
    s = ['#!/bin/bash\n\n'...
        '#SBATCH -A p31589\n'...
        '#SBATCH -p short\n'...
        '#SBATCH -t 00:20:00\n'...  
        '#SBATCH --mem=30G\n\n'...
        'matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath(''' repodir ''')); single_sub_smooth(' PID ', ' num2str(ses) ',' num2str(run) ',' num2str(overwrite) '); quit"\n\n'];
   
    % Write the batch script file
    scriptfile = fullfile(scriptdir, 'smoothing_script.sh');
    fout = fopen(scriptfile, 'w');
    fprintf(fout, s);
    fclose(fout);
    
    % Ensure the script is executable and submit the job
    !chmod 777 smoothing_script.sh
    !sbatch smoothing_script.sh
end
