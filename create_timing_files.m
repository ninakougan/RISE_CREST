%%Create SPM timing files for first-level analyses
%Author: Nina Kougan (ninakougan@northwestern.edu)
%Last updated: 12/6/2023

basedir = '/Users/ninakougan/Documents/acnl/rise_crest/progress_reports';

%% MID Timing Files         
MIDfnames = filenames(fullfile(basedir,'timing_events/*mid*tsv'));
tsv = readtable(MIDfnames{1});


t = readtable("sub-50001_ses-1_task-mid_run-01_events.tsv", "FileType","text",'Delimiter', '\t');

% pull event types
antgainidx = contains(t.type,"Win $5.00") | contains(t.type,"Win $1.50");
antgainzeroidx = contains(t.type,"Win $0.00");
antlossidx = contains(t.type,"Lose $5.00") | contains(t.type,"Lose $1.50");
antlosszeroidx = contains(t.type,"Lose $0.00");

onsets{1} = t.onset(antgainidx);
durations{1} = ones(1,length(onsets)) .* 4;
names{1} = {'GainAnticipation'};

onsets{2} = t.onset(antgainzeroidx);
durations{2} = ones(1,length(onsets)) .* 4;
names{2} = {'GainAnticipationZero'};

onsets{3} = t.onset(antlossidx);
durations{3} = ones(1,length(onsets)) .* 4;
names{3} = {'LossAnticipation'};

onsets{4} = t.onset(antlosszeroidx);
durations{4} = ones(1,length(onsets)) .* 4;
names{4} = {'LossAnticipationZero'};

onsets{5} = t.onset(motor);
durations{5} = ones(1,length(onsets)) .* 2;
names{5} = {'Motor'};

%save output
temp_file_name = strcat(num2str(curr_table.PID(trial_ind1)),'_anticipation_timing.mat');
    save(fullfile(savedir, temp_file_name), 'onsets', 'names', 'durations');

% add all trial types
% need to pull motor onsets, duration will be 2. 
% save onsets durations names in file that corresponds to each sub.

                
             

%Chatroom timing files
