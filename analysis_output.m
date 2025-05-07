%% Setup: Define control variables and directories
run_MID = 1;      % Run MID analysis
run_chat = 1;     % Run Chatroom analysis
wholebrain = 1;   % Run whole-brain analysis

base_dir = '/projects/b1108/studies/rise/data/processed/neuroimaging';
fl_dir = fullfile(base_dir, 'fl');
roi_dir = fullfile(base_dir, 'roi');

%% ========================= MID Analysis =========================
if run_MID == 1
    disp('Running MID analysis...');
    mid_contrasts = {'GainAnt', 'LossAnt', 'GainvLossAnt', 'GainvMissOut', 'AvoidedLossvLossOut', 'GainvLossOut'};
    mid_files = struct();
    
    % For anticipation contrasts (contrasts 1-3)
    for c = 1:3
        mid_files.(mid_contrasts{c}) = {
            filenames(fullfile(fl_dir, ['sub-*/ses-', num2str(session), '/anticipation/run-01/con_00', num2str(c), '.nii'])), ...
            filenames(fullfile(fl_dir, ['sub-*/ses-', num2str(session), '/anticipation/run-02/con_00', num2str(c), '.nii']))
        };
    end

    % For outcome contrasts (contrasts 4-6; note the index shift)
    for c = 4:6
        mid_files.(mid_contrasts{c}) = {
            filenames(fullfile(fl_dir, ['sub-*/ses-', num2str(session), '/outcome/run-01/con_00', num2str(c-3), '.nii'])), ...
            filenames(fullfile(fl_dir, ['sub-*/ses-', num2str(session), '/outcome/run-02/con_00', num2str(c-3), '.nii']))
        };
    end

    % Apply exclusions for MID (using pid_exclude_list)
    mid_exclude = pid_exclude_list(contains(pid_exclude_list(:,2), ['ses-', num2str(session), '_mid']));
    for c = 1:length(mid_contrasts)
        mid_files.(mid_contrasts{c}) = mid_files.(mid_contrasts{c})(~contains(mid_files.(mid_contrasts{c}), mid_exclude));
    end

    % Average data across runs exactly as in the original QA script:
    % (1) avg_mid will contain the averaged data matrix for ROI analysis.
    % (2) wb_mid contains whole-brain fmri_data objects (using run-01 as a template).
    avg_mid = struct();
    wb_mid = struct();
    for c = 1:length(mid_contrasts)
        % Read the two run files as fmri_data objects.
        data_run1 = fmri_data(mid_files.(mid_contrasts{c}){1});
        data_run2 = fmri_data(mid_files.(mid_contrasts{c}){2});
        % Compute the average of the two runs.
        avg_data = mean(cat(4, data_run1.dat, data_run2.dat), 4);
        avg_mid.(mid_contrasts{c}) = avg_data;
        % Create a whole-brain fmri_data object using data_run1 as template.
        wb = data_run1;
        wb.dat = avg_data;
        wb_mid.(mid_contrasts{c}) = wb;
    end

    % ----- ROI Analysis for MID -----
    % Construct ROI paths for MID anticipation and outcome using the base ROI directory.
    roi_mid_ant = fullfile(roi_dir, 'anticipation', '*.nii');
    roi_mid_out = fullfile(roi_dir, 'outcome', '*.nii');

    % For anticipation contrasts
    for c = 1:3
        roi_results = extract_roi_averages(avg_mid.(mid_contrasts{c}), filenames(roi_mid_ant));
        save(['MID_ROI_', mid_contrasts{c}, '_session', num2str(session), '.mat'], 'roi_results');
        writetable(array2table(roi_results), ['MID_ROI_', mid_contrasts{c}, '_session', num2str(session), '.csv'], 'Delimiter', '\t');
    end
    % For outcome contrasts
    for c = 4:6
        roi_results = extract_roi_averages(avg_mid.(mid_contrasts{c}), filenames(roi_mid_out));
        save(['MID_ROI_', mid_contrasts{c}, '_session', num2str(session), '.mat'], 'roi_results');
        writetable(array2table(roi_results), ['MID_ROI_', mid_contrasts{c}, '_session', num2str(session), '.csv'], 'Delimiter', '\t');
    end

    % ----- Whole-Brain Analysis for MID (if enabled) -----
    if wholebrain == 1
        disp('Running whole-brain MID analysis...');
        for c = 1:length(mid_contrasts)
            wb = wb_mid.(mid_contrasts{c});
            % Set a simple design matrix (intercept only)
            wb.X = ones(size(wb.dat, 2), 1);
            % Run regression on the whole-brain data.
            stat = regress(wb);
            % Threshold the t-statistic map at FDR < 0.05 and with a cluster extent of 10 voxels.
            wb_thresh = threshold(stat.t, 0.05, 'fdr', 'k', 10);
            % Save the whole-brain results.
            save(['WB_MID_', mid_contrasts{c}, '_session', num2str(session), '.mat'], 'wb_thresh');
            writetable(array2table(wb_thresh), ['WB_MID_', mid_contrasts{c}, '_session', num2str(session), '.csv'], 'Delimiter', '\t');
        end
    end
