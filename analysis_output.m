% Author: Nina Kougan (ninakougan@u.northwestern.edu)
% fMRI Analysis Script for MID and Chatroom Tasks in Projects RISE & CREST

% Define session number (can be 1, 2, or 3)
session = 1;

% Define which tasks to run (1 = run, 0 = skip)
run_MID = 1;
run_Chatroom = 1;

% Define directories
fldir = '/projects/b1108/studies/rise/data/processed/neuroimaging/august24_T1/fl';
datadir = '/users/ninakougan/Downloads';

% Load exclusion list
load('/projects/b1108/studies/rise/data/processed/neuroimaging/exclusions_based_on_motion.mat');

% ========================= MID ANALYSIS =========================
if run_MID
    disp('Running MID analysis...');
    % Load MID data for both runs and average them
    mid_files = struct();
    mid_contrasts = {'GainAnt', 'LossAnt', 'GainvLossAnt', 'GainvMissOut', 'AvoidedLossvLossOut', 'GainvLossOut'};
    
    for c = 1:3  % Anticipation contrasts
        mid_files.(mid_contrasts{c}) = {
            filenames(fullfile(['sub-*/ses-', num2str(session), '/anticipation/run-01/con_000', num2str(c), '.nii'])),
            filenames(fullfile(['sub-*/ses-', num2str(session), '/anticipation/run-02/con_000', num2str(c), '.nii']))
        };
    end
    for c = 4:6  % Outcome contrasts
        mid_files.(mid_contrasts{c}) = {
            filenames(fullfile(['sub-*/ses-', num2str(session), '/outcome/run-01/con_000', num2str(c-3), '.nii'])),
            filenames(fullfile(['sub-*/ses-', num2str(session), '/outcome/run-02/con_000', num2str(c-3), '.nii']))
        };
    end
    
    % Apply exclusions
    mid_exclude = pid_exclude_list(contains(pid_exclude_list(:,2),['ses-', num2str(session), '_mid']));
    for c = 1:length(mid_contrasts)
        mid_files.(mid_contrasts{c}) = mid_files.(mid_contrasts{c})(~contains(mid_files.(mid_contrasts{c}), mid_exclude));
    end
    
    % Average runs
    for c = 1:length(mid_contrasts)
        mid_files.(mid_contrasts{c}) = mean(cat(4, fmri_data(mid_files.(mid_contrasts{c}){1}).dat, fmri_data(mid_files.(mid_contrasts{c}){2}).dat), 4);
    end
    
    % Run whole-brain regression
    for c = 1:length(mid_contrasts)
        stat_results = regress(mid_files.(mid_contrasts{c}), ones(size(mid_files.(mid_contrasts{c}), 2), 1));
        save(['MID_', mid_contrasts{c}, '_session', num2str(session), '.mat'], 'stat_results');
        writetable(struct2table(stat_results), ['MID_', mid_contrasts{c}, '_session', num2str(session), '.csv'], 'Delimiter', '\t');
    end
    
    % Define ROI directory for MID
    roi_dir_mid = '/projects/b1108/studies/rise/data/processed/neuroimaging/roi/MID/*.nii';
    all_rois_mid = filenames(roi_dir_mid);
    
    % Run ROI-based analyses
    for c = 1:length(mid_contrasts)
        roi_results = extract_roi_averages(mid_files.(mid_contrasts{c}), all_rois_mid);
        save(['MID_ROI_', mid_contrasts{c}, '_session', num2str(session), '.mat'], 'roi_results');
        writetable(array2table(roi_results), ['MID_ROI_', mid_contrasts{c}, '_session', num2str(session), '.csv'], 'Delimiter', '\t');
    end
end

% ========================= CHATROOM ANALYSIS =========================
if run_Chatroom
    disp('Running Chatroom analysis...');
    % Load Chatroom data (single run only)
    chat_files = struct();
    chat_contrasts = {'acceptance', 'rejection'};
    for c = 1:length(chat_contrasts)
        chat_files.(chat_contrasts{c}) = filenames(fullfile(['sub-*/ses-', num2str(session), '/chatroom/run-01/con_000', num2str(c + 1), '.nii']));
    end
    
    % Apply exclusions
    chat_exclude = pid_exclude_list(contains(pid_exclude_list(:,2),['ses-', num2str(session), '_chat']));
    for c = 1:length(chat_contrasts)
        chat_files.(chat_contrasts{c}) = chat_files.(chat_contrasts{c})(~contains(chat_files.(chat_contrasts{c}), chat_exclude));
    end
    
    % Run whole-brain regression
    for c = 1:length(chat_contrasts)
        stat_results = regress(fmri_data(chat_files.(chat_contrasts{c})), ones(size(chat_files.(chat_contrasts{c}), 2), 1));
        save(['Chatroom_', chat_contrasts{c}, '_session', num2str(session), '.mat'], 'stat_results');
        writetable(struct2table(stat_results), ['Chatroom_', chat_contrasts{c}, '_session', num2str(session), '.csv'], 'Delimiter', '\t');
    end
    
    % Define ROI directory for Chatroom
    roi_dir_chat = '/projects/b1108/studies/rise/data/processed/neuroimaging/roi/Chatroom/*.nii';
    all_rois_chat = filenames(roi_dir_chat);
    
    % Run ROI-based analyses 
    for c = 1:length(chat_contrasts)
        roi_results = extract_roi_averages(fmri_data(chat_files.(chat_contrasts{c})), all_rois_chat);
        save(['Chatroom_ROI_', chat_contrasts{c}, '_session', num2str(session), '.mat'], 'roi_results');
        writetable(array2table(roi_results), ['Chatroom_ROI_', chat_contrasts{c}, '_session', num2str(session), '.csv'], 'Delimiter', '\t');
    end
end

disp('Analysis complete.');
