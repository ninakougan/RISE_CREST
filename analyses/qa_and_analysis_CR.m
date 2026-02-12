study = 'rise'; %rise or crest
ses = 1; % 1,2,3

whole_brain = 0;

fldir = fullfile('/projects/b1108/studies/', study, strcat('/data/processed/neuroimaging/fmriprep/ses-', num2str(ses),'/fl'));
%datadir = '/Users/ninakougan/Documents/rise';

remake_data_obj = 1;

if remake_data_obj == 1

    cd(fldir)
    fchat_accrej = filenames(fullfile('sub-*/', strcat('ses-', num2str(ses), '/chatroom/run-01/con_0001.nii')));
    fchat_acc    = filenames(fullfile('sub-*/', strcat('ses-', num2str(ses), '/chatroom/run-01/con_0002.nii')));
    fchat_rej    = filenames(fullfile('sub-*/', strcat('ses-', num2str(ses), '/chatroom/run-01/con_0003.nii')));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% chatroom ses-1
    final_data_chatroom_accrej = fmri_data(fchat_accrej);
    final_data_chatroom_acc    = fmri_data(fchat_acc);
    final_data_chatroom_rej    = fmri_data(fchat_rej);

    % --- per-contrast PID vectors (support RISE 5-digit and CREST 6-digit) ---
    getpid = @(p) regexp(p, 'sub-([0-9]{5,6})', 'tokens', 'once');

    pid_chat_accrej = cell(numel(fchat_accrej),1);
    for i = 1:numel(fchat_accrej)
        tok = getpid(fchat_accrej{i});
        pid_chat_accrej{i} = tok{1};
    end

    pid_chat_acc = cell(numel(fchat_acc),1);
    for i = 1:numel(fchat_acc)
        tok = getpid(fchat_acc{i});
        pid_chat_acc{i} = tok{1};
    end

    pid_chat_rej = cell(numel(fchat_rej),1);
    for i = 1:numel(fchat_rej)
        tok = getpid(fchat_rej{i});
        pid_chat_rej{i} = tok{1};
    end

    %% save per-contrast PID lists (like MID)
    save pids_accrej.mat pid_chat_accrej
    save pids_acc.mat     pid_chat_acc
    save pids_rej.mat     pid_chat_rej

    %% save all chatroom data objects
    save final_data_chatroom_accrej.mat final_data_chatroom_accrej
    save final_data_chatroom_acc.mat    final_data_chatroom_acc
    save final_data_chatroom_rej.mat    final_data_chatroom_rej

else
    load(fullfile(datadir, "final_data_chatroom_accrej.mat"))
    load(fullfile(datadir, "final_data_chatroom_acc.mat"))
    load(fullfile(datadir, "final_data_chatroom_rej.mat"))

    % load per-contrast PIDs
    load(fullfile(datadir, "pids_accrej.mat")); % pid_chat_accrej
    load(fullfile(datadir, "pids_acc.mat"));    % pid_chat_acc
    load(fullfile(datadir, "pids_rej.mat"));    % pid_chat_rej
end

if whole_brain == 1;
    final_data_chatroom_accrej.X = ones(size(final_data_chatroom_accrej.dat,2),1);
    final_data_chatroom_acc.X    = ones(size(final_data_chatroom_acc.dat,2),1);
    final_data_chatroom_rej.X    = ones(size(final_data_chatroom_rej.dat,2),1);

    stat_chatroom_accrej = regress(final_data_chatroom_accrej);
    stat_chatroom_acc    = regress(final_data_chatroom_acc);
    stat_chatroom_rej    = regress(final_data_chatroom_rej);

    thresh_chatroom_accrej = threshold(stat_chatroom_accrej.t, 0.05, 'fdr', 'k', 10);
    thresh_chatroom_acc    = threshold(stat_chatroom_acc.t,    0.05, 'fdr', 'k', 10);
    thresh_chatroom_rej    = threshold(stat_chatroom_rej.t,    0.05, 'fdr', 'k', 10);
end

%%
redo_regions = 1;