end

%% ========================= Chatroom Analysis =========================
if run_chat == 1
    disp('Running chatroom analysis...');
    chat_contrasts = {'acc_rej', 'acceptance', 'rejection'};
    
    chat_files = struct();
    chat_files.acc_rej    = filenames(fullfile(fl_dir, ['sub-*/ses-', num2str(session), '/chatroom/run-01/con_001.nii']));
    chat_files.acceptance = filenames(fullfile(fl_dir, ['sub-*/ses-', num2str(session), '/chatroom/run-01/con_002.nii']));
    chat_files.rejection  = filenames(fullfile(fl_dir, ['sub-*/ses-', num2str(session), '/chatroom/run-01/con_003.nii']));
    
    % Apply exclusions for chat files.
    chat_exclude = pid_exclude_list(contains(pid_exclude_list(:,2), ['ses-', num2str(session), '_chat']));
    chat_files.acc_rej    = chat_files.acc_rej(~contains(chat_files.acc_rej, chat_exclude));
    chat_files.acceptance = chat_files.acceptance(~contains(chat_files.acceptance, chat_exclude));
    chat_files.rejection  = chat_files.rejection(~contains(chat_files.rejection, chat_exclude));
    
    % ----- ROI Analysis for Chatroom -----
    % Construct the ROI path for the chatroom using the base ROI directory.
    roi_chat = fullfile(roi_dir, 'chatroom', '*.nii');
    for c = 1:length(chat_contrasts)
        % Load the fmri_data object (assuming one subject per file).
        contrast_data = fmri_data(chat_files.(chat_contrasts{c}){1});
        roi_results = extract_roi_averages(contrast_data, filenames(roi_chat));
        save(['Chatroom_ROI_', chat_contrasts{c}, '_session', num2str(session), '.mat'], 'roi_results');
        writetable(array2table(roi_results), ['Chatroom_ROI_', chat_contrasts{c}, '_session', num2str(session), '.csv'], 'Delimiter', '\t');
    end
    
    % ----- Whole-Brain Analysis for Chatroom (if enabled) -----
    if wholebrain == 1
        disp('Running whole-brain Chatroom analysis...');
        for c = 1:length(chat_contrasts)
            % Load the fmri_data object for the contrast.
            contrast_data = fmri_data(chat_files.(chat_contrasts{c}){1});
            % Set up a basic design matrix (intercept only) for regression.
            contrast_data.X = ones(size(contrast_data.dat, 2), 1);
            % Run regression on the whole-brain data.
            stat_chat = regress(contrast_data);
            % Threshold the resulting t-map (FDR < 0.05, cluster extent = 10 voxels).
            wb_chat_thresh = threshold(stat_chat.t, 0.05, 'fdr', 'k', 10);
            % Save the whole-brain results.
            save(['WB_Chatroom_', chat_contrasts{c}, '_session', num2str(session), '.mat'], 'wb_chat_thresh');
            writetable(array2table(wb_chat_thresh), ['WB_Chatroom_', chat_contrasts{c}, '_session', num2str(session), '.csv'], 'Delimiter', '\t');
        end
    end
end

disp('Analysis complete.');
