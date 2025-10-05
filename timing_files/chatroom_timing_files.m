%%%RISE/CREST BIDS events.tsv file creation
%%%Author: Nina Kougan (ninakougan@u.northwestern.edu)
%%%Last Updated: 10/2/25

bids_files = 1; %do you want to make bids events files?     
spm_files  = 1; %do you want to make spm events files? 
sanity_check = 1; %check for missing/incorrect responses

study = 'crest';    % rise or crest
ses   = 1;  % 1, 2, or 3

basedir = fullfile('/projects/b1108/studies', study, 'data/raw/neuroimaging');
bidsdir = fullfile(basedir, 'bids');
behdir  = fullfile(basedir, 'behavioral');
savedir = fullfile('/projects/b1108/studies', study, 'data/processed/neuroimaging/fmriprep/ses-', num2str(ses), 'spm_timing_files');


%% ================== BIDS EVENTS ==================
if bids_files == 1
    CRfnames_txt = filenames(fullfile(behdir, 'sub-*', ['ses-' num2str(ses)], 'beh', 'chzc*txt'));
    CRfnames_csv = filenames(fullfile(behdir, 'sub-*', ['ses-' num2str(ses)], 'beh', 'chzc*csv'));

    %% ----------- E-PRIME (.txt) -----------
    scan_offset = 4.05;
    for f = 1:length(CRfnames_txt)
        fpath = CRfnames_txt{f};

        % PID from path
        pid_tok = regexp(fpath, 'sub-(\d+)', 'tokens', 'once');
        if isempty(pid_tok), warning(['Skip (no PID): ' fpath]); continue; end
        pid = pid_tok{1};

        outdir = fullfile(bidsdir, ['sub-' pid], ['ses-' num2str(ses)], 'func');
        if ~exist(outdir, 'dir'), mkdir(outdir); end

        txt = readtable(fpath, 'FileType', 'text');

        % ---------- CUE & CHOICE ----------
        chz_on_ms  = txt.Var2(contains(txt.Var1, 'ChzT.OnsetTime'));
        chz_off_ms = txt.Var2(contains(txt.Var1, 'ChzT.OffsetTime'));
        chz_rt_ms  = txt.Var2(contains(txt.Var1, 'ChzT.RT'));
        if isempty(chz_on_ms), warning(['No ChzT.OnsetTime in ' fpath]); continue; end

        first_ms = chz_on_ms(1);
        cue_on = (chz_on_ms - first_ms)./1000 + scan_offset;

        if ~isempty(chz_off_ms) && numel(chz_off_ms)==numel(chz_on_ms)
            cue_dur = (chz_off_ms - chz_on_ms)./1000;
        elseif ~isempty(chz_rt_ms) && numel(chz_rt_ms)==numel(chz_on_ms)
            cue_dur = chz_rt_ms./1000;
        else
            cue_dur = zeros(numel(cue_on),1);
        end
        cue_dur   = max(cue_dur,0);
        choice_on = cue_on + cue_dur;
        choice_dur = zeros(size(choice_on));

        % ---------- FEEDBACK ----------
        % Block 1 "show"
        shwT_on_ms  = txt.Var2(contains(txt.Var1, 'ShwT.OnsetTime'));
        shwT_off_ms = txt.Var2(contains(txt.Var1, 'ShwT.OffsetTime'));
        show_on = ((shwT_on_ms - first_ms)./1000) + scan_offset;
        if ~isempty(shwT_off_ms) && numel(shwT_off_ms)==numel(shwT_on_ms)
            show_dur = (shwT_off_ms - shwT_on_ms)./1000;
        else
            show_dur = zeros(numel(show_on),1);
        end
        show_dur = max(show_dur,0);

        % Blocks 2 & 3 accept/reject
        shw2_on_ms  = txt.Var2(contains(txt.Var1,'Shw2.OnsetTime'));
        shw2_off_ms = txt.Var2(contains(txt.Var1,'Shw2.OffsetTime'));
        selSub      = txt.Var2(contains(txt.Var1,'SelSubj')); % 2=accept, 0=reject

        n23 = min([numel(selSub), numel(shw2_on_ms)]);
        fb23_on  = ((shw2_on_ms(1:n23) - first_ms)./1000) + scan_offset;
        if ~isempty(shw2_off_ms) && numel(shw2_off_ms)>=n23
            fb23_dur = (shw2_off_ms(1:n23) - shw2_on_ms(1:n23))./1000;
        else
            fb23_dur = zeros(n23,1);
        end
        fb23_dur = max(fb23_dur,0);
        fb23_type = strings(n23,1);
        fb23_type(selSub(1:n23)==2) = "accept";
        fb23_type(selSub(1:n23)==0) = "reject";

        % Block 4 neutral
        shw6_on_ms  = txt.Var2(contains(txt.Var1,'Shw6.OnsetTime'));
        shw6_off_ms = txt.Var2(contains(txt.Var1,'Shw6.OffsetTime'));
        neu_on = ((shw6_on_ms - first_ms)./1000) + scan_offset;
        if ~isempty(shw6_off_ms) && numel(shw6_off_ms)==numel(shw6_on_ms)
            neu_dur = (shw6_off_ms - shw6_on_ms)./1000;
        else
            neu_dur = zeros(numel(neu_on),1);
        end
        neu_dur = max(neu_dur,0);

        % ---------- Assemble & write ----------
        E = [
            table(cue_on,    cue_dur,    repmat("cue",    numel(cue_on),1),    'VariableNames',{'onset','duration','trial_type'});
            table(choice_on, choice_dur, repmat("choice", numel(choice_on),1), 'VariableNames',{'onset','duration','trial_type'});
            table(show_on,   show_dur,   repmat("show",   numel(show_on),1),   'VariableNames',{'onset','duration','trial_type'});
            table(fb23_on,   fb23_dur,   fb23_type,                              'VariableNames',{'onset','duration','trial_type'});
            table(neu_on,    neu_dur,    repmat("neutral",numel(neu_on),1),    'VariableNames',{'onset','duration','trial_type'})
        ];
        E = sortrows(E,'onset');

        out_tsv = fullfile(outdir, ['sub-' pid '_ses-' num2str(ses) '_task-chatroom_run-01_events.tsv']);
        writetable(E, out_tsv, 'FileType','text', 'Delimiter','\t');
    end

    %% ----------- PSYCHTOOLBOX (.csv) -----------
    for f = 1:length(CRfnames_csv)
        fpath = CRfnames_csv{f};

        pid_tok = regexp(fpath, 'sub-(\d+)', 'tokens', 'once');
        if isempty(pid_tok), warning(['Skip (no PID): ' fpath]); continue; end
        pid = pid_tok{1};

        outdir = fullfile(bidsdir, ['sub-' pid], ['ses-' num2str(ses)], 'func');
        if ~exist(outdir, 'dir'), mkdir(outdir); end

        C = readtable(fpath);

        % ---------- CUE & CHOICE ----------
        cue_on = C.trialOnset;
        if ismember('trialChoiceOffset', C.Properties.VariableNames)
            cue_dur = C.trialChoiceOffset - C.trialOnset;
        elseif ismember('trialRT', C.Properties.VariableNames)
            cue_dur = C.trialRT;
        else
            cue_dur = zeros(height(C),1);
        end
        cue_dur   = max(cue_dur,0);
        choice_on = cue_on + cue_dur;
        choice_dur = zeros(height(C),1);

        % ---------- FEEDBACK ----------
        fb_on = C.trialFeedbackOnset;
        if ismember('trialFeedbackOffset', C.Properties.VariableNames)
            fb_dur = C.trialFeedbackOffset - C.trialFeedbackOnset;
        else
            fb_dur = zeros(height(C),1);
        end
        fb_dur = max(fb_dur,0);

        fb_type = strings(height(C),1);
        is_b1 = C.blockNumber==1;
        is_b4 = C.blockNumber==4;
        is_b23 = C.blockNumber==2 | C.blockNumber==3;
        fb_type(is_b1) = "show";
        fb_type(is_b4) = "neutral";
        acc_mask = is_b23 & strcmp(C.trialCorrectSelection, C.blockAgent(1));
        rej_mask = is_b23 & ~strcmp(C.trialCorrectSelection, C.blockAgent(1));
        fb_type(acc_mask) = "accept";
        fb_type(rej_mask) = "reject";

        % ---------- Assemble & write ----------
        E = [
            table(cue_on,    cue_dur,    repmat("cue",    height(C),1), 'VariableNames',{'onset','duration','trial_type'});
            table(choice_on, choice_dur, repmat("choice", height(C),1), 'VariableNames',{'onset','duration','trial_type'});
            table(fb_on,     fb_dur,     fb_type,                       'VariableNames',{'onset','duration','trial_type'})
        ];
        E = sortrows(E,'onset');

        out_tsv = fullfile(outdir, ['sub-' pid '_ses-' num2str(ses) '_task-chatroom_run-01_events.tsv']);
        writetable(E, out_tsv, 'FileType','text', 'Delimiter','\t');
    end
