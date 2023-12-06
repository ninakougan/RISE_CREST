
% load in tsv file for events
t = readtable("sub-50001_ses-1_task-mid_run-02_events.tsv", "FileType","text",'Delimiter', '\t');

% sort based on events
antgainidx = contains(t.type,"Win $5.00") | contains(t.type,"Win $1.50");
antgainzeroidx = contains(t.type,"Win $0.00");
antlossidx = contains(t.type,"Lose $5.00") | contains(t.type,"Lose $1.50");
antlosszeroidx = contains(t.type,"Lose $0.00");

onsets{1} = t.onset(antgainidx);
durations{1} = ones(1,length(onsets)) .* 4;
names{1} = {'GainAnticipation'};

% add all trial types
% need to pull motor onsets, duration will be 2. 
% save onsets durations names in file that corresponds to each sub.