%%Create BIDS-compliant events.tsv files for functional scans
%Author: Nina Kougan (ninakougan@northwestern.edu)
%Last updated: 12/11/23

basedir = '/Users/ninakougan/Documents/acnl/rise';
% quest path '/projects/b1108/studies/rise/data/raw/neuroimaging'

%Which session are you looking at?
ses = 1;

%which task? switch these to 1 if running, 0 if not
chatroom = 0;
mid = 1;

%% %MID files
if mid == 1
    MIDfnames = filenames(fullfile(strcat(basedir,'/behavioral/sub-*/ses-',num2str(ses),'/beh/3_MID*txt')));
    %keyboard

    for sub = 1:length(MIDfnames)
        % Load in the text file
        txt = readtable(MIDfnames{sub});
        pid{sub} =  MIDfnames{sub}(54:58); % RISE %(72:77);% CREST (71:75); %
        func_dir = fullfile(basedir,'bids',strcat('sub-',pid{sub},'/ses-',num2str(ses),'/func/'));
        mkdir(func_dir);
        if isempty(txt) == 0
    
        %pull PID and session ID
        %pid = txt.Var2(matches(txt.Var1, 'Subject'));
        %pid = string(pid(1));
        %ses = txt.Var2(matches(txt.Var1, 'Session'));
        %ses = string(ses(1));
    
            cue_onset1 = ((txt.Var2(matches(txt.Var1,'Run1Cue.OnsetTime'))) - (txt.Var2(matches(txt.Var1, 'Run1Fix.OnsetTime')))) ./ 1000;
            cue_onset2 = ((txt.Var2(matches(txt.Var1,'Run2Cue.OnsetTime'))) - (txt.Var2(matches(txt.Var1, 'Run2Fix.OnsetTime')))) ./ 1000;
        
            tgt_onset1 = ((txt.Var2(matches(txt.Var1, 'Run1Tgt.OnsetTime'))) - (txt.Var2(matches(txt.Var1, 'Run1Fix.OnsetTime')))) ./1000; %motor period
            tgt_onset2 = ((txt.Var2(matches(txt.Var1, 'Run2Tgt.OnsetTime'))) - (txt.Var2(matches(txt.Var1, 'Run2Fix.OnsetTime')))) ./1000;
            tgt_dur = repmat("2",[48 1]);
       
            if length(cue_onset1) == length(cue_onset2)
                %cue_rt1 = ((txt.Var2(find(contains(txt.Var1,'Run1Cue.RTTime')))) - (txt.Var2(strcmp(txt.Var1,'Run1Fix.OnsetTime')))) ./ 1000;
                %cue_rt2 = ((txt.Var2(find(contains(txt.Var1,'Run2Cue.RTTime')))) - (txt.Var2(strcmp(txt.Var1,'Run2Fix.OnsetTime')))) ./ 1000;
                cue_dur = repmat("4",[48 1]);
        
                %ITI
                %cue_iti1 = txt.Var2(find(contains(txt.Var1,'Run1Dly3.OnsetTime')));
                %cue_iti2 = txt.Var2(find(contains(txt.Var1,'Run2Dly3.OnsetTime')));
                %trial_dur1 = round(cue_iti1 - cue_onset1);
                %trial_dur2 = round(cue_iti2 - cue_onset2);
        
                %feedback
                fbk_on1 = ((txt.Var2(matches(txt.Var1,'Run1Fbk.OnsetTime'))) - (txt.Var2(strcmp(txt.Var1,'Run1Fix.OnsetTime')))) ./ 1000;
                fbk_on2 = ((txt.Var2(matches(txt.Var1,'Run2Fbk.OnsetTime'))) - (txt.Var2(strcmp(txt.Var1,'Run2Fix.OnsetTime')))) ./ 1000;
                fbk_dur = repmat("4",[48 1]);
        
    %           %RT and accuracy
                rt1 = txt.Var2(matches(txt.Var1, 'Run1Tgt.RT')) ./ 1000;
                rt1(rt1 == 0) = NaN;
                rt2 = txt.Var2(matches(txt.Var1, 'Run2Tgt.RT')) ./ 1000;
                rt2(rt2 == 0) = NaN;
    
                % reward = txt.Var2(matches(txt.Var1, 'Rwd')); %this is for both runs
                % reward1 = reward(1:48);
                % reward2 = reward(49:96);
    
    %           total_earnings = txt.Var2(matches(txt.Var1, 'Total:'));
        
                acc1 = strcat(string(txt.Var2(matches(txt.Var1, 'Run1Tgt.ACC'))),'-');
                %acc1 = ~isnan(rt1)
                acc2 = strcat(string(txt.Var2(matches(txt.Var1, 'Run2Tgt.ACC'))),'-');
                %acc2 = ~isnan(rt2)
        
                acc1 = replace(acc1, '1-','Hit');
                acc1 = replace(acc1, '0-','Miss');
                acc2 = replace(acc2, '1-','Hit');
                acc2 = replace(acc2, '0-','Miss');
        
                %tgt_dur1(tgt_dur1 < 0) = [];
                %tgt_dur2(tgt_dur2 < 0) = [];
        
                trial_type1 = strcat(string(txt.Var2(matches(txt.Var1,'RunList1'))),'-');
                trial_type1 = replace(trial_type1,'1-','Win5');
                trial_type1 = replace(trial_type1,'2-','Win1.5');
                trial_type1 = replace(trial_type1,'3-','Win0');
                trial_type1 = replace(trial_type1,'4-','Lose5');
                trial_type1 = replace(trial_type1,'5-','Lose1.5');
                trial_type1 = replace(trial_type1,'6-','Lose0');
        
                cue_type1 = strcat('ant_',trial_type1);
                fbk_type1 = strcat('out_',trial_type1,'_',acc1);
        
                trial_type2 = strcat(string(txt.Var2(matches(txt.Var1,'RunList2'))),'-');
                trial_type2 = replace(trial_type2,'1-','Win5');
                trial_type2 = replace(trial_type2,'2-','Win1.5');
                trial_type2 = replace(trial_type2,'3-','Win0');
                trial_type2 = replace(trial_type2,'4-','Lose5');
                trial_type2 = replace(trial_type2,'5-','Lose1.5');
                trial_type2 = replace(trial_type2,'6-','Lose0');
        
                cue_type2 = strcat('ant_',trial_type2);
                fbk_type2 = strcat('out_',trial_type2,'_',acc2);
        
                motor = repmat("motor",[48 1]);
        
                %compile variables into events.tsv file
                onset1 = [cue_onset1;tgt_onset1;fbk_on1];
                duration = [cue_dur;tgt_dur;fbk_dur];
                type1 = [cue_type1;motor;fbk_type1];
                
                onset2 = [cue_onset2;tgt_onset2;fbk_on2];
                type2 = [cue_type2;motor;fbk_type2];

                mid_events1 = array2table([onset1,duration,type1]);
                mid_events1.Properties.VariableNames = {'onset', 'duration', 'trial_type'};
        
                mid_txt1 = fullfile(func_dir, strcat('sub-',pid{sub},'_ses-',num2str(ses),'_task-mid_run-01_events.txt'));
                    writetable(mid_events1,mid_txt1,'delimiter','tab')
        
                mid_events2 = array2table([onset2,duration,type2]);
                mid_events2.Properties.VariableNames = {'onset', 'duration', 'trial_type'};
                
                mid_txt2 = fullfile(func_dir, strcat('sub-',pid{sub},'_ses-',num2str(ses),'_task-mid_run-02_events.txt'));
                    writetable(mid_events2,mid_txt2,'delimiter','tab')

                else
                    fprintf(strcat('Only one run for: ',pid{sub},'\n'))
            end
            else
                fprintf(strcat('No MID data for: ',fnames{sub},'\n'))
                rt_avg(sub,1) = NaN;
                acc(sub,1) = NaN;
        end
    end