end


if spm_files == 1
    evnames = filenames(fullfile(bidsdir, ['sub-*/ses-' num2str(ses) '/func/sub-*' '_ses-' num2str(ses) '_task-chatroom_run-01_events.tsv']));

    for i = 1:length(evnames)
        evpath = evnames{i};

        % get PID from the path
        pid_tok = regexp(evpath, 'sub-(\d+)', 'tokens', 'once');
        if isempty(pid_tok)
            fprintf(['Skipping (no PID): ' evpath '\n']);
            continue
        end
        pid = pid_tok{1};

        % read events.tsv
        E = readtable(evpath, 'FileType','text', 'Delimiter','\t');

        % masks
        is_accept  = strcmpi(E.trial_type,'accept');
        is_reject  = strcmpi(E.trial_type,'reject');
        is_neutral = strcmpi(E.trial_type,'neutral');

        % build SPM cells
        names = {'accept','reject','neutral'};
        onsets = cell(1,3);
        durations = cell(1,3);

        onsets{1}    = E.onset(is_accept)';     durations{1} = E.duration(is_accept)';
        onsets{2}    = E.onset(is_reject)';     durations{2} = E.duration(is_reject)';
        onsets{3}    = E.onset(is_neutral)';    durations{3} = E.duration(is_neutral)';

        curr_filename = fullfile(savedir, ['sub-' pid '_ses-' num2str(ses) '_task-chatroom_run-01_timing.mat']);
        save(curr_filename, 'onsets', 'durations', 'names');
    end
