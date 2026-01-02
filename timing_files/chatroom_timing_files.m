%% RISE and CREST Chatroom Timing Files for BIDS and SPM
%% Author: Nina Kougan (ninakougan@u.northwestern.edu)
%% Last Updated: 1/02/2026

% what do you want to do
PTB_bids_files = 1; % psychtoolbox files
EP_bids_files = 1; % eprime files
spm_files = 1; % spm files
sanity_check = 0; % behavioral sanity check for missing/incorrect responses
%%sanity check still WIP -- would not recommend using rn!

%which study and session
study   = 'crest';   % rise or crest
session = 1;        % 1, 2, or 3

%where's the data?
basedir = fullfile('/projects/b1108/studies', study, 'data'); %  /Users/ninakougan/Documents/acnl
bidsdir = fullfile(basedir, 'raw/neuroimaging/bids');
behdir = fullfile(basedir, 'raw/neuroimaging/behavioral');
procdir = fullfile(basedir, 'processed', 'neuroimaging', 'fmriprep', ['ses-' num2str(session)]);
%keyboard

%%psychtoolbox csvs
if PTB_bids_files == 1;
    fnames = filenames(fullfile(behdir, 'sub-*', ['ses-' num2str(session)], 'beh', 'chzc*csv'));
    
    for f = 1:length(fnames)
        inFile = fnames{f};
        data   = readtable(inFile);
        pid = num2str(data.subjectID(1));
        try
            %pull participant name from block 1
            b1    = data(data.blockNumber == 1, :);
            agent = char(b1.blockAgent(1));
    
            %file structure, 2 rows per trial
            n = height(data);
            onset = zeros(n*2,1);
            duration = zeros(n*2,1);
            trialType = strings(n*2,1);
            idx = 0;
   
            for i = 1:n
                blk  = data.blockNumber(i);
                on   = data.trialOnset(i);
                off  = data.trialOffset(i);
                fOn  = data.trialFeedbackOnset(i);
                fOff = data.trialFeedbackOffset(i);
    
                %choice row
                idx = idx + 1;
                onset(idx)    = on;
                duration(idx) = off - on;
                if blk == 1
                    trialType(idx) = "participant_choice";
                elseif blk == 4
                    trialType(idx) = "control_choice";
                else
                    trialType(idx) = "confederate_choice";
                end
    
                %feedback row
                idx = idx + 1;
                onset(idx)    = fOn;
                duration(idx) = fOff - fOn;
                if blk == 1
                    trialType(idx) = "choice_feedback";
                elseif blk == 4
                    trialType(idx) = "control_feedback";
                else
                    sel = string(data.trialCorrectSelection(i));
                    if strcmp(char(data.trialCorrectSelection(i)), agent)
                        trialType{idx} = 'feedback_acceptance';
                    else
                        trialType{idx} = 'feedback_rejection';
                    end
                end
            end
    
            %write 
            events = table(onset(1:idx), duration(1:idx), trialType(1:idx), ...
                           'VariableNames', {'onset','duration','trial_type'});
    
            %write to sub-#/ses-#/func
            subdir = fullfile(bidsdir, sprintf('sub-%s', pid), sprintf('ses-%d', session), 'func');
            if ~exist(subdir, 'dir'), mkdir(subdir); end
            events_file = fullfile(subdir, sprintf('sub-%s_ses-%d_task-chatroom_run-01_events.tsv', pid, session));
            writetable(events, events_file, 'FileType','text', 'Delimiter','\t', 'QuoteStrings', false);
            fprintf('Wrote %s (%d rows)\n', events_file, height(events));
    
        catch ME
        %print PID, error message, and line number
            if exist('pid','var') && ~isempty(pid)
                fprintf('PID %s failed on line %d: %s\n', pid, ME.stack(1).line, ME.message);
            end
        end
    end
end

