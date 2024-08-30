%%Create BIDS-compliant events.tsv files for functional scans
%Author: Nina Kougan (ninakougan@northwestern.edu)
%Last updated: 07/11/24

basedir = '/projects/b1108/studies/rise/data/raw/neuroimaging/';
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
        try
            % Load in the text file
            txt = readtable(MIDfnames{sub});
            pid{sub} =  MIDfnames{sub}(67:71); % RISE %(72:77);% CREST (70:75); %RISE on Quest (67:71)
            %keyboard
            func_dir = fullfile(basedir,'bids/events_files',strcat('sub-',pid{sub},'/ses-',num2str(ses),'/func/'));
            mkdir(func_dir);
            if isempty(txt) == 0
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
        
                    %RT and accuracy
                    rt1 = txt.Var2(matches(txt.Var1, 'Run1Tgt.RT')) ./ 1000;
                    rt1(rt1 == 0) = NaN;
                    rt2 = txt.Var2(matches(txt.Var1, 'Run2Tgt.RT')) ./ 1000;
                    rt2(rt2 == 0) = NaN;
    
                    % reward = txt.Var2(matches(txt.Var1, 'Rwd')); %this is for both runs
                    % reward1 = reward(1:48);
                    % reward2 = reward(49:96);
    
                    %total_earnings = txt.Var2(matches(txt.Var1, 'Total:'));
        
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
        catch ME
            fprintf('An error occurred with PID: %s. Skipping to the next PID.\n', pid{sub});
            fprintf('Error message: %s\n', ME.message);
            continue; % Skip to the next PID
        end
    end

end

%%CHATROOM TASK
if chatroom == 1
    CRfnames_txt = filenames(fullfile(basedir, '/behavioral/sub-*/ses-', num2str(ses), '/beh/chzc*txt'));
    CRfnames_csv = filenames(fullfile(strcat(basedir, '/behavioral/sub-*/ses-', num2str(ses), '/beh/chzc*csv'))); 

    % PsychToolbox version of Chatroom, csv file
    for sub = 1:length(CRfnames_csv)
        csv_filename = CRfnames_csv{sub};
        csv = readtable(csv_filename);

        % Assuming csv.subjectID(1) retrieves the first participant ID
        pid = csv.subjectID(1); 

        func_dir = fullfile(basedir,'bids',strcat('sub-',num2str(pid),'/ses-',num2str(ses),'/func/'));
        if ~exist(func_dir, 'dir')
            mkdir(func_dir);
        end

        % % Check if all trialPlayerSelected are missing values
        % if all(ismissing(csv.trialPlayerSelected))
        %     disp(['Error with data for sub-', num2str(pid)]);
        %     continue; % Skip to the next iteration
        % end

        % Pull onset, duration, and trial type into events.tsv file
        onset = csv.trialOnset;
        duration = repmat("4", [height(csv), 1]);
        trial_type = strings(height(csv), 1);
        topic = csv.trialTopic;
        rt = csv.trialRT;
        
        for i = 1:height(csv)
            if csv.blockNumber(i) == 2 || csv.blockNumber(i) == 3
                if strcmp(csv.trialCorrectSelection(i), csv.blockAgent(1))
                    trial_type(i) = 'acceptance';
                else
                    trial_type(i) = 'rejection';
                end
            elseif csv.blockNumber(i) == 1
                trial_type(i) = 'player_selects';
            elseif csv.blockNumber(i) == 4
                trial_type(i) = 'control';
            else
                disp(['Error: Unexpected blockNumber for sub-', num2str(pid), ', ses-', num2str(ses)]);
            end
        end
        
        cr_events = table(onset, duration, trial_type);
        cr_events.Properties.VariableNames = {'onset', 'duration', 'trial_type'};
        
        % Write to txt file
        cr_txt_filename = fullfile(func_dir, ['sub-', num2str(pid), '_ses-', num2str(ses), '_task-chatroom_run-01_events.txt']);
        writetable(cr_events, cr_txt_filename, 'Delimiter', 'tab');
    end

    %% E-Prime version of Chatroom, txt file
    % for sub = 1:length(CRfnames_txt)
    %     txt = readtable(CRfnames_txt{1});
    %     pid = txt.Var2(matches(txt.Var1, 'Subject'));
    %     pid = pid(1)
    %     ses = txt.Var2(matches(txt.Var1, 'Session'));
    %     ses = ses(1)
    % 
    %     onset = txt.Var2(matches(txt.Var1,'ChzT.OnsetTime')) ./ 1000;
    %     duration = repmat("4", [height(csv), 1]);
    %     trial_type = strings(height(csv), 1);
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
    %     %jitter = txt.Var2(matches(txt.Var1,'ITIj')) ./ 1000;
    %     %response_time = txt.Var2(matches(txt.Var1,'ChzT.RT')) ./ 1000;
    % 
    %     %feedback_onset = txt.Var2(matches(txt.Var1,'ShwT.OnsetTime')) ./ 1000;
    %     &feedback_dur = 
    % 
    %     cr_events = array2table
    %     cr_events.Properties.VariableNames = {'onset', 'duration', 'trial_type'}
    % 
    %     cr_txt = fullfile(basedir, "behavioral/", strcat('sub-',pid,'/ses-',ses,'/func/sub-',pid,'_ses-',ses,'_task-chatroom_run-01_events.txt'));
    %         writetable(cr_events,cr_txt,'delimiter','tab')
    % end
end