end

if sanity_check = 1;
    out_csv = fullfile(savedir, ['chatroom_sanity_check_ses-' num2str(ses) '.csv']);

    % Gather files
    CR_txt = filenames(fullfile(behdir, ['sub-*/ses-' num2str(ses) '/beh/chzc*txt']));
    CR_csv = filenames(fullfile(behdir, ['sub-*/ses-' num2str(ses) '/beh/chzc*csv']));

    % Results containers
    res_PID = {}; res_session = []; res_missing = []; res_incorrect = [];

    %% -------- E-PRIME (.txt) --------
    for f = 1:length(CR_txt)
        fpath = CR_txt{f};
        pid_tok = regexp(fpath, 'sub-(\d+)', 'tokens', 'once');
        if isempty(pid_tok), fprintf('Skip (no PID): %s\n', fpath); continue; end
        pid = pid_tok{1};

        txt = readtable(fpath, 'FileType','text');

        % Missing responses: ChzT.RESP (blocks 1–3) + ChzT6.RESP (block 4)
        chzt_resp  = txt.Var2(contains(txt.Var1,'ChzT.RESP'));
        chzt6_resp = txt.Var2(contains(txt.Var1,'ChzT6.RESP'));
        missing_count = sum(isnan(chzt_resp)) + sum(isnan(chzt6_resp));

        % Incorrect responses: prefer ACC; else RESP vs CRESP
        incorrect_count = NaN;
        chzt_acc   = txt.Var2(contains(txt.Var1,'ChzT.ACC'));
        chzt_cresp = txt.Var2(contains(txt.Var1,'ChzT.CRESP'));
        if ~isempty(chzt_acc)
            incorrect_count = sum(chzt_acc==0);
        elseif ~isempty(chzt_cresp) && ~isempty(chzt_resp)
            n = min(length(chzt_cresp), length(chzt_resp));
            rr = chzt_resp(1:n); cc = chzt_cresp(1:n);
            mask = ~isnan(rr) & ~isnan(cc);
            incorrect_count = sum(rr(mask) ~= cc(mask));
        else
            incorrect_count = 0; % if no correctness info, assume 0
        end

        % Append row
        res_PID{end+1,1}       = pid;
        res_session(end+1,1)   = ses;
        res_missing(end+1,1)   = missing_count;
        res_incorrect(end+1,1) = incorrect_count;
    end

    %% -------- PSYCHTOOLBOX (.csv) --------
    for f = 1:length(CR_csv)
        fpath = CR_csv{f};
        pid_tok = regexp(fpath, 'sub-(\d+)', 'tokens', 'once');
        if isempty(pid_tok), fprintf('Skip (no PID): %s\n', fpath); continue; end
        pid = pid_tok{1};

        C = readtable(fpath);

        % Missing responses: prefer trialChoiceOffset; else trialRT
        if ismember('trialChoiceOffset', C.Properties.VariableNames)
            miss_mask = ismissing(C.trialChoiceOffset);
        elseif ismember('trialRT', C.Properties.VariableNames)
            miss_mask = ismissing(C.trialRT) | C.trialRT<=0;
        else
            miss_mask = true(height(C),1); % if no response cols
        end
        missing_count = sum(miss_mask);

        % Incorrect responses: playerSelected vs correctSelection
        incorrect_count = 0;
        if ismember('trialPlayerSelected', C.Properties.VariableNames) && ...
           ismember('trialCorrectSelection', C.Properties.VariableNames)
            both = ~ismissing(C.trialPlayerSelected) & ~ismissing(C.trialCorrectSelection);
            incorrect_count = sum(C.trialPlayerSelected(both) ~= C.trialCorrectSelection(both));
        end

        res_PID{end+1,1}       = pid;
        res_session(end+1,1)   = ses;
        res_missing(end+1,1)   = missing_count;
        res_incorrect(end+1,1) = incorrect_count;
    end

    % Write summary CSV
    summ = table(res_PID, res_session, res_missing, res_incorrect, ...
        'VariableNames', {'PID','session','missing','incorrect'});
    writetable(summ, out_csv);
end
