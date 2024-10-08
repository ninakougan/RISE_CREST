basedir = '/projects/b1108/studies/rise/data/raw/neuroimaging/bids'; %make this wherever your bids directory is%
savedir = '/projects/b1108/studies/rise/data/processed/neuroimaging/fmriprep/ses-1/spm_timing_files';

%basedir = '/Users/ninakougan/Documents/acnl/rise/timing_files'; %make this wherever your bids directory is%
%savedir = '/Users/ninakougan/Documents/acnl/rise/timing_files/SPM';

mid = 1;
chat = 0;
chat_mat = 0;

if mid==1
    MIDfnames = filenames(fullfile(strcat(basedir,'/events_files/sub*/ses-*/*/sub*events.txt')));
    % load in tsv file for events
    %txt = readtable("sub-50001_ses-1_task-mid_run-01_events.txt", "FileType","text",'Delimiter', '\t');
    keyboard

    for sub = 1:length(MIDfnames);
        txt = readtable(MIDfnames{1});
        pid{sub} = MIDfnames{sub}(74:78); %local 56:60, quest 74:78
        run = MIDfnames{sub}(120:121); %local 81:82, quest 120:121
        ses = MIDfnames{sub}(84); %local 66:66, quest 84
        %keyboard

        % sort based on events
        antgainidx = contains(txt.trial_type,"ant_Win5") | contains(txt.trial_type,"ant_Win1.5");
        antgainzeroidx = contains(txt.trial_type,"ant_Win0");
        antlossidx = contains(txt.trial_type,"ant_Lose5") | contains(txt.trial_type,"ant_Lose1.5");
        antlosszeroidx = contains(txt.trial_type,"ant_Lose0");

        outgainidx = contains(txt.trial_type,"out_Win5") | contains(txt.trial_type,"out_Win1.5");
        outgainzeroidx = contains(txt.trial_type,"out_Win0");
        outlossidx = contains(txt.trial_type,"out_Lose5") | contains(txt.trial_type,"out_Lose1.5");
        outlosszeroidx = contains(txt.trial_type,"out_Lose0");

        motor = contains(txt.trial_type,"motor");
        
        onsets{1} = txt.onset(antgainidx)';
        durations{1} = (ones(length(onsets{1}),1) .*4)';
        names{1} = 'GainAnticipation';

        onsets{2} = txt.onset(antgainzeroidx)';
        durations{2} = (ones(length(onsets{2}),1) .*4)';
        names{2} = 'GainZeroAnticipation';
        
        onsets{3} = txt.onset(antlossidx)';
        durations{3} = (ones(length(onsets{3}),1) .*4)';
        names{3} = 'LossAnticipation';
        
        onsets{4} = txt.onset(antlosszeroidx)';
        durations{4} = (ones(length(onsets{4}),1) .*4)';
        names{4} = 'LossZeroAnticipation';
       
        onsets{5} = txt.onset(motor)';
        durations{5} = (ones(length(onsets{5}),1) .*2)';
        names{5} = 'Motor';
        
        %save onsets, durations, and names to .mat file
        curr_filename = fullfile(savedir, strcat('sub-',pid{sub},'_ses-',num2str(ses),'_task-mid_run-',num2str(run),'_timing_anticipation.mat'));   
            save(curr_filename,'onsets','durations','names')

        clear onsets durations names

        onsets{1} = txt.onset(outgainidx)';
        durations{1} = (ones(length(onsets{1}),1) .*4)';
        names{1} = 'GainOutcome';
        
        onsets{2} = txt.onset(outgainzeroidx)';
        durations{2} = (ones(length(onsets{2}),1) .*4)';
        names{2} = 'GainZeroOutcome';
        
        onsets{3} = txt.onset(outlossidx)';
        durations{3} = (ones(length(onsets{3}),1) .*4)';
        names{3} = 'LossOutcome';
        
        onsets{4} = txt.onset(outlosszeroidx)';
        durations{4} = (ones(length(onsets{4}),1) .*4)';
        names{4} = 'LossZeroOutcome';
        
        onsets{5} = txt.onset(motor)';
        durations{5} = (ones(length(onsets{5}),1) .*2)';
        names{5} = 'Motor';

        curr_filename = fullfile(savedir, strcat('sub-',pid{sub},'_ses-',num2str(ses),'_task-mid_run-',num2str(run),'_timing_outcome.mat'));   
            save(curr_filename,'onsets','durations','names')
            clear onsets durations names
    end
end



