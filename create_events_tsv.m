%%Create BIDS Compliant events.tsv files for functional scans
%Author: Nina Kougan (ninakougan@northwestern.edu)
%Last updated: 12/6/2023

basedir = '/Users/ninakougan/Documents/acnl/rise_crest/progress_reports/'; %make this wherever your bids dataset is%

%% MID events.tsv files 
MIDfnames = filenames(fullfile(basedir,'sub-*/ses-1/beh/3_MID*txt')); %swap session here%

txt = readtable(MIDfnames{1});

%pull PID and session ID
pid = txt.Var2(matches(txt.Var1, 'Subject'));
pid = string(pid(1));
ses = txt.Var2(matches(txt.Var1, 'Session'));
ses = string(ses(1));

%RUN 1
cue_onset1 = (txt.Var2(matches(txt.Var1,'Run1Cue.OnsetTime'))) - (txt.Var2(matches(txt.Var1, 'Run1Fix.OnsetTime'))) ./ 1000;
tgt_onset1 = txt.Var2(matches(txt.Var1, 'Run1Tgt.OnsetTime')) ./1000; %onset for motor contrast
fbk_on1 = txt.Var2(matches(txt.Var1,'Run1Fbk.OnsetTime'));
fbk_on1 = (fbk_on1 - txt.Var2(strcmp(txt.Var1,'Run1Fix.OnsetTime'))) ./ 1000; 

cue_dur1 = txt.Var2(matches(txt.Var1,'Run1Cue.Duration')) ./ 1000; %same for all cues across runs, should be 2
tgt_dur1 = txt.Var2(matches(txt.Var1,'Run1Tgt.Duration'));
fbk_dur1 = txt.Var2(matches(txt.Var1,'Run1Fbk.Duration')) ./ 1000; %same for all cues across runs, should be 2

rt1 = txt.Var2(matches(txt.Var1, 'Run1Tgt.RT')) ./ 1000;
reward = txt.Var2(matches(txt.Var1, 'Rwd'));%this is for both runs, need to splitsky
reward1 = reward(1:48);
acc1 = txt.Var2(matches(txt.Var1, 'Run1Tgt.ACC'));

trial_type1 = strcat(string(txt.Var2(matches(txt.Var1,'RunList1'))),'-'); %maybe one day I can figure out how to code this without the dash... today is just not that day!
trial_type1 = replace(trial_type1,'1-','Win $5.00');
trial_type1 = replace(trial_type1,'2-','Win $1.50');
trial_type1 = replace(trial_type1,'3-','Win $0.00');
trial_type1 = replace(trial_type1,'4-','Lose $5.00');
trial_type1 = replace(trial_type1,'5-','Lose $1.50');
trial_type1 = replace(trial_type1,'6-','Lose $0.00');

str1 = 'Anticipation'
anticipation = {str1};
anticipation = string(repmat(anticipation,48,1));

str2 = 'Motor'
motor = {str2};
motor = string(repmat(motor,48,1));

str3 = 'Outcome'
outcome = {str3};
outcome = string(repmat(outcome,48,1));

null = repmat(NaN, 48, 1);

%compile variables into events.tsv file
onset1 = [cue_onset1;tgt_onset1;fbk_on1];
duration1 = [cue_dur1;tgt_dur1;fbk_dur1];
trial1 = [trial_type1;trial_type1;trial_type1];
response_time1 = [null;rt1;null];
accuracy1 = [null; null; acc1];
contrast_type = [anticipation;motor;outcome] ;
%fix = 

mid_events1 = array2table([onset1, duration1, trial1, response_time1, accuracy1, contrast_type]);
mid_events1.Properties.VariableNames = {'onset', 'duration', 'trial_type', 'response_time', 'accuracy', 'contrast_type'};
mid_txt = fullfile(basedir, "test_bids/", strcat('sub-',pid,'/ses-',ses,'/func/sub-',pid,'_ses-',ses,'_task-mid-01_events.txt'));
    writetable(mid_events1,mid_txt,'delimiter','tab')

