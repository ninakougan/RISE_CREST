% Define input to single sub first levels script
% I think the best way to do this is going to be to find which files exist
% and then defining variables relative to those paths. It's going to be
% clunky and IT WILL CHANGE EVERYTIME YOU MOVE FILES AROUND. But since
% we're in BIDS format... Maybe I can actually make this more dynamic. 

scriptdir = '/home/nck1870/repos/RISE_CREST';
basedir = '/projects/b1108/studies/rise/data/processed/neuroimaging';
% What run of your task are you looking at?
run = 1;
% What session appears in your raw filenames when in BIDS format?
ses = 1;
% Do you want to overwrite previously estimated first levels or just add to
% what you have? 1 overwrites, 0 adds
overwrite = 0;

% rest, consumption, anticipation
contrast = 'anticipation'; % anticipation, outcome, chatroom

%%
fnames = filenames(fullfile(basedir,strcat('/fmriprep/ses-',num2str(ses),'/smoothed_data/ssub*ses-',num2str(ses),'*mid*run-0',num2str(run),'*')));

if overwrite == 0
    fl_list = filenames(fullfile(basedir,'/june2024/fl/*/',strcat('ses-',num2str(ses),'/'),contrast,strcat('run-0',num2str(run)),'SPM.mat'));
    counter = 1;
    for sub = 1:length(fnames)
        
        curr_sub = fnames{sub}(77:81);

        if isempty(find(contains(fl_list,curr_sub)))
            new_list(counter) = str2num(curr_sub);
            counter = counter + 1;
        else
            continue
        end
    end
end

% Run/submit first level script
repodir = '/home/nck1870/repos';
cd(scriptdir)
keyboard
for sub = 1:length(new_list)
    ids = new_list(sub);

        s = ['#!/bin/bash\n\n'...
     '#SBATCH -A p31589\n'...
     '#SBATCH -p short\n'...
     '#SBATCH -t 00:20:00\n'...  
     '#SBATCH --mem=20G\n\n'...
     'matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath(''' repodir ''')); run_sub_firstlevel_outcome(' num2str(ids) '); quit"\n\n'];
   
     scriptfile = fullfile(scriptdir, 'first_level_script.sh');
     fout = fopen(scriptfile, 'w');
     fprintf(fout, s);
     
     
     !chmod 777 first_level_script.sh
     !sbatch first_level_script.sh
     
end
