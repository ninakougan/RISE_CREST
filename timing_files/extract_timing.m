basedir = '/Users/ninakougan/Documents/acnl/rise_crest/progress_reports/bids'; %make this wherever your bids directory is%

% load in tsv file for events
%txt = readtable("sub-50001_ses-1_task-mid_run-01_events.txt", "FileType","text",'Delimiter', '\t');

MIDfnames = filenames(fullfile(basedir,'sub-*/ses-1/func/*events.tsv')); %swap session here%

for sub 1:length(MIDfnames)
    txt = readtable(MIDfnames{1});
    
    % sort based on events
    gainidx = contains(txt.trial_type,"Win $5.00") | contains(txt.trial_type,"Win $1.50");
    gainzeroidx = contains(txt.trial_type,"Win $0.00");
    lossidx = contains(txt.trial_type,"Lose $5.00") | contains(txt.trial_type,"Lose $1.50");
    losszeroidx = contains(txt.trial_type,"Lose $0.00");
    
    onsets{1} = txt.onset(gainidx);
    durations{1} = ones(1,length(onsets)) .* 4;
    names{1} = {'GainAnticipation'};
    
    onsets{2} = txt.onset(gainzeroidx);
    durations{2} = ones(1,length(onsets)) .* 4;
    names{2} = {'GainZeroAnticipation'};
    
    onsets{3} = txt.onset(lossidx);
    durations{3} = ones(1,length(onsets)) .* 4;
    names{3} = {'LossAnticipation'};
    
    onsets{4} = txt.onset(losszeroidx);
    durations{4} = ones(1,length(onsets)) .* 4;
    names{4} = {'LossZeroAnticipation'};
    
    onsets{5} = txt.feedback_onset(gainidx);
    durations{5} = ones(1,length(onsets)) .* 4;
    names{5} = {'GainOutcome'};
    
    onsets{6} = txt.feedback_onset(gainzeroidx);
    durations{6} = ones(1,length(onsets)) .* 4;
    names{6} = {'GainZeroOutcome'};
    
    onsets{7} = txt.feedback_onset(lossidx);
    durations{7} = ones(1,length(onsets)) .* 4;
    names{7} = {'LossOutcome'};
    
    onsets{8} = txt.feedback_onset(losszeroidx);
    durations{8} = ones(1,length(onsets)) .* 4;
    names{8} = {'LossZeroOutcome'};
    
    onsets{9} = txt.target_onset;
    durations{9} = ones(1,length(onsets)) .* 2;
    names{9} = {'Motor'};
    
    %save onsets, durations, and names to .mat file
    temp_file_name = strcat(num2str(curr_table.PID(trial_ind1)),pid{sub}.mat');
        save(fullfile(savedir, temp_file_name), 'onsets', 'names', 'durations');
end


