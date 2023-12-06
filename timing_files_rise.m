%%Creating events.tsv and timing files for MID and Chatroom tasks
%Author: Nina Kougan (ninakougan@northwestern.edu)
%Last updated: 12/6/2023

basedir = '/Users/ninakougan/Documents/acnl/rise_crest/progress_reports';

%% MID events.tsv files
MIDfnames = filenames(fullfile(basedir,'test_bids/sub-*/ses-1/beh/3_MID*txt'));
txt = readtable(MIDfnames{1});

%pull PID and session ID
pid = txt.Var2(contains(txt.Var1, 'Subject'))
pid = pid(1)
ses = txt.Var2(matches(txt.Var1, 'Session'))
ses = ses(1)

%exclusions
%some line of code where you say hey here are my PIDs pull those puppies

%columns to include at minimum for BIDS compliance: onset, duration, trial_type, response_time

cue_onset1 = (txt.Var2(matches(txt.Var1,'Run1Cue.OnsetTime'))) - (txt.Var2(matches(txt.Var1, 'Run1Fix.OnsetTime'))) ./ 1000;
tgt_onset1 = txt.Var2(matches(txt.Var1, 'Run1Tgt.OnsetTime')) ./1000; %onset for motor contrast
fbk_on1 = txt.Var2(matches(txt.Var1,'Run1Fbk.OnsetTime'));
fbk_on1 = (fbk_on1 - txt.Var2(strcmp(txt.Var1,'Run1Fix.OnsetTime'))) ./ 1000; %need to ask what this is doing

cue_dur = txt.Var2(matches(txt.Var1,'Run1Cue.Duration')) ./ 1000; %same for all cues across runs, should be 2
fbk_dur = txt.Var2(matches(txt.Var1,'Run1Fbk.Duration')) ./ 1000; %same for all cues across runs, should be 2

rt1 = txt.Var2(matches(txt.Var1, 'Run1Tgt.RT')) ./ 1000;
rt1(rt1 == 0) = NaN; %swap NaNs with zeros so the code doesn't explode

trial_type1 = (txt.Var2(matches(txt.Var1, 'RunList1')));






              
                % Was the participant accurate?
                acc1 = ~isnan(rt1);
                acc2 = ~isnan(rt2);
                rwd = txt.Var2(find(contains(txt.Var1,'Rwd')));
                
                % what was the target rt?
                target_RT1 = txt.Var2(find(contains(txt.Var1,'Run1Tgt.Duration')));
                target_RT2 = txt.Var2(find(contains(txt.Var1,'Run2Tgt.Duration')));
                target_RT1(target_RT1 < 0) = [];
                target_RT2(target_RT2 < 0) = [];
                % I'm adding a '-' so that I can more easily refer to the
                % string below. When I only had a '1', too many replacements
                % were happening lol
    
                trial_type1 = strcat(string(txt.Var2(find(contains(txt.Var1,'RunList1')))),'-');
                trial_type2 = strcat(string(txt.Var2(find(contains(txt.Var1,'RunList2')))),'-');
                
                trial_type1 = replace(trial_type1,'1-','Run1 Win $5.00');
                trial_type1 = replace(trial_type1,'2-','Run1 Win $1.50');
                trial_type1 = replace(trial_type1,'3-','Run1 Win $0.00');
                trial_type1 = replace(trial_type1,'4-','Run1 Lose $5.00');
                trial_type1 = replace(trial_type1,'5-','Run1 Lose $1.50');
                trial_type1 = replace(trial_type1,'6-','Run1 Lose $0.00');
    
                trial_type2 = replace(trial_type2,'1-','Run2 Win $5.00');
                trial_type2 = replace(trial_type2,'2-','Run2 Win $1.50');
                trial_type2 = replace(trial_type2,'3-','Run2 Win $0.00');
                trial_type2 = replace(trial_type2,'4-','Run2 Lose $5.00');
                trial_type2 = replace(trial_type2,'5-','Run2 Lose $1.50');
                trial_type2 = replace(trial_type2,'6-','Run2 Lose $0.00');
                
                % compile final variables to put into table
                all_cue_on = [cue_on1;cue_on2];
                all_cue_dur = cue_dur;
                all_fbk_on = [fbk_on1;fbk_on2];
                all_fbk_dur = fbk_dur;
                all_response_time = [rt1;rt2]; all_response_time(all_response_time==0) = NaN;
                all_trial_type = [trial_type1;trial_type2];
                all_cue_type = strcat(all_trial_type,' Anticipation');
                all_fbk_type = strcat(all_trial_type,' Feeback');
                all_acc = zeros(length(all_response_time),1); all_acc(all_response_time>0) = 1;
                
                % final variables
                onset = [all_cue_on;all_fbk_on]; 
                duration = [all_cue_dur;all_fbk_dur]; 
                trial_type = [all_cue_type;all_fbk_type];
                




%% Chatroom event.tsv files
CRfnames_txt = filenames(fullfile(basedir,'behavioral_files/sub-*/ses-1/beh/chzc*txt')); 
CRfnames_csv = filenames(fullfile(basedir,'behavioral_files/sub-*/ses-1/beh/chzc*csv'));

%create events files from PsychToolbox version of Chatroom, output is a csv
csv = readtable(CRfnames_csv{1});

%pull PID and session ID
pid = csv.subjectID(1);
ses = CRfnames_csv{1}(89:93); %RISE 89:93

%pull onset, duration, trial type , and response time variables into events.tsv file
onset = csv.trialOnset
duration = (csv.trialOffset - csv.trialOnset) %4 seconds
trial_type = cell2table(csv.trialTopic)
trial_type.Properties.VariableNames = {'trial_type'};
response_time = csv.trialRT

events = array2table([onset, duration, response_time]);
events.Properties.VariableNames = {'onset', 'duration', 'response_time'}
events_final = [events, trial_type]

%write to tsv file
curr_filename = fullfile(basedir, strcat('sub-',pid{sub},'/ses-1/func/sub-',pid{sub},'_ses-1_task-chatroom_run-01_events.tsv'));   
        writetable(final_chat,curr_filename,'delimiter','tab')

%create events files from E-Prime version of Chatroom, output is a txt
txt = readtable(CRfilepaths_txt{1});



for sub = 1:length(CRfilepaths_csv)
    csv = readtable(CRfilepaths_csv{1});
    pid{sub} = CRfilepaths_csv(60:70);
    func_dir = fullfile(basedir,strcat('sub-',pid{sub},'/ses-1/func/'));
    mkdir(func_dir);
end

cr_events = readtable("chcz.csv", "FileType", "text", 'Delimiter', ',');

%% Create timing files for first levels %%

%MID timing files
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