end

% %% CHATROOM TASK
% if chatroom == 1
%     CRfnames_txt = filenames(fullfile(basedir,'/behavioral/sub-*/ses-',num2str(ses),'/beh/chzc*txt'));
%     CRfnames_csv = filenames(fullfile(basedir,'/behavioral/sub-*/ses-',num2str(ses),'/beh/chzc*csv')); 
%     
%     %% PsychToolbox version of Chatroom, csv file
%     for sub = 1:length(CRfnames_csv)
%         csv = readtable(CRfnames_csv{1});
%         pid = csv.subjectID(1);
%         %ses = CRfnames_csv{1}(87); %RISE 87
%     
%         %pull onset, duration, trial type , and response time variables into events.tsv file
%         onset = csv.trialOnset;
%         duration = (csv.trialOffset - csv.trialOnset); %should be 4
%         block_num = csv.blockNumber; %1 is participant, 2 and 3 are acc/rej, 4 is control
%         block_agent = cell2table(csv.blockAgent); %who is making selections
%         block_agent.Properties.VariableNames = {'block_agent'};
%         topic = cell2table(csv.trialTopic);
%         topic.Properties.VariableNames = {'topic'};
%         
%         player_selected = cell2table(csv.trialPlayerSelected); %need logic to address NaNs/when P doesn't make a selection
%         player_selected.Properties.VariableNames = {'player_selected'};
%         
%         jitter = csv.trialITIj;
%         response_time = csv.trialRT;
%         feedback_dur = (csv.trialFeedbackOffset - csv.trialFeedbackOnset); %should be 8
%     
%         events = array2table([onset, duration, block_num]);
%         events.Properties.VariableNames = {'onset', 'duration', 'block_number'}
%         events = ([events, block_agent, topic, player_selected]);
%         events_cont = array2table([jitter, response_time, feedback_dur]);
%         events_cont.Properties.VariableNames = {'jitter', 'RT', 'feedback_duration'}
%         events = ([events, events_cont])
%     
%         %write to tsv file
%         curr_filename = fullfile(basedir, "behavioral/", strcat('sub-',pid,'/ses-',ses,'/func/sub-',pid,'_ses-',ses,'_task-chatroom_run-01_events.tsv')); 
%                 writetable(events,curr_filename,'delimiter','tab')
%     end
%     
%     %% E-Prime version of Chatroom, txt file
%     for sub = 1:length(CRfnames_txt)
%         txt = readtable(CRfnames_txt{1});
%         pid = txt.Var2(matches(txt.Var1, 'Subject'));
%         pid = pid(1)
%         ses = txt.Var2(matches(txt.Var1, 'Session'));
%         ses = ses(1)
%     
%         onset = txt.Var2(matches(txt.Var1,'ChzT.OnsetTime')) ./ 1000;
%         duration =  %should be 4
%         block_num =  %not sure where I'm pulling this from in the output
%         block_agent = txt.Var2(matches(txt.Var1,'List1.Sample')) %I think this is one of the List vars but idk my head hurts
%     
%         topic = strcat(string(txt.Var2(matches(txt.Var1,'TopicNumber'))));
%         topic = replace(trial_type1,'10','Computers');
%         topic = replace(trial_type1,'11','Pets');
%         topic = replace(trial_type1,'12','Books');
%         topic = replace(trial_type1,'13','Friends');
%         topic = replace(trial_type1,'14','Family');
%         topic = replace(trial_type1,'15','Sports');
%         topic = replace(trial_type1,'1','School');
%         topic = replace(trial_type1,'2','Parties');
%         topic = replace(trial_type1,'3','Vacations');
%         topic = replace(trial_type1,'4','Hobbies');
%         topic = replace(trial_type1,'5','Music');
%         topic = replace(trial_type1,'6','TV');
%         topic = replace(trial_type1,'7','Movies');
%         topic = replace(trial_type1,'8','Food');
%         topic = replace(trial_type1,'9','Shopping');
%     
%         player_selected = txt.Var2(matches(txt.Var1,'ChzT.RESP'))
%         jitter = txt.Var2(matches(txt.Var1,'ITIj')) ./ 1000;
%         response_time = txt.Var2(matches(txt.Var1,'ChzT.RT')) ./ 1000;
%     
%         feedback_onset = txt.Var2(matches(txt.Var1,'ShwT.OnsetTime')) ./ 1000;
%         feedback_dur = 
%     
%         cr_events = array2table
%         cr_events.Properties.VariableNames = {'onset', 'duration', 'block_number',...
%             'block_agent', 'topic', 'player_selected', 'jitter', 'reaction_time', 'feedback_duration'}
%     
%         cr_txt = fullfile(basedir, "behavioral/", strcat('sub-',pid,'/ses-',ses,'/func/sub-',pid,'_ses-',ses,'_task-chatroom_run-01_events.txt'));
%             writetable(cr_events,cr_txt,'delimiter','tab')
%     end
% end