%RUN 2 (Same as above)
%columns to include for BIDS
cue_onset2 = (txt.Var2(matches(txt.Var1,'Run2Cue.OnsetTime'))) - (txt.Var2(matches(txt.Var1, 'Run2Fix.OnsetTime'))) ./ 1000;
tgt_onset2 = txt.Var2(matches(txt.Var1, 'Run2Tgt.OnsetTime')) ./1000; %onset for motor contrast
fbk_on2 = txt.Var2(matches(txt.Var1,'Run2Fbk.OnsetTime'));
fbk_on2 = (fbk_on2 - txt.Var2(strcmp(txt.Var1,'Run2Fix.OnsetTime'))) ./ 1000; 

cue_dur2 = txt.Var2(matches(txt.Var1,'Run2Cue.Duration')) ./ 1000; %same for all cues across runs, should be 2
tgt_dur2 = txt.Var2(matches(txt.Var1,'Run2Tgt.Duration'));
fbk_dur2 = txt.Var2(matches(txt.Var1,'Run2Fbk.Duration')) ./ 1000; %same for all cues across runs, should be 2

rt2 = txt.Var2(matches(txt.Var1, 'Run2Tgt.RT')) ./ 1000;
reward2 = reward(49:96);
acc2 = txt.Var2(matches(txt.Var1, 'Run2Tgt.ACC'));

trial_type2 = strcat(string(txt.Var2(matches(txt.Var1,'RunList2'))),'-'); %maybe one day I can figure out how to code this without the dash... today is just not that day!
trial_type2 = replace(trial_type2,'1-','Win $5.00');
trial_type2 = replace(trial_type2,'2-','Win $1.50');
trial_type2 = replace(trial_type2,'3-','Win $0.00');
trial_type2 = replace(trial_type2,'4-','Lose $5.00');
trial_type2 = replace(trial_type2,'5-','Lose $1.50');
trial_type2 = replace(trial_type2,'6-','Lose $0.00');

%compile variables into events.tsv file
onset2 = [cue_onset2;tgt_onset2;fbk_on2];
duration2 = [cue_dur2;tgt_dur2;fbk_dur2];
trial2 = [trial_type2;trial_type2;trial_type2];
response_time2 = [null;rt2;null];
accuracy2 = [null; null; acc2];
%fix = 

mid_events2 = array2table([onset2, duration2, trial2, response_time2, accuracy2, contrast_type]);
mid_events2.Properties.VariableNames = {'onset', 'duration', 'trial_type', 'response_time', 'accuracy', 'contrast_type'};
mid_txt = fullfile(basedir, "test_bids/", strcat('sub-',pid,'/ses-',ses,'/func/sub-',pid,'_ses-',ses,'_task-mid-02_events.txt'));
    writetable(mid_events2,mid_txt,'delimiter','tab')

%% CHATROOM TASK
CRfnames_txt = filenames(fullfile(basedir,'test_bids/sub-*/ses-1/beh/chzc*txt')); %swap session here% 
CRfnames_csv = filenames(fullfile(basedir,'test_bids/sub-*/ses-1/beh/chzc*csv')); %swap session here% 

%% PsychToolbox version of Chatroom, csv file
csv = readtable(CRfnames_csv{1});
pid = csv.subjectID(1);
ses = CRfnames_csv{1}(86); %RISE 93

%pull onset, duration, trial type , and response time variables into events.tsv file
onset = csv.trialOnset
duration = (csv.trialOffset - csv.trialOnset) %should be 4
topic = cell2table(csv.trialTopic)
topic.Properties.VariableNames = {'topic'};
response_time = csv.trialRT

trial_type = strcat(string(csv.blockNumber),'-');
trial_type = replace(trial_type,'1-','Participant Selects'); 
trial_type = replace(trial_type,'4-','Control');
%1 is participant, 2 and 3 are acc/rej, 4 is control

trial_type = 

events = array2table([onset, duration, response_time]);
events.Properties.VariableNames = {'onset', 'duration', 'response_time'}
events = [events, topic, trial_type]

%write to tsv file
curr_filename = fullfile(basedir, strcat('sub-',pid,'/ses-',ses,'/func/sub-',pid,'_ses-',ses,'_task-chatroom_run-01_events.tsv')); 
        writetable(final_chat,curr_filename,'delimiter','tab')

%% E-Prime version of Chatroom, txt file
txt = readtable(CRfilepaths_txt{1});
pid = txt.Var2(contains(txt.Var1, 'Subject'))
pid = pid(1)
ses = txt.Var2(matches(txt.Var1, 'Session'))
ses = ses(1)


cr_events = readtable("chcz.csv", "FileType", "text", 'Delimiter', ',');