%%E-prime output
if EP_bids_files == 1;
    if session == 1
        eprefix = 'T1';
    elseif session == 2
        eprefix = 'T3';
    elseif session == 3
        eprefix = 'T5';
    end

    eprime_file = fullfile(behdir, sprintf('%s_%s_chatroom_eprime_output.txt', upper(study), eprefix)); 
    
    scan_offset = 4.05;  %one TR plus a 2 second delay, based off Busra's notes bc eprime doesn't track

    E = readtable(eprime_file);
    pids = unique(E.Subject(~isnan(E.Subject)));

    for p = 1:numel(pids)
    pid = pids(p);
    S = E(E.Subject == pid, :);

    try
        %%%eprime is shitty so Block 1 is 9; 2 is 10; 3 is 11; and 4 is 12%%%
        %anchor to first onset in the first actual block
        B1 = S(S.Block == 9 | S.Block == 17, :);
        t0 = min(B1.ChzT_OnsetTime, [], 'omitnan');  % ms

    
        onset = [];
        dur   = [];
        ttype = strings(0,1);
    
        %change ms to s
        ms2s = @(ms) ((ms - t0)./1000) + scan_offset;
    
            %block 1
            B = S(S.Block == 9  | S.Block == 17, :);
            if ~isempty(B)
                for i = 1:height(B)
                    %participant_choice: onset = ChzT_OnsetTime, duration = 4
                    onset(end+1,1) = ms2s(B.ChzT_OnsetTime(i));
                    dur(end+1,1)   = 4;
                    ttype(end+1,1) = "participant_choice";
    
                    %choice_feedback: onset = ShwT_OnsetTime, duration = 8
                    onset(end+1,1) = ms2s(B.ShwT_OnsetTime(i));
                    dur(end+1,1)   = 8;
                    ttype(end+1,1) = "choice_feedback";
                end
            end
    
            %block 2
            B = S(S.Block == 10  | S.Block == 18, :);
            if ~isempty(B)
                for i = 1:height(B)
                    %confederate_choice: onset = ChzT_OnsetTime, duration = 4
                    onset(end+1,1) = ms2s(B.ChzT_OnsetTime(i));
                    dur(end+1,1)   = 4;
                    ttype(end+1,1) = "confederate_choice";
    
                    %feedback_acceptance/rejection: onset = Shw2_OnsetTime, duration = 8
                    onset(end+1,1) = ms2s(B.Shw2_OnsetTime(i));
                    dur(end+1,1)   = 8;
                    if B.SelSubj(i) == 2
                        ttype(end+1,1) = "feedback_acceptance";
                    else
                        %SelSubj==0 -> rejection; treat non-2 as rejection
                        ttype(end+1,1) = "feedback_rejection";
                    end
                end
            end
    
            %block 3
            B = S(S.Block == 11  | S.Block == 19, :);
            if ~isempty(B)
                for i = 1:height(B)
                    %confederate_choice
                    onset(end+1,1) = ms2s(B.ChzT_OnsetTime(i));
                    dur(end+1,1)   = 4;
                    ttype(end+1,1) = "confederate_choice";
    
                    %feedback_acceptance/rejection
                    onset(end+1,1) = ms2s(B.Shw2_OnsetTime(i));
                    dur(end+1,1)   = 8;
                    if B.SelSubj(i) == 2
                        ttype(end+1,1) = "feedback_acceptance";
                    else
                        ttype(end+1,1) = "feedback_rejection";
                    end
                end
            end
    
            %block 4
            B = S(S.Block == 12  | S.Block == 20, :);
            if ~isempty(B)
                for i = 1:height(B)
                    %neutral_choice: onset = ChzT6_OnsetTime, duration = 4
                    onset(end+1,1) = ms2s(B.ChzT6_OnsetTime(i));
                    dur(end+1,1)   = 4;
                    ttype(end+1,1) = "control_choice";
    
                    %feedback_neutral: onset = Shw6_OnsetTime, duration = 8
                    onset(end+1,1) = ms2s(B.Shw6_OnsetTime(i));
                    dur(end+1,1)   = 8;
                    ttype(end+1,1) = "control_feedback";
                end
            end
    
            %put those inchronological order
            [onset_sorted, ord] = sort(onset);
            events = table(onset_sorted, dur(ord), ttype(ord), ...
                'VariableNames', {'onset','duration','trial_type'});
    
            % >>> write to sub-#/ses-#/func
            subdir = fullfile(bidsdir, sprintf('sub-%d', pid), sprintf('ses-%d', session), 'func');
            if ~exist(subdir, 'dir'), mkdir(subdir); end
            events_file = fullfile(subdir, sprintf('sub-%d_ses-%d_task-chatroom_run-01_events.tsv', pid, session));
            writetable(events, events_file, 'FileType','text', 'Delimiter','\t', 'QuoteStrings', false);
            fprintf('Wrote %s (%d rows)\n', events_file, height(events));
 
        catch ME
        %Print PID, error message, and line num
            if exist('pid','var') && ~isempty(pid)
                fprintf('PID %s failed on line %d: %s\n', pid, ME.stack(1).line, ME.message);
            end
        end
    end
