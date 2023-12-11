%%Create BIDS-compliant events.tsv files for functional scans
%Author: Nina Kougan (ninakougan@northwestern.edu)
%Last updated: 12/11/23

basedir = '/Users/ninakougan/Documents/acnl/rise_crest/progress_reports'; 

%% Events.tsv files that don't make my brain hurt
MIDfnames = filenames(fullfile(basedir,'behavioral/sub-*/ses-2/beh/3_MID*txt')); %swap session here%

for sub = 1:length(MIDfnames)
    txt = readtable(MIDfnames{1});
    pid{sub} = MIDfnames{sub}(77:81);
    %func_dir = fullfile(basedir,strcat('sub-',pid{sub},'/ses-1/func/'));
    %mkdir(func_dir);

% for sub = 1:length(MIDfnames)
%     txt = readtable(MIDfnames{1});
%     pid = txt.Var2(matches(txt.Var1, 'Subject'));
%     pid = string(pid(1));
    %ses = txt.Var2(matches(txt.Var1, 'Session'));
    %ses = string(ses(1));
    
    %RUN 1
    cue_onset1 = ((txt.Var2(matches(txt.Var1,'Run1Cue.OnsetTime'))) - (txt.Var2(matches(txt.Var1, 'Run1Fix.OnsetTime')))) ./ 1000;
    tgt_onset1 = (txt.Var2(matches(txt.Var1, 'Run1Tgt.OnsetTime')) - (txt.Var2(matches(txt.Var1, 'Run1Fix.OnsetTime')))) ./1000; %onset for motor contrast
    fbk_on1 = (txt.Var2(matches(txt.Var1,'Run1Fbk.OnsetTime')) - (txt.Var2(matches(txt.Var1,'Run1Fix.OnsetTime')))) ./ 1000;
    
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
    
    %compile variables into events.tsv file
    mid_events1 = array2table([cue_onset1, cue_dur1, trial_type1, tgt_onset1, tgt_dur1, rt1, fbk_on1, fbk_dur1, acc1])
    mid_events1.Properties.VariableNames = {'onset', 'duration', 'trial_type',...
        'target_onset', 'target_duration', 'reaction_time', 'feedback_onset', 'feedback_duration', 'accuracy'}
    
    mid_txt = fullfile(basedir, "bids/", strcat('sub-',pid{sub},'/ses-2/func/sub-',pid{sub},'_ses-2_task-mid_run-01_events.txt'))
        writetable(mid_events1, mid_txt,'delimiter','tab')
    
    %RUN 2
    cue_onset2 = ((txt.Var2(matches(txt.Var1,'Run2Cue.OnsetTime'))) - (txt.Var2(matches(txt.Var1, 'Run2Fix.OnsetTime')))) ./ 1000;
    tgt_onset2 = (txt.Var2(matches(txt.Var1, 'Run2Tgt.OnsetTime')) - (txt.Var2(matches(txt.Var1, 'Run2Fix.OnsetTime')))) ./1000
    fbk_on2 = (txt.Var2(matches(txt.Var1,'Run2Fbk.OnsetTime')) - (txt.Var2(matches(txt.Var1,'Run2Fix.OnsetTime')))) ./ 1000;
    
    cue_dur2 = txt.Var2(matches(txt.Var1,'Run2Cue.Duration')) ./ 1000; %same for all cues across runs, should be 2
    tgt_dur2 = txt.Var2(matches(txt.Var1,'Run2Tgt.Duration'));
    fbk_dur2 = txt.Var2(matches(txt.Var1,'Run2Fbk.Duration')) ./ 1000; %same for all cues across runs, should be 2
    
    rt2 = txt.Var2(matches(txt.Var1, 'Run2Tgt.RT')) ./ 1000;
    reward = txt.Var2(matches(txt.Var1, 'Rwd'));%this is for both runs, need to splitsky
    reward2 = reward(49:96);
    acc2 = txt.Var2(matches(txt.Var1, 'Run2Tgt.ACC'));
    
    trial_type2 = strcat(string(txt.Var2(matches(txt.Var1,'RunList2'))),'-'); %maybe one day I can figure out how to code this without the dash... today is just not that day!
    trial_type2 = replace(trial_type1,'1-','Win $5.00');
    trial_type2 = replace(trial_type1,'2-','Win $1.50');
    trial_type2 = replace(trial_type1,'3-','Win $0.00');
    trial_type2 = replace(trial_type1,'4-','Lose $5.00');
    trial_type2 = replace(trial_type1,'5-','Lose $1.50');
    trial_type2 = replace(trial_type1,'6-','Lose $0.00');
    
    %compile variables into events.tsv file
    mid_events2 = array2table([cue_onset2, cue_dur2, trial_type2, tgt_onset2, tgt_dur2, rt2, fbk_on2, fbk_dur2, acc2])
    mid_events2.Properties.VariableNames = {'onset', 'duration', 'trial_type',...
        'target_onset', 'target_duration', 'reaction_time', 'feedback_onset', 'feedback_duration', 'accuracy'}
    
    mid_txt = fullfile(basedir, "bids/", strcat('sub-',pid{sub},'/ses-2/func/sub-',pid{sub},'_ses-2_task-mid_run-02_events.txt'))
        writetable(mid_events2,mid_txt,'delimiter','tab')
