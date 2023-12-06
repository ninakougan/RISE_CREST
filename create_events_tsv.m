%%Create BIDS Compliant events.tsv files for functional scans
%Author: Nina Kougan (ninakougan@northwestern.edu)
%Last updated: 12/6/2023

basedir = '/Users/ninakougan/Documents/acnl/rise_crest/progress_reports';

%% MID events.tsv files 
MIDfnames = filenames(fullfile(basedir,'test_bids/sub-*/ses-1/beh/3_MID*txt')); %swap session here%

for sub = 1:length(MIDfnames):
    txt = readtable(MIDfnames{1});

    %pull PID and session ID
    pid = txt.Var2(contains(txt.Var1, 'Subject'))
    pid = pid(1)
    ses = txt.Var2(matches(txt.Var1, 'Session'))
    ses = ses(1)

    %exclusions
    %some line of code where you say hey here are my PIDs pull those puppies

    %RUN 1
    %columns to include for BIDS
    cue_onset1 = (txt.Var2(matches(txt.Var1,'Run1Cue.OnsetTime'))) - (txt.Var2(matches(txt.Var1, 'Run1Fix.OnsetTime'))) ./ 1000;
    tgt_onset1 = txt.Var2(matches(txt.Var1, 'Run1Tgt.OnsetTime')) ./1000; %onset for motor contrast
    fbk_on1 = txt.Var2(matches(txt.Var1,'Run1Fbk.OnsetTime'));
    fbk_on1 = (fbk_on1 - txt.Var2(strcmp(txt.Var1,'Run1Fix.OnsetTime'))) ./ 1000; %need to ask what this is doing

    cue_dur = txt.Var2(matches(txt.Var1,'Run1Cue.Duration')) ./ 1000; %same for all cues across runs, should be 2
    fbk_dur = txt.Var2(matches(txt.Var1,'Run1Fbk.Duration')) ./ 1000; %same for all cues across runs, should be 2

    rt1 = txt.Var2(matches(txt.Var1, 'Run1Tgt.RT')) ./ 1000;
    rt1(rt1 == 0) = NaN; %swap NaNs with zeros so the code doesn't explode

    trial_type1 = strcat(string(txt.Var2(matches(txt.Var1,'RunList1'))),'-'); %maybe one day I can figure out how to code this without the dash... today is just not that day!
    trial_type1 = replace(trial_type1,'1-','Win $5.00')
    trial_type1 = replace(trial_type1,'2-','Win $1.50');
    trial_type1 = replace(trial_type1,'3-','Win $0.00');
    trial_type1 = replace(trial_type1,'4-','Lose $5.00');
    trial_type1 = replace(trial_type1,'5-','Lose $1.50');
    trial_type1 = replace(trial_type1,'6-','Lose $0.00');

    reward = txt.Var2(matches(txt.Var1, 'Rwd')); %not sure if we need it but here it is just in case


    %compile variables into events.tsv file
    onset = 
    duration = 
    trial_type = 
    response_time = 
    accuracy = 

    mid_events = array2table([onset, duration, trial_type, response_time, accuracy]);
    mid_tsv = fullfile(basedir, "events/", strcat('sub-',pid{sub},'/ses-1/func/sub-',pid{sub},'_ses-1_task-mid-01_events.tsv')); %swap session here%  

    %RUN 2 (Same as above)
    cue_onset2 = (txt.Var2(matches(txt.Var1,'Run2Cue.OnsetTime'))) - (txt.Var2(matches(txt.Var1, 'Run2Fix.OnsetTime'))) ./ 1000;
    tgt_onset2 = txt.Var2(matches(txt.Var1, 'Run2Tgt.OnsetTime')) ./1000; 
    fbk_on2 = txt.Var2(matches(txt.Var1,'Run2Fbk.OnsetTime'));
    fbk_on2 = (fbk_on2 - txt.Var2(strcmp(txt.Var1,'Run2Fix.OnsetTime'))) ./ 1000; 

    cue_dur = txt.Var2(matches(txt.Var1,'Run2Cue.Duration')) ./ 1000; 
    fbk_dur = txt.Var2(matches(txt.Var1,'Run2Fbk.Duration')) ./ 1000; 

    rt2 = txt.Var2(matches(txt.Var1, 'Run2Tgt.RT')) ./ 1000;
    rt2(rt2 == 0) = NaN; 

    trial_type2 = strcat(string(txt.Var2(matches(txt.Var1,'RunList1'))),'-');
    trial_type2 = replace(trial_type2,'1-','Win $5.00')
    trial_type2 = replace(trial_type2,'2-','Win $1.50');
    trial_type2 = replace(trial_type2,'3-','Win $0.00');
    trial_type2 = replace(trial_type2,'4-','Lose $5.00');
    trial_type2 = replace(trial_type2,'5-','Lose $1.50');
    trial_type2 = replace(trial_type2,'6-','Lose $0.00');

    reward = txt.Var2(matches(txt.Var1, 'Rwd')); 

    onset = 
    duration = 
    trial_type = 
    response_time = 
    accuracy = 

    mid_events = array2table([onset, duration, trial_type, response_time, accuracy]);
    mid_tsv = fullfile(basedir, "events/", strcat('sub-',pid{sub},'/ses-1/func/sub-',pid{sub},'_ses-1_task-mid-02_events.tsv')); %swap session here% 
end


%% Chatroom events.tsv files
CRfnames_txt = filenames(fullfile(basedir,'sub-*/ses-1/beh/chzc*txt')); %swap session here% 
CRfnames_csv = filenames(fullfile(basedir,'sub-*/ses-1/beh/chzc*csv')); %swap session here% 

%PsychToolbox version of Chatroom, csv file
csv = readtable(CRfnames_csv{1});
pid = csv.subjectID(1);
ses = CRfnames_csv{1}(89:93); %RISE 93

%pull onset, duration, trial type , and response time variables into events.tsv file
onset = csv.trialOnset
duration = (csv.trialOffset - csv.trialOnset) %4 seconds
trial_type = cell2table(csv.trialTopic)
trial_type.Properties.VariableNames = {'trial_type'};
response_time = csv.trialRT
%response_time(response_time == 0) = NaN; %check this?

events = array2table([onset, duration, response_time]);
events.Properties.VariableNames = {'onset', 'duration', 'response_time'}
events = [events, trial_type]

%write to tsv file
curr_filename = fullfile(basedir, strcat('sub-',pid{sub},'/ses-1/func/sub-',pid{sub},'_ses-1_task-chatroom_run-01_events.tsv')); %swap session here%   
        writetable(final_chat,curr_filename,'delimiter','tab')


%E-Prime version of Chatroom, txt file
txt = readtable(CRfilepaths_txt{1});
pid = txt.Var2(contains(txt.Var1, 'Subject'))
pid = pid(1)
ses = txt.Var2(matches(txt.Var1, 'Session'))
ses = ses(1)


cr_events = readtable("chcz.csv", "FileType", "text", 'Delimiter', ',');