end

%%SPM timing for first levels
if spm_files == 1
    events_fnames = filenames(fullfile(bidsdir, 'sub-*', sprintf('ses-%d', session), 'func', '*task-chatroom_run-01_events.tsv'));
    outdir = fullfile(procdir, 'spm_timing_files');
        if ~exist(outdir, 'dir'), mkdir(outdir); end
 
    for k = 1:length(events_fnames)
        %pull 'sub-#####' as pid
        m = regexp(events_fnames{k}, '(sub-\d+)', 'tokens', 'once');
        assert(~isempty(m), 'Could not parse subject ID from %s', events_fnames{k});
        pid = m{1};  % e.g., 'sub-50001'

        T = readtable(events_fnames{k}, 'FileType','text', 'Delimiter','\t');
        trial_type = string(T.trial_type);
        onset_sec  = T.onset;
        dur_sec    = T.duration;

        names = {'Rejection','Acceptance','ParticipantChoice','ConfederateChoice','ControlChoice','ParticipantFeedback','ControlFeedback'};
        onsets = cell(1, numel(names));
        durations = cell(1, numel(names));

        sel = trial_type == "feedback_rejection";   onsets{1} = onset_sec(sel)'; durations{1} = dur_sec(sel)';
        sel = trial_type == "feedback_acceptance";  onsets{2} = onset_sec(sel)'; durations{2} = dur_sec(sel)';
        sel = trial_type == "participant_choice";   onsets{3} = onset_sec(sel)'; durations{3} = dur_sec(sel)';
        sel = trial_type == "confederate_choice";   onsets{4} = onset_sec(sel)'; durations{4} = dur_sec(sel)';
        sel = trial_type == "control_choice";       onsets{5} = onset_sec(sel)'; durations{5} = dur_sec(sel)';
        sel = trial_type == "choice_feedback";      onsets{6} = onset_sec(sel)'; durations{6} = dur_sec(sel)';
        sel = trial_type == "control_feedback";     onsets{7} = onset_sec(sel)'; durations{7} = dur_sec(sel)';

        outmat = fullfile(outdir, sprintf('%s_ses-%d_task-chatroom_run-01_timing.mat', pid, session));
        save(outmat, 'onsets', 'durations', 'names');
        fprintf('Saved SPM timing: %s\n', outmat);
    end
end