end

% %% CHATROOM TASK
% CRfnames_txt = filenames(fullfile(basedir,'behavioral/sub-*/ses-1/beh/chzc*txt')); %swap session here% 
% CRfnames_csv = filenames(fullfile(basedir,'behavioral/sub-*/ses-1/beh/chzc*csv')); %swap session here% 
% 
% %% PsychToolbox version of Chatroom, csv file
% for sub = 1:length(CRfnames_csv)
%     csv = readtable(CRfnames_csv{1});
%     pid = csv.subjectID(1);
%     ses = CRfnames_csv{1}(87); %RISE 87
% 
%     %pull onset, duration, trial type , and response time variables into events.tsv file
%     onset = csv.trialOnset;
%     duration = (csv.trialOffset - csv.trialOnset); %should be 4
%     block_num = csv.blockNumber; %1 is participant, 2 and 3 are acc/rej, 4 is control
%     block_agent = cell2table(csv.blockAgent); %who is making selections
%     block_agent.Properties.VariableNames = {'block_agent'};
%     topic = cell2table(csv.trialTopic);
%     topic.Properties.VariableNames = {'topic'};
%     player_selected = cell2table(csv.trialPlayerSelected); %need logic to address NaNs/when P doesn't make a selection
%     player_selected.Properties.VariableNames = {'player_selected'};
%     jitter = csv.trialITIj;
%     response_time = csv.trialRT;
%     feedback_dur = (csv.trialFeedbackOffset - csv.trialFeedbackOnset); %should be 8
% 
%     events = array2table([onset, duration, block_num]);
%     events.Properties.VariableNames = {'onset', 'duration', 'block_number'}
%     events = ([events, block_agent, topic, player_selected]);
%     events_cont = array2table([jitter, response_time, feedback_dur]);
%     events_cont.Properties.VariableNames = {'jitter', 'RT', 'feedback_duration'}
%     events = ([events, events_cont])
% 
%     %write to tsv file
%     curr_filename = fullfile(basedir, "behavioral/", strcat('sub-',pid,'/ses-',ses,'/func/sub-',pid,'_ses-',ses,'_task-chatroom_run-01_events.tsv')); 
%             writetable(events,curr_filename,'delimiter','tab')
% end
% 
% %% E-Prime version of Chatroom, txt file
% for sub = 1:length(CRfnames_txt)
%     txt = readtable(CRfnames_txt{1});
%     pid = txt.Var2(matches(txt.Var1, 'Subject'));
%     pid = pid(1)
%     ses = txt.Var2(matches(txt.Var1, 'Session'));
%     ses = ses(1)
% 
%     onset = txt.Var2(matches(txt.Var1,'ChzT.OnsetTime')) ./ 1000;
%     duration =  %should be 4
%     block_num =  %not sure where I'm pulling this from in the output
%     block_agent = txt.Var2(matches(txt.Var1,'List1.Sample')) %I think this is one of the List vars but idk my head hurts
% 
%     topic = strcat(string(txt.Var2(matches(txt.Var1,'TopicNumber'))));
%     topic = replace(trial_type1,'10','Computers');
%     topic = replace(trial_type1,'11','Pets');
%     topic = replace(trial_type1,'12','Books');
%     topic = replace(trial_type1,'13','Friends');
%     topic = replace(trial_type1,'14','Family');
%     topic = replace(trial_type1,'15','Sports');
%     topic = replace(trial_type1,'1','School');
%     topic = replace(trial_type1,'2','Parties');
%     topic = replace(trial_type1,'3','Vacations');
%     topic = replace(trial_type1,'4','Hobbies');
%     topic = replace(trial_type1,'5','Music');
%     topic = replace(trial_type1,'6','TV');
%     topic = replace(trial_type1,'7','Movies');
%     topic = replace(trial_type1,'8','Food');
%     topic = replace(trial_type1,'9','Shopping');
% 
%     player_selected = txt.Var2(matches(txt.Var1,'ChzT.RESP'))
%     jitter = txt.Var2(matches(txt.Var1,'ITIj')) ./ 1000;
%     response_time = txt.Var2(matches(txt.Var1,'ChzT.RT')) ./ 1000;
% 
%     feedback_onset = txt.Var2(matches(txt.Var1,'ShwT.OnsetTime')) ./ 1000;
%     feedback_dur = 
% 
%     cr_events = array2table
%     cr_events.Properties.VariableNames = {'onset', 'duration', 'block_number',...
%         'block_agent', 'topic', 'player_selected', 'jitter', 'reaction_time', 'feedback_duration'}
% 
%     cr_txt = fullfile(basedir, "behavioral/", strcat('sub-',pid,'/ses-',ses,'/func/sub-',pid,'_ses-',ses,'_task-chatroom_run-01_events.txt'));
%         writetable(cr_events,cr_txt,'delimiter','tab')


