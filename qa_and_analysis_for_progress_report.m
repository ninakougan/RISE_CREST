fldir = '/Users/ninakougan/Documents/rise';
datadir = '/Users/ninakougan/Documents/rise/output';

remake_data_obj = 1;

if remake_data_obj == 1

    cd(fldir)
    
    fmidant_s1_run1_c1 = filenames(fullfile('sub-*/ses-1/anticipation/run-01/con_0001.nii'));
    fmidant_s1_run1_c2 = filenames(fullfile('sub-*/ses-1/anticipation/run-01/con_0002.nii'));
    fmidant_s1_run1_c3 = filenames(fullfile('sub-*/ses-1/anticipation/run-01/con_0003.nii'));
    fmidant_s1_run2_c1 = filenames(fullfile('sub-*/ses-1/anticipation/run-02/con_0001.nii'));
    fmidant_s1_run2_c2 = filenames(fullfile('sub-*/ses-1/anticipation/run-02/con_0002.nii'));
    fmidant_s1_run2_c3 = filenames(fullfile('sub-*/ses-1/anticipation/run-02/con_0003.nii'));
    fmidout_s1_run1_c1 = filenames(fullfile('sub-*/ses-1/outcome/run-01/con_0001.nii'));
    fmidout_s1_run1_c2 = filenames(fullfile('sub-*/ses-1/outcome/run-01/con_0002.nii'));
    fmidout_s1_run1_c3 = filenames(fullfile('sub-*/ses-1/outcome/run-01/con_0003.nii'));
    fmidout_s1_run2_c1 = filenames(fullfile('sub-*/ses-1/outcome/run-02/con_0001.nii'));
    fmidout_s1_run2_c2 = filenames(fullfile('sub-*/ses-1/outcome/run-02/con_0002.nii'));
    fmidout_s1_run2_c3 = filenames(fullfile('sub-*/ses-1/outcome/run-02/con_0003.nii'));

    %% MID ses-1
    % this will be for ses-1 mid gain ancitipation c1
    final_data_midant_ses1_c1 = fmri_data(fmidant_s1_run2_c1{1}); % place holder that will have all the appropriate space related information about the scans
    final_sub_count = 1;
    for sub=1:length(fmidant_s1_run2_c1) % start with run2 because there are fewer files
        pid = fmidant_s1_run2_c1{sub}(5:9);
        %keyboard
        
        if sum(contains(fmidant_s1_run1_c1(:),pid))~=0
            pid_midant_s1{sub} = fmidant_s1_run2_c1{sub}(5:9);
            tempfname_run1 = fmidant_s1_run1_c1{contains(fmidant_s1_run1_c1(:),pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidant_s1_run2_c1{sub});
            dat2 = resample_space(dat2, dat1);
            dat1.dat = mean([dat1.dat,dat2.dat],2);
            final_data_midant_ses1_c1.dat(:,final_sub_count) = dat1.dat;
            final_sub_count = final_sub_count + 1;
        else
            continue
        end
    end
    %%
    clear dat1 dat2
    % this will be for ses-1 mid loss ancitipation c2
    final_data_midant_ses1_c2 = fmri_data(fmidant_s1_run2_c2{1}); % place holder that will have all the appropriate space related information about the scans
    final_sub_count = 1;
    for sub=1:length(fmidant_s1_run2_c2) % start with run2 because there are fewer files
        pid = fmidant_s1_run2_c2{sub}(5:9);
        
        if sum(contains(fmidant_s1_run1_c2(:),pid))~=0
            tempfname_run1 = fmidant_s1_run1_c2{contains(fmidant_s1_run1_c2(:),pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidant_s1_run2_c2{sub});
            dat2 = resample_space(dat2, dat1);
            dat1.dat = mean([dat1.dat,dat2.dat],2);
            final_data_midant_ses1_c2.dat(:,final_sub_count) = dat1.dat;
            final_sub_count = final_sub_count + 1;
        else
            continue
        end
    end

    %%
    clear dat1 dat2
    % this will be for ses-1 mid gain-loss ancitipation c3
    final_data_midant_ses1_c3 = fmri_data(fmidant_s1_run2_c3{1}); % place holder that will have all the appropriate space related information about the scans
    final_sub_count = 1;
    for sub=1:length(fmidant_s1_run2_c3) % start with run2 because there are fewer files
        pid = fmidant_s1_run2_c3{sub}(5:9);
        
        if sum(contains(fmidant_s1_run1_c3(:),pid))~=0
            tempfname_run1 = fmidant_s1_run1_c3{contains(fmidant_s1_run1_c3(:),pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidant_s1_run2_c3{sub});
            dat2 = resample_space(dat2, dat1);
            dat1.dat = mean([dat1.dat,dat2.dat],2);
            final_data_midant_ses1_c3.dat(:,final_sub_count) = dat1.dat;
            final_sub_count = final_sub_count + 1;
        else
            continue
        end
    end
    %%
    clear dat1 dat2
    % this will be for ses-1 mid gain outcome c1
    final_data_midout_ses1_c1 = fmri_data(fmidout_s1_run2_c1{1}); % place holder that will have all the appropriate space related information about the scans
    final_sub_count = 1;
    for sub=1:length(fmidout_s1_run2_c1) % start with run2 because there are fewer files
        pid = fmidout_s1_run2_c1{sub}(5:9);
        
        if sum(contains(fmidout_s1_run1_c1(:),pid))~=0
            pid_midout_s1{sub} = fmidout_s1_run2_c1{sub}(5:9);
            tempfname_run1 = fmidout_s1_run1_c1{contains(fmidout_s1_run1_c1(:),pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidout_s1_run2_c1{sub});
            dat2 = resample_space(dat2, dat1);
            dat1.dat = mean([dat1.dat,dat2.dat],2);
            final_data_midout_ses1_c1.dat(:,final_sub_count) = dat1.dat;
            final_sub_count = final_sub_count + 1;
        else
            continue
        end
    end
    %%
    clear dat1 dat2
    % this will be for ses-1 mid loss outcome c2
    final_data_midout_ses1_c2 = fmri_data(fmidout_s1_run2_c2{1}); % place holder that will have all the appropriate space related information about the scans
    final_sub_count = 1;
    for sub=1:length(fmidout_s1_run2_c2) % start with run2 because there are fewer files
        pid = fmidout_s1_run2_c2{sub}(5:9);
        
        if sum(contains(fmidout_s1_run1_c2(:),pid))~=0
            tempfname_run1 = fmidout_s1_run1_c2{contains(fmidout_s1_run1_c2(:),pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidout_s1_run2_c2{sub});
            dat2 = resample_space(dat2, dat1);
            dat1.dat = mean([dat1.dat,dat2.dat],2);
            final_data_midout_ses1_c2.dat(:,final_sub_count) = dat1.dat;
            final_sub_count = final_sub_count + 1;
        else
            continue
        end
    end
    %%
    clear dat1 dat2
    % this will be for ses-1 mid gain-loss outcome c3
    final_data_midout_ses1_c3 = fmri_data(fmidout_s1_run2_c3{1}); % place holder that will have all the appropriate space related information about the scans
    final_sub_count = 1;
    for sub=1:length(fmidout_s1_run2_c3) % start with run2 because there are fewer files
        pid = fmidout_s1_run2_c3{sub}(5:9);
        
        if sum(contains(fmidout_s1_run1_c3(:),pid))~=0
            tempfname_run1 = fmidout_s1_run1_c3{contains(fmidout_s1_run1_c3(:),pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidout_s1_run2_c3{sub});
            dat2 = resample_space(dat2, dat1);
            dat1.dat = mean([dat1.dat,dat2.dat],2);
            final_data_midout_ses1_c3.dat(:,final_sub_count) = dat1.dat;
            final_sub_count = final_sub_count + 1;
        else
            continue
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% save all pids to be added to tables below
    save pids.mat pid_midant_s1 pid_midout_s1 %pid_midant_s2 pid_midout_s2 %pid_chat_s1 pid_chat_s2
    %% save all MID ses1
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

%% whole brain regression models for mid

final_data_midant_ses1_c1.X = ones(size(final_data_midant_ses1_c1.dat,2),1);
final_data_midant_ses1_c2.X = ones(size(final_data_midant_ses1_c2.dat,2),1);
final_data_midant_ses1_c3.X = ones(size(final_data_midant_ses1_c3.dat,2),1);
final_data_midout_ses1_c1.X = ones(size(final_data_midout_ses1_c1.dat,2),1);
final_data_midout_ses1_c2.X = ones(size(final_data_midout_ses1_c2.dat,2),1);
final_data_midout_ses1_c3.X = ones(size(final_data_midout_ses1_c3.dat,2),1);

% final_data_midant_ses2_c1.X = ones(size(final_data_midant_ses2_c1.dat,2),1);
% final_data_midant_ses2_c2.X = ones(size(final_data_midant_ses2_c2.dat,2),1);
% final_data_midant_ses2_c3.X = ones(size(final_data_midant_ses2_c3.dat,2),1);
% final_data_midout_ses2_c1.X = ones(size(final_data_midout_ses2_c1.dat,2),1);
% final_data_midout_ses2_c2.X = ones(size(final_data_midout_ses2_c2.dat,2),1);
% final_data_midout_ses2_c3.X = ones(size(final_data_midout_ses2_c3.dat,2),1);

stat_midant_ses1_c1 = regress(final_data_midant_ses1_c1);
stat_midant_ses1_c2 = regress(final_data_midant_ses1_c2);
stat_midant_ses1_c3 = regress(final_data_midant_ses1_c3);
stat_midout_ses1_c1 = regress(final_data_midout_ses1_c1);
stat_midout_ses1_c2 = regress(final_data_midout_ses1_c2);
stat_midout_ses1_c3 = regress(final_data_midout_ses1_c3);

% stat_midant_ses2_c1 = regress(final_data_midant_ses2_c1);
% stat_midant_ses2_c2 = regress(final_data_midant_ses2_c2);
% stat_midant_ses2_c3 = regress(final_data_midant_ses2_c3);
% stat_midout_ses2_c1 = regress(final_data_midout_ses2_c1);
% stat_midout_ses2_c2 = regress(final_data_midout_ses2_c2);
% stat_midout_ses2_c3 = regress(final_data_midout_ses2_c3);

thresh_midant_ses1_c1 = threshold(stat_midant_ses1_c1.t,0.05,'fdr','k',10);
thresh_midant_ses1_c2 = threshold(stat_midant_ses1_c2.t,0.05,'fdr','k',10);
thresh_midant_ses1_c3 = threshold(stat_midant_ses1_c3.t,0.05,'fdr','k',10);
thresh_midout_ses1_c1 = threshold(stat_midout_ses1_c1.t,0.05,'fdr','k',10);
thresh_midout_ses1_c2 = threshold(stat_midout_ses1_c2.t,0.05,'fdr','k',10);
thresh_midout_ses1_c3 = threshold(stat_midout_ses1_c3.t,0.05,'fdr','k',10);

% %%
redo_regions = 1;

if redo_regions == 1
    % mid ant ses1 c1
    T_midants1_c1 = [];
    names = [];
    all_regions = filenames(fullfile('/Users/ninakougan/Documents/rois/anticipation/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midant_ses1_c1,roi);
        T_midants1_c1 = [T_midants1_c1,temp_region.dat];
        names{r} = name; 
    end
    T_midants1_c1=array2table(T_midants1_c1);
    T_midants1_c1.Properties.VariableNames = names;
    T_midants1_c1 = [cell2table(pid_midant_s1'), T_midants1_c1];
    T_midants1_c1.Properties.VariableNames{1} = 'PID';
    save T_midants1_c1.mat T_midants1_c1

    % mid ant ses1 c2
    T_midants1_c2 = [];
    names = [];
    all_regions = filenames(fullfile('/Users/ninakougan/Documents/rois/anticipation/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midant_ses1_c2,roi);
        T_midants1_c2 = [T_midants1_c2,temp_region.dat];
        names{r} = name; 
    end
    T_midants1_c2=array2table(T_midants1_c2);
    T_midants1_c2.Properties.VariableNames = names;
    T_midants1_c2 = [cell2table(pid_midant_s1'), T_midants1_c2];
    T_midants1_c2.Properties.VariableNames{1} = 'PID';
    save T_midants1_c2.mat T_midants1_c2

    % mid ant ses1 c3
    T_midants1_c3 = [];
    names = [];
    all_regions = filenames(fullfile('/Users/ninakougan/Documents/rois/anticipation/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midant_ses1_c3,roi);
        T_midants1_c3 = [T_midants1_c3,temp_region.dat];
        names{r} = name; 
    end
    T_midants1_c3=array2table(T_midants1_c3);
    T_midants1_c3.Properties.VariableNames = names;
    pid_midant_s1 = pid_midant_s1(~cellfun('isempty',pid_midant_s1));
    T_midants1_c3 = [cell2table(pid_midant_s1'), T_midants1_c3];
    T_midants1_c3.Properties.VariableNames{1} = 'PID';
    save T_midants1_c3.mat T_midants1_c3

    % mid out ses1 c1
    T_midouts1_c1 = [];
    names = [];
    all_regions = filenames(fullfile('/Users/ninakougan/Documents/rois/outcome/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midout_ses1_c1,roi);
        T_midouts1_c1 = [T_midouts1_c1,temp_region.dat];
        names{r} = name; 
    end
    T_midouts1_c1=array2table(T_midouts1_c1);
    T_midouts1_c1.Properties.VariableNames = names;
    pid_midout_s1 = pid_midout_s1(~cellfun('isempty',pid_midout_s1));
    T_midouts1_c1 = [cell2table(pid_midout_s1'), T_midouts1_c1];
    T_midouts1_c1.Properties.VariableNames{1} = 'PID';
    save T_midouts1_c1.mat T_midouts1_c1

    % mid out ses1 c2
    T_midouts1_c2 = [];
    names = [];
    all_regions = filenames(fullfile('/Users/ninakougan/Documents/rois/outcome/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midout_ses1_c2,roi);
        T_midouts1_c2 = [T_midouts1_c2,temp_region.dat];
        names{r} = name; 
    end
    T_midouts1_c2=array2table(T_midouts1_c2);
    T_midouts1_c2.Properties.VariableNames = names;
    pid_midout_s1 = pid_midout_s1(~cellfun('isempty',pid_midout_s1));
    T_midouts1_c2 = [cell2table(pid_midout_s1'), T_midouts1_c2];
    T_midouts1_c2.Properties.VariableNames{1} = 'PID';
    save T_midouts1_c2.mat T_midouts1_c2

    % mid out ses1 c3
    T_midouts1_c3 = [];
    names = [];
    all_regions = filenames(fullfile('/Users/ninakougan/Documents/rois/outcome/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midout_ses1_c3,roi);
        T_midouts1_c3 = [T_midouts1_c3,temp_region.dat];
        names{r} = name; 
    end
    T_midouts1_c3=array2table(T_midouts1_c3);
    T_midouts1_c3.Properties.VariableNames = names;
    pid_midout_s1 = pid_midout_s1(~cellfun('isempty',pid_midout_s1));
    T_midouts1_c3 = [cell2table(pid_midout_s1'), T_midouts1_c3];
    T_midouts1_c3.Properties.VariableNames{1} = 'PID';
    save T_midouts1_c3.mat T_midouts1_c3

% %%
    % AAL3 atlas for all
    clear names
    atl = fmri_data('/Users/ninakougan/Documents/rois/aal3/AAL3v1.nii');
    labels = readtable('/Users/ninakougan/Documents/rois/aal3/AAL3v1.nii.txt');
    labels(isnan(labels.Var3),:) = [];

    aal_mid_ant_s1_c1 = extract_roi_averages(final_data_midant_ses1_c1,atl);
    aal_mid_ant_s1_c2 = extract_roi_averages(final_data_midant_ses1_c2,atl);
    aal_mid_ant_s1_c3 = extract_roi_averages(final_data_midant_ses1_c3,atl);
    aal_mid_out_s1_c1 = extract_roi_averages(final_data_midout_ses1_c1,atl);
    aal_mid_out_s1_c2 = extract_roi_averages(final_data_midout_ses1_c2,atl);
    aal_mid_out_s1_c3 = extract_roi_averages(final_data_midout_ses1_c3,atl);    

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
    T_aal_mid_ant_s1_c1 = [cell2table(pid_midant_s1'),T_aal_mid_ant_s1_c1];
    T_aal_mid_ant_s1_c1.Properties.VariableNames{1} = 'PID';

    T_aal_mid_ant_s1_c2 = array2table(T_aal_mid_ant_s1_c2);
    T_aal_mid_ant_s1_c2.Properties.VariableNames = names;
    T_aal_mid_ant_s1_c2 = [cell2table(pid_midant_s1'),T_aal_mid_ant_s1_c2];
    T_aal_mid_ant_s1_c2.Properties.VariableNames{1} = 'PID';

    T_aal_mid_ant_s1_c3 = array2table(T_aal_mid_ant_s1_c3);
    T_aal_mid_ant_s1_c3.Properties.VariableNames = names;
    T_aal_mid_ant_s1_c3 = [cell2table(pid_midant_s1'),T_aal_mid_ant_s1_c3];
    T_aal_mid_ant_s1_c3.Properties.VariableNames{1} = 'PID';

    T_aal_mid_out_s1_c1 = array2table(T_aal_mid_out_s1_c1);
    T_aal_mid_out_s1_c1.Properties.VariableNames = names;
    T_aal_mid_out_s1_c1 = [cell2table(pid_midout_s1'),T_aal_mid_out_s1_c1];
    T_aal_mid_out_s1_c1.Properties.VariableNames{1} = 'PID';

    T_aal_mid_out_s1_c2 = array2table(T_aal_mid_out_s1_c2);
    T_aal_mid_out_s1_c2.Properties.VariableNames = names;
    T_aal_mid_out_s1_c2 = [cell2table(pid_midout_s1'),T_aal_mid_out_s1_c2];
    T_aal_mid_out_s1_c2.Properties.VariableNames{1} = 'PID';

    T_aal_mid_out_s1_c3 = array2table(T_aal_mid_out_s1_c3);
    T_aal_mid_out_s1_c3.Properties.VariableNames = names;
    T_aal_mid_out_s1_c3 = [cell2table(pid_midout_s1'),T_aal_mid_out_s1_c3];
    T_aal_mid_out_s1_c3.Properties.VariableNames{1} = 'PID';

    save T_aal_mid_ant_s1_c1.mat T_aal_mid_ant_s1_c1
    save T_aal_mid_ant_s1_c2.mat T_aal_mid_ant_s1_c2
    save T_aal_mid_ant_s1_c3.mat T_aal_mid_ant_s1_c3

    save T_aal_mid_out_s1_c1.mat T_aal_mid_out_s1_c1
    save T_aal_mid_out_s1_c2.mat T_aal_mid_out_s1_c2
    save T_aal_mid_out_s1_c3.mat T_aal_mid_out_s1_c3

end

%write out to csvs

writetable(T_aal_mid_ant_s1_c1, 'AAL_MID_ant_S1C1.txt', 'Delimiter','\t');
writetable(T_aal_mid_ant_s1_c2, 'AAL_MID_ant_S1C2.txt', 'Delimiter','\t');
writetable(T_aal_mid_ant_s1_c3, 'AAL_MID_ant_S1C3.txt', 'Delimiter','\t');

writetable(T_aal_mid_out_s1_c1, 'AAL_MID_out_S1C1.txt', 'Delimiter','\t');
writetable(T_aal_mid_out_s1_c2, 'AAL_MID_out_S1C2.txt', 'Delimiter','\t');
writetable(T_aal_mid_out_s1_c3, 'AAL_MID_out_S1C3.txt', 'Delimiter','\t');

writetable(T_midants1_c1, 'MID_ant_S1C1.txt', 'Delimiter','\t');
writetable(T_midants1_c2, 'MID_ant_S1C2.txt', 'Delimiter','\t');
writetable(T_midants1_c3, 'MID_ant_S1C3.txt', 'Delimiter','\t');

writetable(T_midouts1_c1, 'MID_out_S1C1.txt', 'Delimiter','\t');
writetable(T_midouts1_c2, 'MID_out_S1C2.txt', 'Delimiter','\t');
writetable(T_midouts1_c3, 'MID_out_S1C3.txt', 'Delimiter','\t');