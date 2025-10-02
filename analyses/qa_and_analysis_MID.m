fldir = '/Users/ninakougan/Documents/rise';
datadir = '/Users/ninakougan/Documents/rise';

remake_data_obj = 1;

if remake_data_obj == 1

    cd(fldir)
    
    fmidant_s1_run1_c1 = filenames(fullfile('sub-*/ses-1/anticipation/run-01/con_0001.nii'));
    fmidant_s1_run2_c1 = filenames(fullfile('sub-*/ses-1/anticipation/run-02/con_0001.nii'));

    fmidant_s1_run1_c2 = filenames(fullfile('sub-*/ses-1/anticipation/run-01/con_0002.nii'));
    fmidant_s1_run2_c2 = filenames(fullfile('sub-*/ses-1/anticipation/run-02/con_0002.nii'));

    fmidant_s1_run1_c3 = filenames(fullfile('sub-*/ses-1/anticipation/run-01/con_0003.nii'));
    fmidant_s1_run2_c3 = filenames(fullfile('sub-*/ses-1/anticipation/run-02/con_0003.nii'));
    
    fmidout_s1_run1_c1  = filenames(fullfile('sub-*/ses-1/outcome/run-01/con_0001.nii'));
    fmidout_s1_run2_c1  = filenames(fullfile('sub-*/ses-1/outcome/run-02/con_0001.nii'));

    fmidout_s1_run1_c2  = filenames(fullfile('sub-*/ses-1/outcome/run-01/con_0002.nii'));
    fmidout_s1_run2_c2  = filenames(fullfile('sub-*/ses-1/outcome/run-02/con_0002.nii'));

    fmidout_s1_run1_c3  = filenames(fullfile('sub-*/ses-1/outcome/run-01/con_0003.nii'));
    fmidout_s1_run2_c3  = filenames(fullfile('sub-*/ses-1/outcome/run-02/con_0003.nii'));

    %% MID ses-1
    % --- Anticipation C1 ---
    final_data_midant_ses1_c1 = fmri_data(fmidant_s1_run2_c1{1});
    final_sub_count = 1;
    pids_midant_s1_c1 = {};
    for sub = 1:length(fmidant_s1_run2_c1)
        pid = fmidant_s1_run2_c1{sub}(5:9);
        if sum(contains(fmidant_s1_run1_c1(:), pid)) ~= 0
            tempfname_run1 = fmidant_s1_run1_c1{contains(fmidant_s1_run1_c1(:), pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidant_s1_run2_c1{sub});
            %keyboard
            %dat2 = resample_space(dat2, dat1);
            dat1.dat = mean([dat1.dat, dat2.dat], 2);
            final_data_midant_ses1_c1.dat(:, final_sub_count) = dat1.dat;
            pids_midant_s1_c1{end+1} = pid;
            final_sub_count = final_sub_count + 1;
        end
    end

    % --- Anticipation C2 ---
    clear dat1 dat2
    final_data_midant_ses1_c2 = fmri_data(fmidant_s1_run2_c2{1});
    final_sub_count = 1;
    pids_midant_s1_c2 = {};
    for sub = 1:length(fmidant_s1_run2_c2)
        pid = fmidant_s1_run2_c2{sub}(5:9);
        if sum(contains(fmidant_s1_run1_c2(:), pid)) ~= 0
            tempfname_run1 = fmidant_s1_run1_c2{contains(fmidant_s1_run1_c2(:), pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidant_s1_run2_c2{sub});
            %dat2 = resample_space(dat2, dat1);
            dat1.dat = mean([dat1.dat, dat2.dat], 2);
            final_data_midant_ses1_c2.dat(:, final_sub_count) = dat1.dat;
            pids_midant_s1_c2{end+1} = pid;
            final_sub_count = final_sub_count + 1;
        end
    end

    % --- Anticipation C3 ---
    clear dat1 dat2
    final_data_midant_ses1_c3 = fmri_data(fmidant_s1_run2_c3{1});
    final_sub_count = 1;
    pids_midant_s1_c3 = {};
    for sub = 1:length(fmidant_s1_run2_c3)
        pid = fmidant_s1_run2_c3{sub}(5:9);
        if sum(contains(fmidant_s1_run1_c3(:), pid)) ~= 0
            tempfname_run1 = fmidant_s1_run1_c3{contains(fmidant_s1_run1_c3(:), pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidant_s1_run2_c3{sub});
            %dat2 = resample_space(dat2, dat1);
            dat1.dat = mean([dat1.dat, dat2.dat], 2);
            final_data_midant_ses1_c3.dat(:, final_sub_count) = dat1.dat;
            pids_midant_s1_c3{end+1} = pid;
            final_sub_count = final_sub_count + 1;
        end
    end

    % --- Outcome C1 ---
    clear dat1 dat2
    final_data_midout_ses1_c1 = fmri_data(fmidout_s1_run2_c1{1});
    final_sub_count = 1;
    pids_midout_s1_c1 = {};
    for sub = 1:length(fmidout_s1_run2_c1)
        pid = fmidout_s1_run2_c1{sub}(5:9);
        if sum(contains(fmidout_s1_run1_c1(:), pid)) ~= 0
            tempfname_run1 = fmidout_s1_run1_c1{contains(fmidout_s1_run1_c1(:), pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidout_s1_run2_c1{sub});
            %dat2 = resample_space(dat2, dat1);
            dat1.dat = mean([dat1.dat, dat2.dat], 2);
            final_data_midout_ses1_c1.dat(:, final_sub_count) = dat1.dat;
            pids_midout_s1_c1{end+1} = pid;
            final_sub_count = final_sub_count + 1;
        end
    end

    % --- Outcome C2 ---
    clear dat1 dat2
    final_data_midout_ses1_c2 = fmri_data(fmidout_s1_run2_c2{1});
    final_sub_count = 1;
    pids_midout_s1_c2 = {};
    for sub = 1:length(fmidout_s1_run2_c2)
        pid = fmidout_s1_run2_c2{sub}(5:9);
        if sum(contains(fmidout_s1_run1_c2(:), pid)) ~= 0
            tempfname_run1 = fmidout_s1_run1_c2{contains(fmidout_s1_run1_c2(:), pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidout_s1_run2_c2{sub});
            %dat2 = resample_space(dat2, dat1);
            dat1.dat = mean([dat1.dat, dat2.dat], 2);
            final_data_midout_ses1_c2.dat(:, final_sub_count) = dat1.dat;
            pids_midout_s1_c2{end+1} = pid;
            final_sub_count = final_sub_count + 1;
        end
    end

    % --- Outcome C3 ---
    clear dat1 dat2
    final_data_midout_ses1_c3 = fmri_data(fmidout_s1_run2_c3{1});
    final_sub_count = 1;
    pids_midout_s1_c3 = {};
    for sub = 1:length(fmidout_s1_run2_c3)
        pid = fmidout_s1_run2_c3{sub}(5:9);
        if sum(contains(fmidout_s1_run1_c3(:), pid)) ~= 0
            tempfname_run1 = fmidout_s1_run1_c3{contains(fmidout_s1_run1_c3(:), pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidout_s1_run2_c3{sub});
            %dat2 = resample_space(dat2, dat1);
            dat1.dat = mean([dat1.dat, dat2.dat], 2);
            final_data_midout_ses1_c3.dat(:, final_sub_count) = dat1.dat;
            pids_midout_s1_c3{end+1} = pid;
            final_sub_count = final_sub_count + 1;
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% save per-contrast PIDs and data objects (paths kept as in your script)
    save pids.mat pids_midant_s1_c1 pids_midant_s1_c2 pids_midant_s1_c3 ...
                   pids_midout_s1_c1 pids_midout_s1_c2 pids_midout_s1_c3

    save final_data_midant_ses1_c1.mat final_data_midant_ses1_c1
    save final_data_midant_ses1_c2.mat final_data_midant_ses1_c2
    save final_data_midant_ses1_c3.mat final_data_midant_ses1_c3
    save final_data_midout_ses1_c1.mat final_data_midout_ses1_c1
    save final_data_midout_ses1_c2.mat final_data_midout_ses1_c2
    save final_data_midout_ses1_c3.mat final_data_midout_ses1_c3

else
    load(fullfile(datadir,"final_data_midant_ses1_c1.mat"))
    load(fullfile(datadir,"final_data_midant_ses1_c2.mat"))
    load(fullfile(datadir,"final_data_midant_ses1_c3.mat"))
    load(fullfile(datadir,"final_data_midout_ses1_c1.mat"))
    load(fullfile(datadir,"final_data_midout_ses1_c2.mat"))
    load(fullfile(datadir,"final_data_midout_ses1_c3.mat"))
    load(fullfile(datadir,"pids.mat"));
end

%% ROI extraction and tables (per contrast; no merging)
redo_regions = 1;

if redo_regions == 1
    % ---------- Anticipation custom ROIs ----------
    % C1
    T_midants1_c1 = [];
    names = [];
    all_regions = filenames(fullfile('/Users/ninakougan/Documents/rois/anticipation/*.nii'));
    for r = 1:length(all_regions)
        [~,name,~] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midant_ses1_c1, roi);
        T_midants1_c1 = [T_midants1_c1, temp_region.dat];
        names{r} = name; 
    end
    T_midants1_c1 = array2table(T_midants1_c1);
    T_midants1_c1.Properties.VariableNames = names;
    T_midants1_c1 = [cell2table(pids_midant_s1_c1', 'VariableNames', {'PID'}), T_midants1_c1];
    save T_midants1_c1.mat T_midants1_c1

    % C2
    T_midants1_c2 = [];
    names = [];
    all_regions = filenames(fullfile('/Users/ninakougan/Documents/rois/anticipation/*.nii'));
    for r = 1:length(all_regions)
        [~,name,~] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midant_ses1_c2, roi);
        T_midants1_c2 = [T_midants1_c2, temp_region.dat];
        names{r} = name; 
    end
    T_midants1_c2 = array2table(T_midants1_c2);
    T_midants1_c2.Properties.VariableNames = names;
    T_midants1_c2 = [cell2table(pids_midant_s1_c2', 'VariableNames', {'PID'}), T_midants1_c2];
    save T_midants1_c2.mat T_midants1_c2

    % C3
    T_midants1_c3 = [];
    names = [];
    all_regions = filenames(fullfile('/Users/ninakougan/Documents/rois/anticipation/*.nii'));
    for r = 1:length(all_regions)
        [~,name,~] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midant_ses1_c3, roi);
        T_midants1_c3 = [T_midants1_c3, temp_region.dat];
        names{r} = name; 
    end
    T_midants1_c3 = array2table(T_midants1_c3);
    T_midants1_c3.Properties.VariableNames = names;
    T_midants1_c3 = [cell2table(pids_midant_s1_c3', 'VariableNames', {'PID'}), T_midants1_c3];
    save T_midants1_c3.mat T_midants1_c3

    % ---------- Outcome custom ROIs ----------
    % C1
    T_midouts1_c1 = [];
    names = [];
    all_regions = filenames(fullfile('/Users/ninakougan/Documents/rois/outcome/*.nii'));
    for r = 1:length(all_regions)
        [~,name,~] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midout_ses1_c1, roi);
        T_midouts1_c1 = [T_midouts1_c1, temp_region.dat];
        names{r} = name; 
    end
    T_midouts1_c1 = array2table(T_midouts1_c1);
    T_midouts1_c1.Properties.VariableNames = names;
    T_midouts1_c1 = [cell2table(pids_midout_s1_c1', 'VariableNames', {'PID'}), T_midouts1_c1];
    save T_midouts1_c1.mat T_midouts1_c1

    % C2
    T_midouts1_c2 = [];
    names = [];
    all_regions = filenames(fullfile('/Users/ninakougan/Documents/rois/outcome/*.nii'));
    for r = 1:length(all_regions)
        [~,name,~] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midout_ses1_c2, roi);
        T_midouts1_c2 = [T_midouts1_c2, temp_region.dat];
        names{r} = name; 
    end
    T_midouts1_c2 = array2table(T_midouts1_c2);
    T_midouts1_c2.Properties.VariableNames = names;
    T_midouts1_c2 = [cell2table(pids_midout_s1_c2', 'VariableNames', {'PID'}), T_midouts1_c2];
    save T_midouts1_c2.mat T_midouts1_c2

    % C3
    T_midouts1_c3 = [];
    names = [];
    all_regions = filenames(fullfile('/Users/ninakougan/Documents/rois/outcome/*.nii'));
    for r = 1:length(all_regions)
        [~,name,~] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midout_ses1_c3, roi);
        T_midouts1_c3 = [T_midouts1_c3, temp_region.dat];
        names{r} = name; 
    end
    T_midouts1_c3 = array2table(T_midouts1_c3);
    T_midouts1_c3.Properties.VariableNames = names;
    T_midouts1_c3 = [cell2table(pids_midout_s1_c3', 'VariableNames', {'PID'}), T_midouts1_c3];
    save T_midouts1_c3.mat T_midouts1_c3

    % ---------- AAL3 atlas for all ----------
    clear names
    atl = fmri_data('/Users/ninakougan/Documents/rois/aal3/AAL3v1.nii');
    labels = readtable('/Users/ninakougan/Documents/rois/aal3/AAL3v1.nii.txt');
    labels(isnan(labels.Var3),:) = [];

    aal_mid_ant_s1_c1 = extract_roi_averages(final_data_midant_ses1_c1, atl);
    aal_mid_ant_s1_c2 = extract_roi_averages(final_data_midant_ses1_c2, atl);
    aal_mid_ant_s1_c3 = extract_roi_averages(final_data_midant_ses1_c3, atl);
    aal_mid_out_s1_c1 = extract_roi_averages(final_data_midout_ses1_c1, atl);
    aal_mid_out_s1_c2 = extract_roi_averages(final_data_midout_ses1_c2, atl);
    aal_mid_out_s1_c3 = extract_roi_averages(final_data_midout_ses1_c3, atl);    

    for i = 1:length(labels.Var2)
        T_aal_mid_ant_s1_c1(:,i) = aal_mid_ant_s1_c1(i).dat;
        T_aal_mid_ant_s1_c2(:,i) = aal_mid_ant_s1_c2(i).dat;
        T_aal_mid_ant_s1_c3(:,i) = aal_mid_ant_s1_c3(i).dat;
        T_aal_mid_out_s1_c1(:,i) = aal_mid_out_s1_c1(i).dat;
        T_aal_mid_out_s1_c2(:,i) = aal_mid_out_s1_c2(i).dat;
        T_aal_mid_out_s1_c3(:,i) = aal_mid_out_s1_c3(i).dat;
        names{i} = labels.Var2{i};
    end

    T_aal_mid_ant_s1_c1 = array2table(T_aal_mid_ant_s1_c1);
    T_aal_mid_ant_s1_c1.Properties.VariableNames = names;
    T_aal_mid_ant_s1_c1 = [cell2table(pids_midant_s1_c1', 'VariableNames', {'PID'}), T_aal_mid_ant_s1_c1];

    T_aal_mid_ant_s1_c2 = array2table(T_aal_mid_ant_s1_c2);
    T_aal_mid_ant_s1_c2.Properties.VariableNames = names;
    T_aal_mid_ant_s1_c2 = [cell2table(pids_midant_s1_c2', 'VariableNames', {'PID'}), T_aal_mid_ant_s1_c2];

    T_aal_mid_ant_s1_c3 = array2table(T_aal_mid_ant_s1_c3);
    T_aal_mid_ant_s1_c3.Properties.VariableNames = names;
    T_aal_mid_ant_s1_c3 = [cell2table(pids_midant_s1_c3', 'VariableNames', {'PID'}), T_aal_mid_ant_s1_c3];

    T_aal_mid_out_s1_c1 = array2table(T_aal_mid_out_s1_c1);
    T_aal_mid_out_s1_c1.Properties.VariableNames = names;
    T_aal_mid_out_s1_c1 = [cell2table(pids_midout_s1_c1', 'VariableNames', {'PID'}), T_aal_mid_out_s1_c1];

    T_aal_mid_out_s1_c2 = array2table(T_aal_mid_out_s1_c2);
    T_aal_mid_out_s1_c2.Properties.VariableNames = names;
    T_aal_mid_out_s1_c2 = [cell2table(pids_midout_s1_c2', 'VariableNames', {'PID'}), T_aal_mid_out_s1_c2];

    T_aal_mid_out_s1_c3 = array2table(T_aal_mid_out_s1_c3);
    T_aal_mid_out_s1_c3.Properties.VariableNames = names;
    T_aal_mid_out_s1_c3 = [cell2table(pids_midout_s1_c3', 'VariableNames', {'PID'}), T_aal_mid_out_s1_c3];

    save T_aal_mid_ant_s1_c1.mat T_aal_mid_ant_s1_c1
    save T_aal_mid_ant_s1_c2.mat T_aal_mid_ant_s1_c2
    save T_aal_mid_ant_s1_c3.mat T_aal_mid_ant_s1_c3

    save T_aal_mid_out_s1_c1.mat T_aal_mid_out_s1_c1
    save T_aal_mid_out_s1_c2.mat T_aal_mid_out_s1_c2
    save T_aal_mid_out_s1_c3.mat T_aal_mid_out_s1_c3

end

%% ---- Merge AAL3 + custom ROIs per contrast (by PID) ----
% Prefix AAL3 column names (leave PID as-is)
v = T_aal_mid_ant_s1_c1.Properties.VariableNames; v(2:end) = strcat('AAL3_', v(2:end)); T_aal_mid_ant_s1_c1.Properties.VariableNames = v;
v = T_aal_mid_ant_s1_c2.Properties.VariableNames; v(2:end) = strcat('AAL3_', v(2:end)); T_aal_mid_ant_s1_c2.Properties.VariableNames = v;
v = T_aal_mid_ant_s1_c3.Properties.VariableNames; v(2:end) = strcat('AAL3_', v(2:end)); T_aal_mid_ant_s1_c3.Properties.VariableNames = v;

v = T_aal_mid_out_s1_c1.Properties.VariableNames; v(2:end) = strcat('AAL3_', v(2:end)); T_aal_mid_out_s1_c1.Properties.VariableNames = v;
v = T_aal_mid_out_s1_c2.Properties.VariableNames; v(2:end) = strcat('AAL3_', v(2:end)); T_aal_mid_out_s1_c2.Properties.VariableNames = v;
v = T_aal_mid_out_s1_c3.Properties.VariableNames; v(2:end) = strcat('AAL3_', v(2:end)); T_aal_mid_out_s1_c3.Properties.VariableNames = v;

% Helper to exclude PID from right table variables (avoids duplicate key)
rv = @(T) T.Properties.VariableNames(~strcmp(T.Properties.VariableNames,'PID'));

% Anticipation merges (no MergeKeys; exclude right PID)
MID_ant_S1C1_merged = innerjoin(T_midants1_c1, T_aal_mid_ant_s1_c1, 'Keys','PID', 'RightVariables', rv(T_aal_mid_ant_s1_c1));
MID_ant_S1C2_merged = innerjoin(T_midants1_c2, T_aal_mid_ant_s1_c2, 'Keys','PID', 'RightVariables', rv(T_aal_mid_ant_s1_c2));
MID_ant_S1C3_merged = innerjoin(T_midants1_c3, T_aal_mid_ant_s1_c3, 'Keys','PID', 'RightVariables', rv(T_aal_mid_ant_s1_c3));

% Outcome merges
MID_out_S1C1_merged = innerjoin(T_midouts1_c1, T_aal_mid_out_s1_c1, 'Keys','PID', 'RightVariables', rv(T_aal_mid_out_s1_c1));
MID_out_S1C2_merged = innerjoin(T_midouts1_c2, T_aal_mid_out_s1_c2, 'Keys','PID', 'RightVariables', rv(T_aal_mid_out_s1_c2));
MID_out_S1C3_merged = innerjoin(T_midouts1_c3, T_aal_mid_out_s1_c3, 'Keys','PID', 'RightVariables', rv(T_aal_mid_out_s1_c3));

% Write merged tables
writetable(MID_ant_S1C1_merged, 'MID_ant_S1C1_merged.txt', 'Delimiter','\t');
writetable(MID_ant_S1C2_merged, 'MID_ant_S1C2_merged.txt', 'Delimiter','\t');
writetable(MID_ant_S1C3_merged, 'MID_ant_S1C3_merged.txt', 'Delimiter','\t');

writetable(MID_out_S1C1_merged, 'MID_out_S1C1_merged.txt', 'Delimiter','\t');
writetable(MID_out_S1C2_merged, 'MID_out_S1C2_merged.txt', 'Delimiter','\t');
writetable(MID_out_S1C3_merged, 'MID_out_S1C3_merged.txt', 'Delimiter','\t');