% %% MID events.tsv files that do make my brain hurt!
% MIDfnames = filenames(fullfile(basedir,'sub-*/ses-1/beh/3_MID*txt')); %swap session here%
% 
% txt = readtable(MIDfnames{1});
% 
% %pull PID and session ID
% pid = txt.Var2(matches(txt.Var1, 'Subject'));
% pid = string(pid(1));
% ses = txt.Var2(matches(txt.Var1, 'Session'));
% ses = string(ses(1));
% 
% %RUN 1
% cue_onset1 = (txt.Var2(matches(txt.Var1,'Run1Cue.OnsetTime'))) - (txt.Var2(matches(txt.Var1, 'Run1Fix.OnsetTime'))) ./ 1000;
% tgt_onset1 = txt.Var2(matches(txt.Var1, 'Run1Tgt.OnsetTime')) ./1000; %onset for motor contrast
% fbk_on1 = txt.Var2(matches(txt.Var1,'Run1Fbk.OnsetTime'));
% fbk_on1 = (fbk_on1 - txt.Var2(strcmp(txt.Var1,'Run1Fix.OnsetTime'))) ./ 1000; 
% 
% cue_dur1 = txt.Var2(matches(txt.Var1,'Run1Cue.Duration')) ./ 1000; %same for all cues across runs, should be 2
% tgt_dur1 = txt.Var2(matches(txt.Var1,'Run1Tgt.Duration'));
% fbk_dur1 = txt.Var2(matches(txt.Var1,'Run1Fbk.Duration')) ./ 1000; %same for all cues across runs, should be 2
% 
% rt1 = txt.Var2(matches(txt.Var1, 'Run1Tgt.RT')) ./ 1000;
% reward = txt.Var2(matches(txt.Var1, 'Rwd'));%this is for both runs, need to splitsky
% reward1 = reward(1:48);
% acc1 = txt.Var2(matches(txt.Var1, 'Run1Tgt.ACC'));
% 
% trial_type1 = strcat(string(txt.Var2(matches(txt.Var1,'RunList1'))),'-'); %maybe one day I can figure out how to code this without the dash... today is just not that day!
% trial_type1 = replace(trial_type1,'1-','Win $5.00');
% trial_type1 = replace(trial_type1,'2-','Win $1.50');
% trial_type1 = replace(trial_type1,'3-','Win $0.00');
% trial_type1 = replace(trial_type1,'4-','Lose $5.00');
% trial_type1 = replace(trial_type1,'5-','Lose $1.50');
% trial_type1 = replace(trial_type1,'6-','Lose $0.00');
% 
% str1 = 'Anticipation'
% anticipation = {str1};
% anticipation = string(repmat(anticipation,48,1));
% 
% str2 = 'Motor'
% motor = {str2};
% motor = string(repmat(motor,48,1));
% 
% str3 = 'Outcome'
% outcome = {str3};
% outcome = string(repmat(outcome,48,1));
% 
% null = repmat(NaN, 48, 1);
% 
% %compile variables into events.tsv file
% onset1 = [cue_onset1;tgt_onset1;fbk_on1];
% duration1 = [cue_dur1;tgt_dur1;fbk_dur1];
% trial1 = [trial_type1;trial_type1;trial_type1];
% response_time1 = [null;rt1;null];
% accuracy1 = [null; null; acc1];
% contrast_type = [anticipation;motor;outcome] ;
% %fix = 
% 
% mid_events1 = array2table([onset1, duration1, trial1, response_time1, accuracy1, contrast_type]);
% mid_events1.Properties.VariableNames = {'onset', 'duration', 'trial_type', 'response_time', 'accuracy', 'contrast_type'};
% mid_txt = fullfile(basedir, "test_bids/", strcat('sub-',pid,'/ses-',ses,'/func/sub-',pid,'_ses-',ses,'_task-mid_run-01_events.txt'));
%     writetable(mid_events1,mid_txt,'delimiter','tab')
% 
% %RUN 2 (Same as above)
% %columns to include for BIDS
% cue_onset2 = (txt.Var2(matches(txt.Var1,'Run2Cue.OnsetTime'))) - (txt.Var2(matches(txt.Var1, 'Run2Fix.OnsetTime'))) ./ 1000;
% tgt_onset2 = txt.Var2(matches(txt.Var1, 'Run2Tgt.OnsetTime')) ./1000; %onset for motor contrast
% fbk_on2 = txt.Var2(matches(txt.Var1,'Run2Fbk.OnsetTime'));
% fbk_on2 = (fbk_on2 - txt.Var2(strcmp(txt.Var1,'Run2Fix.OnsetTime'))) ./ 1000; 
% 
% cue_dur2 = txt.Var2(matches(txt.Var1,'Run2Cue.Duration')) ./ 1000; %same for all cues across runs, should be 2
% tgt_dur2 = txt.Var2(matches(txt.Var1,'Run2Tgt.Duration'));
% fbk_dur2 = txt.Var2(matches(txt.Var1,'Run2Fbk.Duration')) ./ 1000; %same for all cues across runs, should be 2
% 
% rt2 = txt.Var2(matches(txt.Var1, 'Run2Tgt.RT')) ./ 1000;
% reward2 = reward(49:96);
% acc2 = txt.Var2(matches(txt.Var1, 'Run2Tgt.ACC'));
% 
% trial_type2 = strcat(string(txt.Var2(matches(txt.Var1,'RunList2'))),'-'); %maybe one day I can figure out how to code this without the dash... today is just not that day!
% trial_type2 = replace(trial_type2,'1-','Win $5.00');
% trial_type2 = replace(trial_type2,'2-','Win $1.50');
% trial_type2 = replace(trial_type2,'3-','Win $0.00');
% trial_type2 = replace(trial_type2,'4-','Lose $5.00');
% trial_type2 = replace(trial_type2,'5-','Lose $1.50');
% trial_type2 = replace(trial_type2,'6-','Lose $0.00');
% 
% %compile variables into events.tsv file
% onset2 = [cue_onset2;tgt_onset2;fbk_on2];
% duration2 = [cue_dur2;tgt_dur2;fbk_dur2];
% trial2 = [trial_type2;trial_type2;trial_type2];
% response_time2 = [null;rt2;null];
% accuracy2 = [null; null; acc2];
% %fix = 
% 
% mid_events2 = array2table([onset2, duration2, trial2, response_time2, accuracy2, contrast_type]);
% mid_events2.Properties.VariableNames = {'onset', 'duration', 'trial_type', 'response_time', 'accuracy', 'contrast_type'};
% mid_txt = fullfile(basedir, "test_bids/", strcat('sub-',pid,'/ses-',ses,'/func/sub-',pid,'_ses-',ses,'_task-mid_run-02_events.txt'));
%     writetable(mid_events2,mid_txt,'delimiter','tab')