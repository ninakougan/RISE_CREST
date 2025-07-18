basedir = '/projects/b1108/studies/rise/data/processed/neuroimaging/behavioral';
savedir = '/projects/b1108/studies/rise/data/processed/neuroimaging/fmriprep/ses-1/timing_files';

mid = 1;
chat = 0;
chat_matlab = 0;
ses = 1;

if mid == 1
    fnames = filenames(fullfile(basedir,['sub-*/ses-' num2str(ses) '/beh/3_*txt'));
    for sub = 1:length(fnames)
        txt = readtable(fnames{sub});
        pid{sub} =  fnames{sub}(73:77);
        keyboard

        cue_on1_raw = txt.Var2(find(contains(txt.Var1,'Run1Cue.OnsetTime')));
        cue_on2_raw = txt.Var2(find(contains(txt.Var1,'Run2Cue.OnsetTime')));
        tgt_on1_raw = txt.Var2(find(contains(txt.Var1,'Run1Tgt.OnsetTime')));
        tgt_on2_raw = txt.Var2(find(contains(txt.Var1,'Run2Tgt.OnsetTime')));
        fbk_on1_raw = txt.Var2(find(contains(txt.Var1,'Run1Fbk.OnsetTime')));
        fbk_on2_raw = txt.Var2(find(contains(txt.Var1,'Run2Fbk.OnsetTime')));
        dly_on1_raw = txt.Var2(find(contains(txt.Var1,'Run1Dly3.OnsetTime')));
        dly_on2_raw = txt.Var2(find(contains(txt.Var1,'Run2Dly3.OnsetTime')));

        cue_on1 = (cue_on1_raw - txt.Var2(strcmp(txt.Var1,'Run1Fix.OnsetTime'))) ./ 1000;
        cue_on2 = (cue_on2_raw - txt.Var2(strcmp(txt.Var1,'Run2Fix.OnsetTime'))) ./ 1000;
        tgt_on1 = (tgt_on1_raw - txt.Var2(strcmp(txt.Var1,'Run1Fix.OnsetTime'))) ./ 1000;
        tgt_on2 = (tgt_on2_raw - txt.Var2(strcmp(txt.Var1,'Run2Fix.OnsetTime'))) ./ 1000;
        fbk_on1 = (fbk_on1_raw - txt.Var2(strcmp(txt.Var1,'Run1Fix.OnsetTime'))) ./ 1000;
        fbk_on2 = (fbk_on2_raw - txt.Var2(strcmp(txt.Var1,'Run2Fix.OnsetTime'))) ./ 1000;

        cue_dur1 = (tgt_on1_raw - cue_on1_raw) ./ 1000;
        cue_dur2 = (tgt_on2_raw - cue_on2_raw) ./ 1000;
        tgt_dur1 = (fbk_on1_raw - tgt_on1_raw) ./ 1000;
        tgt_dur2 = (fbk_on2_raw - tgt_on2_raw) ./ 1000;
        fbk_dur1 = (dly_on1_raw - fbk_on1_raw) ./ 1000;
        fbk_dur2 = (dly_on2_raw - fbk_on2_raw) ./ 1000;

        acc_on1 = txt.Var2(strcmp(txt.Var1,'Run1Tgt.ACC'));
        acc_on2 = txt.Var2(strcmp(txt.Var1,'Run2Tgt.ACC'));

        trial_type1 = strcat(string(txt.Var2(find(strcmp(txt.Var1,'RunList1')))),'-');
        trial_type2 = strcat(string(txt.Var2(find(strcmp(txt.Var1,'RunList2')))),'-');
        trial_type1 = replace(trial_type1, {'1-','2-','3-','4-','5-','6-'}, {'Run1 Win $5.00','Run1 Win $1.50','Run1 Win $0.00','Run1 Lose $5.00','Run1 Lose $1.50','Run1 Lose $0.00'});
        trial_type2 = replace(trial_type2, {'1-','2-','3-','4-','5-','6-'}, {'Run2 Win $5.00','Run2 Win $1.50','Run2 Win $0.00','Run2 Lose $5.00','Run2 Lose $1.50','Run2 Lose $0.00'});

        % --- Run 1 ---
        onsets{1} = cue_on1(strcmp(trial_type1,'Run1 Win $5.00') | strcmp(trial_type1,'Run1 Win $1.50'))';
        durations{1} = cue_dur1(strcmp(trial_type1,'Run1 Win $5.00') | strcmp(trial_type1,'Run1 Win $1.50'))';
        onsets{2} = cue_on1(strcmp(trial_type1,'Run1 Win $0.00'))';
        durations{2} = cue_dur1(strcmp(trial_type1,'Run1 Win $0.00'))';
        onsets{3} = cue_on1(strcmp(trial_type1,'Run1 Lose $5.00') | strcmp(trial_type1,'Run1 Lose $1.50'))';
        durations{3} = cue_dur1(strcmp(trial_type1,'Run1 Lose $5.00') | strcmp(trial_type1,'Run1 Lose $1.50'))';
        onsets{4} = cue_on1(strcmp(trial_type1,'Run1 Lose $0.00'))';
        durations{4} = cue_dur1(strcmp(trial_type1,'Run1 Lose $0.00'))';
        onsets{5} = tgt_on1'; durations{5} = tgt_dur1';
        names = {'GainAnticipation','Gain0Anticipation','LossAnticipation','Loss0Anticipation','Motor'};
        save(fullfile(savedir, strcat('sub-', pid{sub}, '_ses-', num2str(ses), '_task-mid_run-01_anticipation_timing.mat')), 'onsets','durations','names'); clear onsets durations names

        corrfbk1 = fbk_on1(acc_on1==1); corrtype1 = trial_type1(acc_on1==1);
        incorrfbk1 = fbk_on1(acc_on1==0); incorrtype1 = trial_type1(acc_on1==0);
        corrdur1 = fbk_dur1(acc_on1==1); incorrdur1 = fbk_dur1(acc_on1==0);
        onsets{1} = corrfbk1(strcmp(corrtype1,'Run1 Win $5.00') | strcmp(corrtype1,'Run1 Win $1.50'))'; durations{1} = corrdur1(strcmp(corrtype1,'Run1 Win $5.00') | strcmp(corrtype1,'Run1 Win $1.50'))';
        onsets{2} = incorrfbk1(strcmp(incorrtype1,'Run1 Win $5.00') | strcmp(incorrtype1,'Run1 Win $1.50'))'; durations{2} = incorrdur1(strcmp(incorrtype1,'Run1 Win $5.00') | strcmp(incorrtype1,'Run1 Win $1.50'))';
        onsets{3} = corrfbk1(strcmp(corrtype1,'Run1 Lose $5.00') | strcmp(corrtype1,'Run1 Lose $1.50'))'; durations{3} = corrdur1(strcmp(corrtype1,'Run1 Lose $5.00') | strcmp(corrtype1,'Run1 Lose $1.50'))';
        onsets{4} = incorrfbk1(strcmp(incorrtype1,'Run1 Lose $5.00') | strcmp(incorrtype1,'Run1 Lose $1.50'))'; durations{4} = incorrdur1(strcmp(incorrtype1,'Run1 Lose $5.00') | strcmp(incorrtype1,'Run1 Lose $1.50'))';
        onsets{5} = tgt_on1'; durations{5} = tgt_dur1';
        names = {'SuccessWin','UnsuccessWin','SuccessLoss','UnsuccessLoss','Motor'};
        save(fullfile(savedir, strcat('sub-', pid{sub}, '_ses-', num2str(ses), '_task-mid_run-01_outcome_timing.mat')), 'onsets','durations','names'); clear onsets durations names

        % --- Run 2 --- (repeat logic with cue_on2, etc.)
        onsets{1} = cue_on2(strcmp(trial_type2,'Run2 Win $5.00') | strcmp(trial_type2,'Run2 Win $1.50'))';
        durations{1} = cue_dur2(strcmp(trial_type2,'Run2 Win $5.00') | strcmp(trial_type2,'Run2 Win $1.50'))';
        onsets{2} = cue_on2(strcmp(trial_type2,'Run2 Win $0.00'))';
        durations{2} = cue_dur2(strcmp(trial_type2,'Run2 Win $0.00'))';
        onsets{3} = cue_on2(strcmp(trial_type2,'Run2 Lose $5.00') | strcmp(trial_type2,'Run2 Lose $1.50'))';
        durations{3} = cue_dur2(strcmp(trial_type2,'Run2 Lose $5.00') | strcmp(trial_type2,'Run2 Lose $1.50'))';
        onsets{4} = cue_on2(strcmp(trial_type2,'Run2 Lose $0.00'))';
        durations{4} = cue_dur2(strcmp(trial_type2,'Run2 Lose $0.00'))';
        onsets{5} = tgt_on2'; durations{5} = tgt_dur2';
        names = {'GainAnticipation','Gain0Anticipation','LossAnticipation','Loss0Anticipation','Motor'};
        save(fullfile(savedir, strcat('sub-', pid{sub}, '_ses-', num2str(ses), '_task-mid_run-02_anticipation_timing.mat')), 'onsets','durations','names'); clear onsets durations names

        corrfbk2 = fbk_on2(acc_on2==1); corrtype2 = trial_type2(acc_on2==1);
        incorrfbk2 = fbk_on2(acc_on2==0); incorrtype2 = trial_type2(acc_on2==0);
        corrdur2 = fbk_dur2(acc_on2==1); incorrdur2 = fbk_dur2(acc_on2==0);
        onsets{1} = corrfbk2(strcmp(corrtype2,'Run2 Win $5.00') | strcmp(corrtype2,'Run2 Win $1.50'))'; durations{1} = corrdur2(strcmp(corrtype2,'Run2 Win $5.00') | strcmp(corrtype2,'Run2 Win $1.50'))';
        onsets{2} = incorrfbk2(strcmp(incorrtype2,'Run2 Win $5.00') | strcmp(incorrtype2,'Run2 Win $1.50'))'; durations{2} = incorrdur2(strcmp(incorrtype2,'Run2 Win $5.00') | strcmp(incorrtype2,'Run2 Win $1.50'))';
        onsets{3} = corrfbk2(strcmp(corrtype2,'Run2 Lose $5.00') | strcmp(corrtype2,'Run2 Lose $1.50'))'; durations{3} = corrdur2(strcmp(corrtype2,'Run2 Lose $5.00') | strcmp(corrtype2,'Run2 Lose $1.50'))';
        onsets{4} = incorrfbk2(strcmp(incorrtype2,'Run2 Lose $5.00') | strcmp(incorrtype2,'Run2 Lose $1.50'))'; durations{4} = incorrdur2(strcmp(incorrtype2,'Run2 Lose $5.00') | strcmp(incorrtype2,'Run2 Lose $1.50'))';
        onsets{5} = tgt_on2'; durations{5} = tgt_dur2';
        names = {'SuccessWin','UnsuccessWin','SuccessLoss','UnsuccessLoss','Motor'};
        save(fullfile(savedir, strcat('sub-', pid{sub}, '_ses-', num2str(ses), '_task-mid_run-02_outcome_timing.mat')), 'onsets','durations','names'); clear onsets durations names
    end
end

% ------------------ CHATROOM (E-PRIME VERSION) ------------------
if chat == 1
    fnames = filenames(fullfile(basedir,['sub-*/ses-' num2str(ses) '/beh/chzc*txt'));
    for sub = 1:length(fnames)
        txt = readtable(fnames{sub});
        pid{sub} = fnames{sub}(73:77);

        chzt_on = txt.Var2(find(contains(txt.Var1,'ChzT.OnsetTime')));
        shwt_on = txt.Var2(find(contains(txt.Var1,'ShwT.OnsetTime')));
        selSub = txt.Var2(find(contains(txt.Var1,'SelSubj')));

        selb2 = selSub(1:15); selb3 = selSub(16:30);
        chzb2 = (chzt_on(1:15) - chzt_on(1))./1000;
        chzb3 = (chzt_on(16:30) - chzt_on(1))./1000;
        chzb4 = (chzt_on(31:45) - chzt_on(1))./1000;
        showb2 = (shwt_on(1:15) - chzt_on(1))./1000;
        showb3 = (shwt_on(16:30) - chzt_on(1))./1000;
        showb4 = (shwt_on(31:45) - chzt_on(1))./1000;

        durb2 = (shwt_on(1:15) - chzt_on(1:15))./1000;
        durb3 = (shwt_on(16:30) - chzt_on(16:30))./1000;
        durb4 = (shwt_on(31:45) - chzt_on(31:45))./1000;

        is_even = mod(str2double(pid{sub}), 2) == 0;

        if is_even
            self_acc = showb3(selb3==2);
            self_rej = showb3(selb3==0);
            other_acc = showb2(selb2==2);
            other_rej = showb2(selb2==0);

            self_dur_acc = durb3(selb3==2);
            self_dur_rej = durb3(selb3==0);
            other_dur_acc = durb2(selb2==2);
            other_dur_rej = durb2(selb2==0);

            self_onset_acc = chzb3(selb3==2);
            self_onset_rej = chzb3(selb3==0);
            other_onset_acc = chzb2(selb2==2);
            other_onset_rej = chzb2(selb2==0);
        else
            self_acc = showb2(selb2==2);
            self_rej = showb2(selb2==0);
            other_acc = showb3(selb3==2);
            other_rej = showb3(selb3==0);

            self_dur_acc = durb2(selb2==2);
            self_dur_rej = durb2(selb2==0);
            other_dur_acc = durb3(selb3==2);
            other_dur_rej = durb3(selb3==0);

            self_onset_acc = chzb2(selb2==2);
            self_onset_rej = chzb2(selb2==0);
            other_onset_acc = chzb3(selb3==2);
            other_onset_rej = chzb3(selb3==0);
        end

        control = showb4';

        anticipation_names = {'SelfAnticipationAccepted','SelfAnticipationRejected','OtherAnticipationAccepted','OtherAnticipationRejected'};
        anticipation_onsets = {self_onset_acc+4.05, self_onset_rej+4.05, other_onset_acc+4.05, other_onset_rej+4.05};
        anticipation_durations = {self_dur_acc', self_dur_rej', other_dur_acc', other_dur_rej'};

        feedback_onsets = {self_acc'+4.05, self_rej'+4.05, other_acc'+4.05, other_rej'+4.05};
        feedback_durations = {self_dur_acc', self_dur_rej', other_dur_acc', other_dur_rej'};
        feedback_names = {'SelfFeedbackAccepted','SelfFeedbackRejected','OtherFeedbackAccepted','OtherFeedbackRejected'};

        outcome_names = {'SelfChoiceAccepted','SelfChoiceRejected','OtherChoiceAccepted','OtherChoiceRejected','ControlShow'};
        outcome_onsets = {self_acc'+4.05, self_rej'+4.05, other_acc'+4.05, other_rej'+4.05, showb4'+4.05};
        outcome_durations = {self_dur_acc', self_dur_rej', other_dur_acc', other_dur_rej', durb4'};

        names = [anticipation_names, feedback_names, outcome_names];
        onsets = [anticipation_onsets, feedback_onsets, outcome_onsets];
        durations = [anticipation_durations, feedback_durations, outcome_durations];

        save(fullfile(savedir, strcat('sub-', pid{sub}, '_ses-', num2str(ses), '_task-chatroom_run-1_timing.mat')), 'onsets','durations','names');
        clear onsets durations names anticipation_onsets anticipation_durations anticipation_names
    end
end

% ------------------ CHATROOM (MATLAB VERSION) ------------------
if chat_matlab == 1
    fnames = filenames(fullfile(basedir, ['sub-*/ses-' num2str(ses) '/beh/*.csv']));
    for sub = 1:length(fnames)
        pid{sub} = fnames{sub}(73:77);
        T = readtable(fnames{sub});

        participant = T.blockAgent{1};
        is_even = mod(str2double(pid{sub}), 2) == 0;

        chzT = T.trialOnset;
        shwT = T.trialFeedbackOnset;
        selected_personb2 = T.trialCorrectSelection(16:30);
        selected_personb3 = T.trialCorrectSelection(31:45);

        durb2 = shwT(16:30) - chzT(16:30);
        durb3 = shwT(31:45) - chzT(31:45);
        durb4 = shwT(46:60) - chzT(46:60);

        if is_even
            self_acc = shwT(31:45(strcmp(selected_personb3, participant)))';
            self_rej = shwT(31:45(~strcmp(selected_personb3, participant)))';
            other_acc = shwT(16:30(strcmp(selected_personb2, participant)))';
            other_rej = shwT(16:30(~strcmp(selected_personb2, participant)))';

            self_dur_acc = durb3(strcmp(selected_personb3, participant));
            self_dur_rej = durb3(~strcmp(selected_personb3, participant));
            other_dur_acc = durb2(strcmp(selected_personb2, participant));
            other_dur_rej = durb2(~strcmp(selected_personb2, participant));

            self_onset_acc = chzT(31:45(strcmp(selected_personb3, participant)));
            self_onset_rej = chzT(31:45(~strcmp(selected_personb3, participant)));
            other_onset_acc = chzT(16:30(strcmp(selected_personb2, participant)));
            other_onset_rej = chzT(16:30(~strcmp(selected_personb2, participant)));
        else
            self_acc = shwT(16:30(strcmp(selected_personb2, participant)))';
            self_rej = shwT(16:30(~strcmp(selected_personb2, participant)))';
            other_acc = shwT(31:45(strcmp(selected_personb3, participant)))';
            other_rej = shwT(31:45(~strcmp(selected_personb3, participant)))';

            self_dur_acc = durb2(strcmp(selected_personb2, participant));
            self_dur_rej = durb2(~strcmp(selected_personb2, participant));
            other_dur_acc = durb3(strcmp(selected_personb3, participant));
            other_dur_rej = durb3(~strcmp(selected_personb3, participant));

            self_onset_acc = chzT(16:30(strcmp(selected_personb2, participant)));
            self_onset_rej = chzT(16:30(~strcmp(selected_personb2, participant)));
            other_onset_acc = chzT(31:45(strcmp(selected_personb3, participant)));
            other_onset_rej = chzT(31:45(~strcmp(selected_personb3, participant)));
        end

        control = shwT(46:60)';

        anticipation_names = {'SelfAnticipationAccepted','SelfAnticipationRejected','OtherAnticipationAccepted','OtherAnticipationRejected'};
        anticipation_onsets = {self_onset_acc', self_onset_rej', other_onset_acc', other_onset_rej'};
        anticipation_durations = {self_dur_acc', self_dur_rej', other_dur_acc', other_dur_rej'};

        feedback_onsets = {self_acc, self_rej, other_acc, other_rej};
        feedback_durations = {self_dur_acc', self_dur_rej', other_dur_acc', other_dur_rej'};
        feedback_names = {'SelfFeedbackAccepted','SelfFeedbackRejected','OtherFeedbackAccepted','OtherFeedbackRejected'};

        outcome_names = {'SelfChoiceAccepted','SelfChoiceRejected','OtherChoiceAccepted','OtherChoiceRejected','ControlShow'};
        outcome_onsets = {self_acc, self_rej, other_acc, other_rej, control};
        outcome_durations = {self_dur_acc', self_dur_rej', other_dur_acc', other_dur_rej', durb4'};

        names = [anticipation_names, feedback_names, outcome_names];
        onsets = [anticipation_onsets, feedback_onsets, outcome_onsets];
        durations = [anticipation_durations, feedback_durations, outcome_durations];

        save(fullfile(savedir, strcat('sub-', pid{sub}, '_ses-', num2str(ses), '_task-chatroom_run-', num2str(run), '_timing.mat')), 'onsets','durations','names');
    end
end

% ------------------ SUMMARY OF MISSING FILES ------------------
all_chat_ids = unique([chat_missing, chatmat_missing]);
if ~isempty(mid_missing_run1) || ~isempty(mid_missing_run2)
    disp('Subjects with missing MID timing files:');
    if ~isempty(mid_missing_run1)
        disp('  Missing Run 1:'); disp(mid_missing_run1);
    end
    if ~isempty(mid_missing_run2)
        disp('  Missing Run 2:'); disp(mid_missing_run2);
    end
end
if ~isempty(all_chat_ids)
    disp('Subjects with missing CHATROOM timing files (E-Prime or MATLAB):');
    disp(all_chat_ids);
end
chatmat_missing = {};