if redo_regions == 1

    % chatroom accrej
    T_chatsaccrej = [];
    names = [];
    all_regions = filenames(fullfile('/home/nck1870/scripts/RISE_CREST/rois/acc_rej/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_chatroom_accrej, roi);
        T_chatsaccrej = [T_chatsaccrej, temp_region.dat];
        names{r} = name;
    end
    T_chatsaccrej = array2table(T_chatsaccrej);
    T_chatsaccrej.Properties.VariableNames = names;
    T_chatsaccrej = [cell2table(pid_chat_accrej), T_chatsaccrej];
    T_chatsaccrej.Properties.VariableNames{1} = 'PID';
    save T_chatsaccrej.mat T_chatsaccrej

    % chatroom acc
    T_chatsacc = [];
    names = [];
    all_regions = filenames(fullfile('/home/nck1870/scripts/RISE_CREST/rois/acceptance/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_chatroom_acc, roi);
        T_chatsacc = [T_chatsacc, temp_region.dat];
        names{r} = name;
    end
    T_chatsacc = array2table(T_chatsacc);
    T_chatsacc.Properties.VariableNames = names;
    T_chatsacc = [cell2table(pid_chat_acc), T_chatsacc];
    T_chatsacc.Properties.VariableNames{1} = 'PID';
    save T_chatsacc.mat T_chatsacc

    % chatroom rej
    T_chatsrej = [];
    names = [];
    all_regions = filenames(fullfile('/home/nck1870/scripts/RISE_CREST/rois/rejection/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_chatroom_rej, roi);
        T_chatsrej = [T_chatsrej, temp_region.dat];
        names{r} = name;
    end
    T_chatsrej = array2table(T_chatsrej);
    T_chatsrej.Properties.VariableNames = names;
    T_chatsrej = [cell2table(pid_chat_rej), T_chatsrej];
    T_chatsrej.Properties.VariableNames{1} = 'PID';
    save T_chatsrej.mat T_chatsrej

    %%
    % AAL3 atlas for all
    clear names
    atl = fmri_data('/home/nck1870/scripts/RISE_CREST/rois/aal3/AAL3v1.nii');
    labels = readtable('/home/nck1870/scripts/RISE_CREST/rois/aal3/AAL3v1.nii.txt');
    labels(isnan(labels.Var3),:) = [];

    aal_chat_accrej = extract_roi_averages(final_data_chatroom_accrej, atl);
    aal_chat_acc    = extract_roi_averages(final_data_chatroom_acc, atl);
    aal_chat_rej    = extract_roi_averages(final_data_chatroom_rej, atl);

    for i = 1:length(labels.Var2)
        T_aal_chat_accrej(:, i) = aal_chat_accrej(i).dat;
        T_aal_chat_acc(:, i)    = aal_chat_acc(i).dat;
        T_aal_chat_rej(:, i)    = aal_chat_rej(i).dat;
        names{i} = labels.Var2{i};
    end

    T_aal_chat_accrej = array2table(T_aal_chat_accrej);
    T_aal_chat_accrej.Properties.VariableNames = names;
    T_aal_chat_accrej = [cell2table(pid_chat_accrej), T_aal_chat_accrej];
    T_aal_chat_accrej.Properties.VariableNames{1} = 'PID';

    T_aal_chat_acc = array2table(T_aal_chat_acc);
    T_aal_chat_acc.Properties.VariableNames = names;
    T_aal_chat_acc = [cell2table(pid_chat_acc), T_aal_chat_acc];
    T_aal_chat_acc.Properties.VariableNames{1} = 'PID';

    T_aal_chat_rej = array2table(T_aal_chat_rej);
    T_aal_chat_rej.Properties.VariableNames = names;
    T_aal_chat_rej = [cell2table(pid_chat_rej), T_aal_chat_rej];
    T_aal_chat_rej.Properties.VariableNames{1} = 'PID';

    % ---------- AAL3 prefix + merge onto custom ROI tables ----------
    v = T_aal_chat_accrej.Properties.VariableNames;
    v(2:end) = strcat('AAL3_', v(2:end));
    T_aal_chat_accrej.Properties.VariableNames = v;

    v = T_aal_chat_acc.Properties.VariableNames;
    v(2:end) = strcat('AAL3_', v(2:end));
    T_aal_chat_acc.Properties.VariableNames = v;

    v = T_aal_chat_rej.Properties.VariableNames;
    v(2:end) = strcat('AAL3_', v(2:end));
    T_aal_chat_rej.Properties.VariableNames = v;

    rv = @(T) T.Properties.VariableNames(~strcmp(T.Properties.VariableNames,'PID')); % all but PID

    
{
 T_chatsaccrej = innerjoin(T_chatsaccrej, T_aal_chat_accrej, ...
        'Keys', 'PID', 'RightVariables', rv(T_aal_chat_accrej));

    T_chatsacc = innerjoin(T_chatsacc, T_aal_chat_acc, ...
        'Keys', 'PID', 'RightVariables', rv(T_aal_chat_acc));

    T_chatsrej = innerjoin(T_chatsrej, T_aal_chat_rej, ...
        'Keys', 'PID', 'RightVariables', rv(T_aal_chat_rej));

    save T_aal_chat_accrej.mat T_aal_chat_accrej
    save T_aal_chat_acc.mat    T_aal_chat_acc
    save T_aal_chat_rej.mat    T_aal_chat_rej 
}
end

write out to csvs
writetable(T_aal_chat_acc,    'AAL_t1chat_acc.txt',    'Delimiter','\t');
writetable(T_aal_chat_rej,    'AAL_t1chat_rej.txt',    'Delimiter','\t');
writetable(T_aal_chat_accrej, 'AAL_t1chat_accrej.txt', 'Delimiter','\t');

writetable(T_chatsacc,       'chat_acc.txt',        'Delimiter','\t');
writetable(T_chatsrej,       'chat_rej.txt',        'Delimiter','\t');
writetable(T_chatsaccrej,    'chat_accrej.txt',     'Delimiter','\t');