%%Behavioral Sanity Check! (ur gonna need this for exclusions)
if sanity_check == 1
    out_sanity_dir = fullfile(procdir, 'sanity_checks');
    if ~exist(out_sanity_dir, 'dir'), mkdir(out_sanity_dir); end
    out_csv = fullfile(out_sanity_dir, sprintf('chatroom_sanity_session-%d.csv', session));

    pid_col    = strings(0,1);
    trial_col  = zeros(0,1);
    status_col = strings(0,1);

    %% --- PTB sanity: trialPlayerSelected vs trialCorrectSelection ---
    %only run if PTB files are present
    ptb_files = filenames(fullfile(behdir, 'sub-*', ['ses-' num2str(session)], 'beh', 'chzc*csv'));
    for f = 1:length(ptb_files)
        T = readtable(ptb_files{f});
        %pid as sub-#### string
        pid_ptb = sprintf('sub-%s', num2str(T.subjectID(1)));

        %coerce to string columns (handles char/cellstr)
        player = string(T.trialPlayerSelected);
        corr   = string(T.trialCorrectSelection);

        %trial number column name in PTB files is typically trialNumber
        if ismember('trialNumber', T.Properties.VariableNames)
            tnum = T.trialNumber;
        else
            %fallback to row index if absent
            tnum = (1:height(T))';
        end

        rt = T.trialRT;  % numeric; NaN when no response

        %missing = both player and RT missing
        isMissing = ismissing(player) & isnan(rt);

        %incorrect = both present and not equal
        bothPresent = ~ismissing(player) & ~ismissing(corr);
        isIncorrect = bothPresent & (player ~= corr);

        %append rows (only missing/incorrect)
        sel = find(isMissing | isIncorrect);
        if ~isempty(sel)
            pid_col    = [pid_col;    repmat(string(pid_ptb), numel(sel), 1)];
            trial_col  = [trial_col;  tnum(sel)];
            status_tmp = strings(numel(sel),1);
            status_tmp(isMissing(sel))  = "missing";
            status_tmp(isIncorrect(sel))= "incorrect";
            status_col = [status_col; status_tmp];
        end
    end

    %%E-prime sanity: blocks 2&3 (10/11 or 18/19) and block 4 (12/20)
    %choose file name by session
    if session == 1, eprefix = 'T1';
    elseif session == 2, eprefix = 'T3';
    else, eprefix = 'T5';
    end
    eprime_file = fullfile(behdir, sprintf('%s_%s_chatroom_eprime_output.xlsx', upper(study), eprefix));
    if exist(eprime_file, 'file')
        E = readtable(eprime_file);

        %subject, block, trial, SelOth, Shw2_RESP, ChzT6_RT
        subj  = E.Subject;
        block = E.Block;
        if ismember('Trial', E.Properties.VariableNames)
            etrial = E.Trial;
        else
            %fallback to within-subject sequence (row number within PID)
            etrial = (1:height(E))';
        end

        %pull columns (matlab converts dots to underscores on import)
        has_SelOth   = ismember('SelOth', E.Properties.VariableNames);
        has_Shw2R    = ismember('Shw2_RESP', E.Properties.VariableNames);
        has_ChzT6RT  = ismember('ChzT6_RT', E.Properties.VariableNames);

        %loop per PID
        pids_e = unique(subj(~isnan(subj)));
        for pi = 1:numel(pids_e)
            pid_num = pids_e(pi);
            pid_str = sprintf('sub-%d', pid_num);
            S = E(subj == pid_num, :);

            %Blocks 2 & 3 (confederate): 10/11 or 18/19
            if has_SelOth && has_Shw2R
                conf_mask = (S.Block == 10 | S.Block == 11 | S.Block == 18 | S.Block == 19) & (S.SelOth == 2);
                if any(conf_mask)
                    resp = S.Shw2_RESP(conf_mask);
                    tri  = S.Trial(conf_mask);
                    %incorrect if RESP in {1,7}; missing if RESP is NaN/empty; match if {2,6} (ignored)
                    is_resp_missing = ismissing(resp);
                    is_incorrect    = ismember(resp, [1 7]);
                    %append
                    sel_idx = find(is_resp_missing | is_incorrect);
                    if ~isempty(sel_idx)
                        pid_col    = [pid_col;    repmat(string(pid_str), numel(sel_idx), 1)];
                        trial_col  = [trial_col;  tri(sel_idx)];
                        status_tmp = strings(numel(sel_idx),1);
                        status_tmp(is_resp_missing(sel_idx)) = "missing";
                        status_tmp(is_incorrect(sel_idx))    = "incorrect";
                        status_col = [status_col; status_tmp];
                    end
                end
            end

            %block 4 (neutral): 12 or 20 -> missing if ChzT6.RT == 0
            if has_ChzT6RT
                neut_mask = (S.Block == 12 | S.Block == 20) & (S.ChzT6_RT == 0);
                if any(neut_mask)
                    tri = S.Trial(neut_mask);
                    pid_col   = [pid_col; repmat(string(pid_str), sum(neut_mask), 1)];
                    trial_col = [trial_col; tri];
                    status_col= [status_col; repmat("missing", sum(neut_mask), 1)];
                end
            end
        end
    end

    %%write to csv
    sanity_tbl = table(pid_col, trial_col, status_col, ...
        'VariableNames', {'pid','trial','status'});
    writetable(sanity_tbl, out_csv);
    fprintf('Wrote sanity CSV: %s (%d rows)\n', out_csv, height(sanity_tbl));
end
