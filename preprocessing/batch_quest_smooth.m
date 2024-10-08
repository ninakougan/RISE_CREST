scriptdir = '/home/nck1870/repos/RISE_CREST/preprocessing';

repodir = '/home/nck1870/repos';

% next is where the preprocessed data is
directories = '/projects/b1108/studies/rise/data/processed/neuroimaging/fmriprep/ses-1';

% What run of your task are you looking at?
run = 2;
% What session appears in your raw filenames when in BIDS format?
ses = 1;
% Do you want to overwrite previously estimated first levels or just add to
% what you have? 1 overwrites, 0 adds
overwrite = 0;
% Last thing is janky but bear with me. How long are your participant ID's?
% i.e. 10234 would correspond with a 5 for this variable
ID_length = 5;

%keyboard
file_list = filenames(fullfile(directories,strcat('*/ses-',num2str(ses),'/func/sub*mid_run-0',num2str(run),'*preproc_bold.nii')));
for i = 1:length(file_list)
    sublist{i} = file_list{i}(98:102);
end

keyboard
if overwrite == 0
    smooth_list = filenames(fullfile(directories,strcat('*/ses-',num2str(ses),'/func/ssub*mid_run-0',num2str(run),'*preproc_bold.nii')));
    counter = 1;
    for sub = 1:length(sublist)
        curr_sub = sublist(sub);
        if sum(contains(smooth_list,curr_sub)) == 0 
            new_list(counter) = sublist(sub);
            counter = counter + 1;
        else
            continue
        end
    end
end

% Run/submit batch script
keyboard
cd(scriptdir)
for sub = 1:length(new_list)
    PID = new_list{sub};
%     ses = 2;
%     run = 2;
%    overwrite = 0;
%     single_sub_smooth(PID,ses,run,overwrite)

        s = ['#!/bin/bash\n\n'...
     '#SBATCH -A p31589\n'...
     '#SBATCH -p short\n'...
     '#SBATCH -t 00:20:00\n'...  
     '#SBATCH --mem=30G\n\n'...
     'matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath(''' repodir ''')); single_sub_smooth(' PID ', ' num2str(ses) ',' num2str(run) ',' num2str(overwrite) '); quit"\n\n'];
   
     scriptfile = fullfile(scriptdir, 'smoothing_script.sh');
     fout = fopen(scriptfile, 'w');
     fprintf(fout, s);
     
     
     !chmod 777 smoothing_script.sh
     !sbatch smoothing_script.sh
     
end