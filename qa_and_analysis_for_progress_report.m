fldir = '/projects/b1108/studies/rise/data/processed/neuroimaging/august24_T1/fl';
datadir = '/users/ninakougan/Downloads';

remake_data_obj = 0;

if remake_data_obj == 1

    cd(fldir)
    
    fmidant_s1_run1_c1 = filenames(fullfile('sub-*/ses-1/anticipation/run-01/con_0001.nii'));
    fmidant_s1_run1_c2 = filenames(fullfile('sub-*/ses-1/anticipation/run-01/con_0002.nii'));
    fmidant_s1_run1_c3 = filenames(fullfile('sub-*/ses-1/anticipation/run-01/con_0003.nii'));
    fmidant_s1_run2_c1 = filenames(fullfile('sub-*/ses-1/anticipation/run-02/con_0001.nii'));
    fmidant_s1_run2_c2 = filenames(fullfile('sub-*/ses-1/anticipation/run-02/con_0001.nii'));
    fmidant_s1_run2_c3 = filenames(fullfile('sub-*/ses-1/anticipation/run-02/con_0001.nii'));
    fmidout_s1_run1_c1 = filenames(fullfile('sub-*/ses-1/outcome/run-01/con_0001.nii'));
    fmidout_s1_run1_c2 = filenames(fullfile('sub-*/ses-1/outcome/run-01/con_0002.nii'));
    fmidout_s1_run1_c3 = filenames(fullfile('sub-*/ses-1/outcome/run-01/con_0003.nii'));
    fmidout_s1_run2_c1 = filenames(fullfile('sub-*/ses-1/outcome/run-02/con_0001.nii'));
    fmidout_s1_run2_c2 = filenames(fullfile('sub-*/ses-1/outcome/run-02/con_0002.nii'));
    fmidout_s1_run2_c3 = filenames(fullfile('sub-*/ses-1/outcome/run-02/con_0003.nii'));
    %fchat_s1_accrej = filenames(fullfile('sub-*/ses-1/chatroom/run-01/con_0001.nii'));
    %fchat_s1_acc = filenames(fullfile('sub-*/ses-1/chatroom/run-01/con_0002.nii'));
    %fchat_s1_rej = filenames(fullfile('sub-*/ses-1/chatroom/run-01/con_0003.nii'));
        
    %fmidant_s2_run1_c1 = filenames(fullfile('sub-*/ses-2/anticipation/run-01/con_0001.nii'));
    %fmidant_s2_run1_c2 = filenames(fullfile('sub-*/ses-2/anticipation/run-01/con_0002.nii'));
    %fmidant_s2_run1_c3 = filenames(fullfile('sub-*/ses-2/anticipation/run-01/con_0003.nii'));
    %fmidant_s2_run2_c1 = filenames(fullfile('sub-*/ses-2/anticipation/run-02/con_0001.nii'));
    %fmidant_s2_run2_c2 = filenames(fullfile('sub-*/ses-2/anticipation/run-02/con_0002.nii'));
    %fmidant_s2_run2_c3 = filenames(fullfile('sub-*/ses-2/anticipation/run-02/con_0003.nii'));
    %fmidout_s2_run1_c1 = filenames(fullfile('sub-*/ses-2/outcome/run-01/con_0001.nii'));
    %fmidout_s2_run1_c2 = filenames(fullfile('sub-*/ses-2/outcome/run-01/con_0002.nii'));
    %fmidout_s2_run1_c3 = filenames(fullfile('sub-*/ses-2/outcome/run-01/con_0003.nii'));
    %fmidout_s2_run2_c1 = filenames(fullfile('sub-*/ses-2/outcome/run-02/con_0001.nii'));
    %fmidout_s2_run2_c2 = filenames(fullfile('sub-*/ses-2/outcome/run-02/con_0002.nii'));
    %fmidout_s2_run2_c3 = filenames(fullfile('sub-*/ses-2/outcome/run-02/con_0003.nii'));
    %fchat_s2_accrej = filenames(fullfile('sub-*/ses-2/chatroom/run-01/con_0001.nii'));
    %fchat_s2_acc = filenames(fullfile('sub-*/ses-2/chatroom/run-01/con_0002.nii'));
    %fchat_s2_rej = filenames(fullfile('sub-*/ses-2/chatroom/run-01/con_0003.nii'));
    
    % apply exclusions based on 0.5mm FD
     load('/projects/b1108/studies/rise/data/processed/neuroimaging/exclusions_based_on_motion.mat');
    % chat_exclude_s1 = pid_exclude_list(contains(pid_exclude_list(:,2),'ses-1_chat'));
    % chat_exclude_s2 = pid_exclude_list(contains(pid_exclude_list(:,2),'ses-2_chat'));
     mid_exclude_s1 = pid_exclude_list(contains(pid_exclude_list(:,2),'ses-1_mid'));
    % mid_exclude_s2 = pid_exclude_list(contains(pid_exclude_list(:,2),'ses-1_mid'));
    % 
    % % chatroom ses1
    % for ex = 1:length(chat_exclude_s1)
    %     fchat_s1_accrej(contains(fchat_s1_accrej(:),chat_exclude_s1{ex})) = [];
    %     fchat_s1_acc(contains(fchat_s1_acc(:),chat_exclude_s1{ex})) = [];
    %     fchat_s1_rej(contains(fchat_s1_rej(:),chat_exclude_s1{ex})) = [];
    % end
    % 
    % % chatroom ses2
    % for ex = 1:length(chat_exclude_s2)
    %     fchat_s2_accrej(contains(fchat_s2_accrej(:),chat_exclude_s2{ex})) = [];
    %     fchat_s2_acc(contains(fchat_s2_acc(:),chat_exclude_s2{ex})) = [];
    %     fchat_s2_rej(contains(fchat_s2_rej(:),chat_exclude_s2{ex})) = [];
    % end
    % 
    % mid ses1
    % note that you only need to pull out fnames from run2 because later I
    % match run1 to run2
    for ex = 1:length(mid_exclude_s1)
        fmidant_s1_run2(contains(fmidant_s1_run2(:),mid_exclude_s1{ex})) = [];
        fmidout_s1_run2(contains(fmidout_s1_run2(:),mid_exclude_s1{ex})) = [];
    end
    % 
    % % mid ses2
    % for ex = 1:length(mid_exclude_s2)
    %     fmidant_s2_run2(contains(fmidant_s2_run2(:),mid_exclude_s2{ex})) = [];
    %     fmidout_s2_run2(contains(fmidout_s2_run2(:),mid_exclude_s2{ex})) = [];
    % end
    % 
    % % average mid runs and run whole brain regression to get average activation
    % during anticipation and outcome. Finally create a table of significantly
    % active regions of interest at a FDR<0.05 threshold.
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
            dat1.dat = mean([dat1.dat,dat2.dat],2);
            final_data_midout_ses1_c3.dat(:,final_sub_count) = dat1.dat;
            final_sub_count = final_sub_count + 1;
        else
            continue
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %% MID ses-2
    %     final_data_midant_ses2_c1 = fmri_data(fmidant_s2_run2_c1{1}); % place holder that will have all the appropriate space related information about the scans
    % final_sub_count = 1;
    % for sub=1:length(fmidant_s2_run2_c1) % start with run2 because there are fewer files
    %     pid = fmidant_s2_run2_c1{sub}(5:9);
    % 
    %     if sum(contains(fmidant_s2_run1_c1(:),pid))~=0
    %         pid_midant_s2{sub} = fmidant_s2_run2_c1{sub}(5:9);
    %         tempfname_run1 = fmidant_s2_run1_c1{contains(fmidant_s2_run1_c1(:),pid)};
    %         dat1 = fmri_data(tempfname_run1);
    %         dat2 = fmri_data(fmidant_s2_run2_c1{sub});
    %         dat1.dat = mean([dat1.dat,dat2.dat],2);
    %         final_data_midant_ses2_c1.dat(:,final_sub_count) = dat1.dat;
    %         final_sub_count = final_sub_count + 1;
    %     else
    %         continue
    %     end
    % end
    % %%
    % clear dat1 dat2
    % % this will be for ses-2 mid loss ancitipation c2
    % final_data_midant_ses2_c2 = fmri_data(fmidant_s2_run2_c2{1}); % place holder that will have all the appropriate space related information about the scans
    % final_sub_count = 1;
    % for sub=1:length(fmidant_s2_run2_c2) % start with run2 because there are fewer files
    %     pid = fmidant_s2_run2_c2{sub}(5:9);
    % 
    %     if sum(contains(fmidant_s2_run1_c2(:),pid))~=0
    %         tempfname_run1 = fmidant_s2_run1_c2{contains(fmidant_s2_run1_c2(:),pid)};
    %         dat1 = fmri_data(tempfname_run1);
    %         dat2 = fmri_data(fmidant_s2_run2_c2{sub});
    %         dat1.dat = mean([dat1.dat,dat2.dat],2);
    %         final_data_midant_ses2_c2.dat(:,final_sub_count) = dat1.dat;
    %         final_sub_count = final_sub_count + 1;
    %     else
    %         continue
    %     end
    % end
    % 
    % %%
    % clear dat1 dat2
    % % this will be for ses-2 mid gain-loss ancitipation c3
    % final_data_midant_ses2_c3 = fmri_data(fmidant_s2_run2_c3{1}); % place holder that will have all the appropriate space related information about the scans
    % final_sub_count = 1;
    % for sub=1:length(fmidant_s2_run2_c3) % start with run2 because there are fewer files
    %     pid = fmidant_s2_run2_c3{sub}(5:9);
    % 
    %     if sum(contains(fmidant_s2_run1_c3(:),pid))~=0
    %         tempfname_run1 = fmidant_s2_run1_c3{contains(fmidant_s2_run1_c3(:),pid)};
    %         dat1 = fmri_data(tempfname_run1);
    %         dat2 = fmri_data(fmidant_s2_run2_c3{sub});
    %         dat1.dat = mean([dat1.dat,dat2.dat],2);
    %         final_data_midant_ses2_c3.dat(:,final_sub_count) = dat1.dat;
    %         final_sub_count = final_sub_count + 1;
    %     else
    %         continue
    %     end
    % end
    % %%
    % clear dat1 dat2
    % % this will be for ses-2 mid gain outcome c1
    % final_data_midout_ses2_c1 = fmri_data(fmidout_s2_run2_c1{1}); % place holder that will have all the appropriate space related information about the scans
    % final_sub_count = 1;
    % for sub=1:length(fmidout_s2_run2_c1) % start with run2 because there are fewer files
    %     pid = fmidout_s2_run2_c1{sub}(5:9);
    % 
    %     if sum(contains(fmidout_s2_run1_c1(:),pid))~=0
    %         pid_midout_s2{sub} = fmidout_s2_run2_c1{sub}(5:9);
    %         tempfname_run1 = fmidout_s2_run1_c1{contains(fmidout_s2_run1_c1(:),pid)};
    %         dat1 = fmri_data(tempfname_run1);
    %         dat2 = fmri_data(fmidout_s2_run2_c1{sub});
    %         dat1.dat = mean([dat1.dat,dat2.dat],2);
    %         final_data_midout_ses2_c1.dat(:,final_sub_count) = dat1.dat;
    %         final_sub_count = final_sub_count + 1;
    %     else
    %         continue
    %     end
    % end
    % %%
    % clear dat1 dat2
    % % this will be for ses-2 mid loss outcome c2
    % final_data_midout_ses2_c2 = fmri_data(fmidout_s2_run2_c2{1}); % place holder that will have all the appropriate space related information about the scans
    % final_sub_count = 1;
    % for sub=1:length(fmidout_s2_run2_c2) % start with run2 because there are fewer files
    %     pid = fmidout_s2_run2_c2{sub}(5:9);
    % 
    %     if sum(contains(fmidout_s2_run1_c2(:),pid))~=0
    %         tempfname_run1 = fmidout_s2_run1_c2{contains(fmidout_s2_run1_c2(:),pid)};
    %         dat1 = fmri_data(tempfname_run1);
    %         dat2 = fmri_data(fmidout_s2_run2_c2{sub});
    %         dat1.dat = mean([dat1.dat,dat2.dat],2);
    %         final_data_midout_ses2_c2.dat(:,final_sub_count) = dat1.dat;
    %         final_sub_count = final_sub_count + 1;
    %     else
    %         continue
    %     end
    % end
    % %%
    % clear dat1 dat2
    % % this will be for ses-2 mid gain-loss outcome c3
    % final_data_midout_ses2_c3 = fmri_data(fmidout_s2_run2_c3{1}); % place holder that will have all the appropriate space related information about the scans
    % final_sub_count = 1;
    % for sub=1:length(fmidout_s2_run2_c3) % start with run2 because there are fewer files
    %     pid = fmidout_s2_run2_c3{sub}(5:9);
    % 
    %     if sum(contains(fmidout_s2_run1_c3(:),pid))~=0
    %         tempfname_run1 = fmidout_s2_run1_c3{contains(fmidout_s2_run1_c3(:),pid)};
    %         dat1 = fmri_data(tempfname_run1);
    %         dat2 = fmri_data(fmidout_s2_run2_c3{sub});
    %         dat1.dat = mean([dat1.dat,dat2.dat],2);
    %         final_data_midout_ses2_c3.dat(:,final_sub_count) = dat1.dat;
    %         final_sub_count = final_sub_count + 1;
    %     else
    %         continue
    %     end
    % end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %% chatroom ses-1
    % % this will be for ses-1 chatroom 
    % final_data_chatroom_ses1_accrej = fmri_data(fchat_s1_accrej);
    % final_data_chatroom_ses1_acc = fmri_data(fchat_s1_acc);
    % final_data_chatroom_ses1_rej = fmri_data(fchat_s1_rej);
    % %%
    % % ses-2 chatroom
    % final_data_chatroom_ses2_accrej = fmri_data(fchat_s2_accrej);
    % final_data_chatroom_ses2_acc = fmri_data(fchat_s2_acc);
    % final_data_chatroom_ses2_rej = fmri_data(fchat_s2_rej);
    % 
    % for sub = 1:length(fchat_s1_accrej)
    %     pid_chat_s1{sub} = fchat_s1_accrej{sub}(5:9);
    % end
    % 
    % for sub = 1:length(fchat_s2_accrej)
    %     pid_chat_s2{sub} = fchat_s2_accrej{sub}(5:9);
    % end
    %% save all pids to be added to tables below
    save pids.mat pid_midant_s1 pid_midout_s1 %pid_midant_s2 pid_midout_s2 %pid_chat_s1 pid_chat_s2
    %% save all MID ses1
    save final_data_midant_ses1_c1.mat final_data_midant_ses1_c1
    save final_data_midant_ses1_c2.mat final_data_midant_ses1_c2
    save final_data_midant_ses1_c3.mat final_data_midant_ses1_c3
    save final_data_midout_ses1_c1.mat final_data_midout_ses1_c1
    save final_data_midout_ses1_c2.mat final_data_midout_ses1_c2
    save final_data_midout_ses1_c3.mat final_data_midout_ses1_c3

    % %% save all MID ses2
    % save final_data_midant_ses2_c1.mat final_data_midant_ses2_c1
    % save final_data_midant_ses2_c2.mat final_data_midant_ses2_c2
    % save final_data_midant_ses2_c3.mat final_data_midant_ses2_c3
    % save final_data_midout_ses2_c1.mat final_data_midout_ses2_c1
    % save final_data_midout_ses2_c2.mat final_data_midout_ses2_c2
    % save final_data_midout_ses2_c3.mat final_data_midout_ses2_c3

    % %% save all chatroom ses1
    % save final_data_chatroom_ses1_accrej.mat final_data_chatroom_ses1_accrej
    % save final_data_chatroom_ses1_acc.mat final_data_chatroom_ses1_acc
    % save final_data_chatroom_ses1_rej.mat final_data_chatroom_ses1_rej
    % 
    % save final_data_chatroom_ses2_accrej.mat final_data_chatroom_ses2_accrej
    % save final_data_chatroom_ses2_acc.mat final_data_chatroom_ses2_acc
    % save final_data_chatroom_ses2_rej.mat final_data_chatroom_ses2_rej

else
    load(fullfile(datadir,"final_data_midant_ses1_c1.mat"))
    load(fullfile(datadir,"final_data_midant_ses1_c2.mat"))
    load(fullfile(datadir,"final_data_midant_ses1_c3.mat"))
    load(fullfile(datadir,"final_data_midout_ses1_c1.mat"))
    load(fullfile(datadir,"final_data_midout_ses1_c2.mat"))
    load(fullfile(datadir,"final_data_midout_ses1_c3.mat"))

    % load(fullfile(datadir,"final_data_midant_ses2_c1.mat"))
    % load(fullfile(datadir,"final_data_midant_ses2_c2.mat"))
    % load(fullfile(datadir,"final_data_midant_ses2_c3.mat"))
    % load(fullfile(datadir,"final_data_midout_ses2_c1.mat"))
    % load(fullfile(datadir,"final_data_midout_ses2_c2.mat"))
    % load(fullfile(datadir,"final_data_midout_ses2_c3.mat"))

    % load(fullfile(datadir,"final_data_chatroom_ses1_accrej.mat"))
    % load(fullfile(datadir,"final_data_chatroom_ses1_acc.mat"))
    % load(fullfile(datadir,"final_data_chatroom_ses1_rej.mat"))
    % load(fullfile(datadir,"final_data_chatroom_ses2_accrej.mat"))
    % load(fullfile(datadir,"final_data_chatroom_ses2_acc.mat"))
    % load(fullfile(datadir,"final_data_chatroom_ses2_rej.mat"))

    load(fullfile(datadir,"pids.mat"));

%     load(fullfile(fldir,"final_data_chatroom2_ses1_accrej.mat"))
%     load(fullfile(fldir,"final_data_chatroom2_ses2_accrej.mat"))
%     load(fullfile(fldir,"final_data_chatroom2_ses1_acc.mat"))
%     load(fullfile(fldir,"final_data_chatroom2_ses2_acc.mat"))
%     load(fullfile(fldir,"final_data_chatroom2_ses1_rej.mat"))
%     load(fullfile(fldir,"final_data_chatroom2_ses2_rej.mat"))
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

% thresh_midant_ses2_c1 = threshold(stat_midant_ses2_c1.t,0.05,'fdr','k',10);
% thresh_midant_ses2_c2 = threshold(stat_midant_ses2_c2.t,0.05,'fdr','k',10);
% thresh_midant_ses2_c3 = threshold(stat_midant_ses2_c3.t,0.05,'fdr','k',10);
% thresh_midout_ses2_c1 = threshold(stat_midout_ses2_c1.t,0.05,'fdr','k',10);
% thresh_midout_ses2_c2 = threshold(stat_midout_ses2_c2.t,0.05,'fdr','k',10);
% thresh_midout_ses2_c3 = threshold(stat_midout_ses2_c3.t,0.05,'fdr','k',10);

% %% whole brain for chatroom
% 
% final_data_chatroom_ses1_accrej.X = ones(size(final_data_chatroom_ses1_accrej.dat,2),1);
% final_data_chatroom_ses2_accrej.X = ones(size(final_data_chatroom_ses2_accrej.dat,2),1);
% final_data_chatroom_ses1_acc.X = ones(size(final_data_chatroom_ses1_acc.dat,2),1);
% final_data_chatroom_ses2_acc.X = ones(size(final_data_chatroom_ses2_acc.dat,2),1);
% final_data_chatroom_ses1_rej.X = ones(size(final_data_chatroom_ses1_rej.dat,2),1);
% final_data_chatroom_ses2_rej.X = ones(size(final_data_chatroom_ses2_rej.dat,2),1);
% 
% stat_chatroom_ses1_accrej = regress(final_data_chatroom_ses1_accrej);
% stat_chatroom_ses2_accrej = regress(final_data_chatroom_ses2_accrej);
% stat_chatroom_ses1_acc = regress(final_data_chatroom_ses1_acc);
% stat_chatroom_ses2_acc = regress(final_data_chatroom_ses2_acc);
% stat_chatroom_ses1_rej = regress(final_data_chatroom_ses1_rej);
% stat_chatroom_ses2_rej = regress(final_data_chatroom_ses2_rej);
% 
% 
% thresh_chatroom_ses1_accrej = threshold(stat_chatroom_ses1_accrej.t,0.05,'fdr','k',10);
% thresh_chatroom_ses2_accrej = threshold(stat_chatroom_ses2_accrej.t,0.05,'fdr','k',10);
% thresh_chatroom_ses1_acc = threshold(stat_chatroom_ses1_acc.t,0.05,'fdr','k',10);
% thresh_chatroom_ses2_acc = threshold(stat_chatroom_ses2_acc.t,0.05,'fdr','k',10);
% thresh_chatroom_ses1_rej = threshold(stat_chatroom_ses1_rej.t,0.05,'fdr','k',10);
% thresh_chatroom_ses2_rej = threshold(stat_chatroom_ses2_rej.t,0.05,'fdr','k',10);

%%
redo_regions = 0;

if redo_regions == 1
% 
%     % chatroom accrej ses1
%     T_chats1accrej = [];
%     names = [];
%     all_regions = filenames(fullfile('/Users/ninakougan/Documents/acnl/rise_crest/progress_reports/roi/*.nii'));
%     for r = 1:length(all_regions)
%         [filepath,name,ext] = fileparts(all_regions{r});
%         roi = fmri_data(all_regions{r});
%         temp_region = extract_roi_averages(final_data_chatroom_ses1_accrej,roi);
%         T_chats1accrej = [T_chats1accrej,temp_region.dat];
%         names{r} = name; 
%     end
%     T_chats1accrej=array2table(T_chats1accrej);
%     T_chats1accrej.Properties.VariableNames = names;
%     T_chats1accrej = [cell2table(pid_chat_s1'), T_chats1accrej];
%     T_chats1accrej.Properties.VariableNames{1} = 'PID';
%     save T_chats1accrej.mat T_chats1accrej
% 
%     % chatroom acc ses1
%     T_chats1acc = [];
%     names = [];
%     all_regions = filenames(fullfile('/Users/ninakougan/Documents/acnl/rise_crest/progress_reports/roi/*.nii'));
%     for r = 1:length(all_regions)
%         [filepath,name,ext] = fileparts(all_regions{r});
%         roi = fmri_data(all_regions{r});
%         temp_region = extract_roi_averages(final_data_chatroom_ses1_acc,roi);
%         T_chats1acc = [T_chats1acc,temp_region.dat];
%         names{r} = name; 
%     end
%     T_chats1acc=array2table(T_chats1acc);
%     T_chats1acc.Properties.VariableNames = names;
%     T_chats1acc = [cell2table(pid_chat_s1'), T_chats1acc];
%     T_chats1acc.Properties.VariableNames{1} = 'PID';
%     save T_chats1acc.mat T_chats1acc
% 
%     % chatroom rej ses1
%     T_chats1rej = [];
%     names = [];
%     all_regions = filenames(fullfile('/Users/ninakougan/Documents/acnl/rise_crest/progress_reports/roi/*.nii'));
%     for r = 1:length(all_regions)
%         [filepath,name,ext] = fileparts(all_regions{r});
%         roi = fmri_data(all_regions{r});
%         temp_region = extract_roi_averages(final_data_chatroom_ses1_rej,roi);
%         T_chats1rej = [T_chats1rej,temp_region.dat];
%         names{r} = name; 
%     end
%     T_chats1rej=array2table(T_chats1rej);
%     T_chats1rej.Properties.VariableNames = names;
%     T_chats1rej = [cell2table(pid_chat_s1'), T_chats1rej];
%     T_chats1rej.Properties.VariableNames{1} = 'PID';
%     save T_chats1rej.mat T_chats1rej
%     %%
%     % chatroom accrej ses2
%     T_chats2accrej = [];
%     names = [];
%     all_regions = filenames(fullfile('/Users/ninakougan/Documents/acnl/rise_crest/progress_reports/roi/*.nii'));
%     for r = 1:length(all_regions)
%         [filepath,name,ext] = fileparts(all_regions{r});
%         roi = fmri_data(all_regions{r});
%         temp_region = extract_roi_averages(final_data_chatroom_ses2_accrej,roi);
%         T_chats2accrej = [T_chats2accrej,temp_region.dat];
%         names{r} = name; 
%     end
%     T_chats2accrej=array2table(T_chats2accrej);
%     T_chats2accrej.Properties.VariableNames = names;
%     T_chats2accrej = [cell2table(pid_chat_s2'), T_chats2accrej];
%     T_chats2accrej.Properties.VariableNames{1} = 'PID';
%     save T_chats2accrej.mat T_chats2accrej
% 
%     % chatroom acc ses2
%     T_chats2acc = [];
%     names = [];
%     all_regions = filenames(fullfile('/Users/ninakougan/Documents/acnl/rise_crest/progress_reports/roi/*.nii'));
%     for r = 1:length(all_regions)
%         [filepath,name,ext] = fileparts(all_regions{r});
%         roi = fmri_data(all_regions{r});
%         temp_region = extract_roi_averages(final_data_chatroom_ses2_acc,roi);
%         T_chats2acc = [T_chats2acc,temp_region.dat];
%         names{r} = name; 
%     end
%     T_chats2acc=array2table(T_chats2acc);
%     T_chats2acc.Properties.VariableNames = names;
%     T_chats2acc = [cell2table(pid_chat_s2'), T_chats2acc];
%     T_chats2acc.Properties.VariableNames{1} = 'PID';
%     save T_chats2acc.mat T_chats2acc
% 
%     % chatroom rej ses2
%     T_chats2rej = [];
%     names = [];
%     all_regions = filenames(fullfile('/Users/ninakougan/Documents/acnl/rise_crest/progress_reports/roi/*.nii'));
%     for r = 1:length(all_regions)
%         [filepath,name,ext] = fileparts(all_regions{r});
%         roi = fmri_data(all_regions{r});
%         temp_region = extract_roi_averages(final_data_chatroom_ses2_rej,roi);
%         T_chats2rej = [T_chats2rej,temp_region.dat];
%         names{r} = name; 
%     end
%     T_chats2rej=array2table(T_chats2rej);
%     T_chats2rej.Properties.VariableNames = names;
%     T_chats2rej = [cell2table(pid_chat_s2'), T_chats2rej];
%     T_chats2rej.Properties.VariableNames{1} = 'PID';
%     save T_chats2rej.mat T_chats2rej
%     %%
    % mid ant ses1 c1
    T_midants1_c1 = [];
    names = [];
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
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
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
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
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
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
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
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
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
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
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
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

%%
    % % mid ant ses2 c1
    % T_midants2_c1 = [];
    % names = [];
    % all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    % for r = 1:length(all_regions)
    %     [filepath,name,ext] = fileparts(all_regions{r});
    %     roi = fmri_data(all_regions{r});
    %     temp_region = extract_roi_averages(final_data_midant_ses2_c1,roi);
    %     T_midants2_c1 = [T_midants2_c1,temp_region.dat];
    %     names{r} = name; 
    % end
    % T_midants2_c1=array2table(T_midants2_c1);
    % T_midants2_c1.Properties.VariableNames = names;
    % T_midants2_c1 = [cell2table(pid_midant_s2'), T_midants2_c1];
    % T_midants2_c1.Properties.VariableNames{1} = 'PID';
    % save T_midants2_c1.mat T_midants2_c1
    % 
    % % mid ant ses2 c2
    % T_midants2_c2 = [];
    % names = [];
    % all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    % for r = 1:length(all_regions)
    %     [filepath,name,ext] = fileparts(all_regions{r});
    %     roi = fmri_data(all_regions{r});
    %     temp_region = extract_roi_averages(final_data_midant_ses2_c2,roi);
    %     T_midants2_c2 = [T_midants2_c2,temp_region.dat];
    %     names{r} = name; 
    % end
    % T_midants2_c2=array2table(T_midants2_c2);
    % T_midants2_c2.Properties.VariableNames = names;
    % T_midants2_c2 = [cell2table(pid_midant_s2'), T_midants2_c2];
    % T_midants2_c2.Properties.VariableNames{1} = 'PID';
    % save T_midants2_c2.mat T_midants2_c2
    % 
    % % mid ant ses2 c3
    % T_midants2_c3 = [];
    % names = [];
    % all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    % for r = 1:length(all_regions)
    %     [filepath,name,ext] = fileparts(all_regions{r});
    %     roi = fmri_data(all_regions{r});
    %     temp_region = extract_roi_averages(final_data_midant_ses2_c3,roi);
    %     T_midants2_c3 = [T_midants2_c3,temp_region.dat];
    %     names{r} = name; 
    % end
    % T_midants2_c3=array2table(T_midants2_c3);
    % T_midants2_c3.Properties.VariableNames = names;
    % pid_midant_s2 = pid_midant_s2(~cellfun('isempty',pid_midant_s2));
    % T_midants2_c3 = [cell2table(pid_midant_s2'), T_midants2_c3];
    % T_midants2_c3.Properties.VariableNames{1} = 'PID';
    % save T_midants2_c3.mat T_midants2_c3
    % 
    % % mid out ses2 c1
    % T_midouts2_c1 = [];
    % names = [];
    % all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    % for r = 1:length(all_regions)
    %     [filepath,name,ext] = fileparts(all_regions{r});
    %     roi = fmri_data(all_regions{r});
    %     temp_region = extract_roi_averages(final_data_midout_ses2_c1,roi);
    %     T_midouts2_c1 = [T_midouts2_c1,temp_region.dat];
    %     names{r} = name; 
    % end
    % T_midouts2_c1=array2table(T_midouts2_c1);
    % T_midouts2_c1.Properties.VariableNames = names;
    % pid_midout_s2 = pid_midout_s2(~cellfun('isempty',pid_midout_s2));
    % T_midouts2_c1 = [cell2table(pid_midout_s2'), T_midouts2_c1];
    % T_midouts2_c1.Properties.VariableNames{1} = 'PID';
    % save T_midouts2_c1.mat T_midouts2_c1
    % 
    % % mid out ses2 c2
    % T_midouts2_c2 = [];
    % names = [];
    % all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    % for r = 1:length(all_regions)
    %     [filepath,name,ext] = fileparts(all_regions{r});
    %     roi = fmri_data(all_regions{r});
    %     temp_region = extract_roi_averages(final_data_midout_ses2_c2,roi);
    %     T_midouts2_c2 = [T_midouts2_c2,temp_region.dat];
    %     names{r} = name; 
    % end
    % T_midouts2_c2=array2table(T_midouts2_c2);
    % T_midouts2_c2.Properties.VariableNames = names;
    % pid_midout_s2 = pid_midout_s2(~cellfun('isempty',pid_midout_s2));
    % T_midouts2_c2 = [cell2table(pid_midout_s2'), T_midouts2_c2];
    % T_midouts2_c2.Properties.VariableNames{1} = 'PID';
    % save T_midouts2_c2.mat T_midouts2_c2
    % 
    % % mid out ses2 c3
    % T_midouts2_c3 = [];
    % names = [];
    % all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    % for r = 1:length(all_regions)
    %     [filepath,name,ext] = fileparts(all_regions{r});
    %     roi = fmri_data(all_regions{r});
    %     temp_region = extract_roi_averages(final_data_midout_ses2_c3,roi);
    %     T_midouts2_c3 = [T_midouts2_c3,temp_region.dat];
    %     names{r} = name; 
    % end
    % T_midouts2_c3=array2table(T_midouts2_c3);
    % T_midouts2_c3.Properties.VariableNames = names;
    % pid_midout_s2 = pid_midout_s2(~cellfun('isempty',pid_midout_s2));
    % T_midouts2_c3 = [cell2table(pid_midout_s2'), T_midouts2_c3];
    % T_midouts2_c3.Properties.VariableNames{1} = 'PID';
    % save T_midouts2_c3.mat T_midouts2_c3

    % AAL3 atlas for all
    clear names
    atl = fmri_data('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/aal3/AAL3v1.nii');
    labels = readtable('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/aal3/AAL3v1.nii.txt');
    labels(isnan(labels.Var3),:) = [];

    % aal_chat_accrej_s1 = extract_roi_averages(final_data_chatroom_ses1_accrej,atl);
    % aal_chat_acc_s1 = extract_roi_averages(final_data_chatroom_ses1_acc,atl);
    % aal_chat_rej_s1 = extract_roi_averages(final_data_chatroom_ses1_rej,atl);
    % aal_chat_accrej_s2 = extract_roi_averages(final_data_chatroom_ses2_accrej,atl);
    % aal_chat_acc_s2 = extract_roi_averages(final_data_chatroom_ses2_acc,atl);
    % aal_chat_rej_s2 = extract_roi_averages(final_data_chatroom_ses2_rej,atl);

    aal_mid_ant_s1_c1 = extract_roi_averages(final_data_midant_ses1_c1,atl);
    aal_mid_ant_s1_c2 = extract_roi_averages(final_data_midant_ses1_c2,atl);
    aal_mid_ant_s1_c3 = extract_roi_averages(final_data_midant_ses1_c3,atl);
    aal_mid_out_s1_c1 = extract_roi_averages(final_data_midout_ses1_c1,atl);
    aal_mid_out_s1_c2 = extract_roi_averages(final_data_midout_ses1_c2,atl);
    aal_mid_out_s1_c3 = extract_roi_averages(final_data_midout_ses1_c3,atl);

    % aal_mid_ant_s2_c1 = extract_roi_averages(final_data_midant_ses2_c1,atl);
    % aal_mid_ant_s2_c2 = extract_roi_averages(final_data_midant_ses2_c2,atl);
    % aal_mid_ant_s2_c3 = extract_roi_averages(final_data_midant_ses2_c3,atl);
    % aal_mid_out_s2_c1 = extract_roi_averages(final_data_midout_ses2_c1,atl);
    % aal_mid_out_s2_c2 = extract_roi_averages(final_data_midout_ses2_c2,atl);
    % aal_mid_out_s2_c3 = extract_roi_averages(final_data_midout_ses2_c3,atl);
    

    for i = 1:length(labels.Var2)
        % T_aal_chat_accrej_s1(:,i) = aal_chat_accrej_s1(i).dat;
        % T_aal_chat_acc_s1(:,i) = aal_chat_acc_s1(i).dat;
        % T_aal_chat_rej_s1(:,i) = aal_chat_rej_s1(i).dat;
        % T_aal_chat_accrej_s2(:,i) = aal_chat_accrej_s2(i).dat;
        % T_aal_chat_acc_s2(:,i) = aal_chat_acc_s2(i).dat;
        % T_aal_chat_rej_s2(:,i) = aal_chat_rej_s2(i).dat;

        T_aal_mid_ant_s1_c1(:,i) = aal_mid_ant_s1_c1(i).dat;
        T_aal_mid_ant_s1_c2(:,i) = aal_mid_ant_s1_c2(i).dat;
        T_aal_mid_ant_s1_c3(:,i) = aal_mid_ant_s1_c3(i).dat;
        T_aal_mid_out_s1_c1(:,i) = aal_mid_out_s1_c1(i).dat;
        T_aal_mid_out_s1_c2(:,i) = aal_mid_out_s1_c2(i).dat;
        T_aal_mid_out_s1_c3(:,i) = aal_mid_out_s1_c3(i).dat;

        % T_aal_mid_ant_s2_c1(:,i) = aal_mid_ant_s2_c1(i).dat;
        % T_aal_mid_ant_s2_c2(:,i) = aal_mid_ant_s2_c2(i).dat;
        % T_aal_mid_ant_s2_c3(:,i) = aal_mid_ant_s2_c3(i).dat;
        % T_aal_mid_out_s2_c1(:,i) = aal_mid_out_s2_c1(i).dat;
        % T_aal_mid_out_s2_c2(:,i) = aal_mid_out_s2_c2(i).dat;
        % T_aal_mid_out_s2_c3(:,i) = aal_mid_out_s2_c3(i).dat;

        names{i} = labels.Var2{i};
    end
    
    % T_aal_chat_accrej_s1 = array2table(T_aal_chat_accrej_s1);
    % T_aal_chat_accrej_s1.Properties.VariableNames = names;
    % T_aal_chat_accrej_s1 = [cell2table(pid_chat_s1'), T_aal_chat_accrej_s1];
    % T_aal_chat_accrej_s1.Properties.VariableNames{1} = 'PID';
    % 
    % T_aal_chat_acc_s1 = array2table(T_aal_chat_acc_s1);
    % T_aal_chat_acc_s1.Properties.VariableNames = names;
    % T_aal_chat_acc_s1 = [cell2table(pid_chat_s1'), T_aal_chat_acc_s1];
    % T_aal_chat_acc_s1.Properties.VariableNames{1} = 'PID';
    % 
    % T_aal_chat_rej_s1 = array2table(T_aal_chat_rej_s1);
    % T_aal_chat_rej_s1.Properties.VariableNames = names;
    % T_aal_chat_rej_s1 = [cell2table(pid_chat_s1'), T_aal_chat_rej_s1];
    % T_aal_chat_rej_s1.Properties.VariableNames{1} = 'PID';
    % 
    % T_aal_chat_accrej_s2 = array2table(T_aal_chat_accrej_s2);
    % T_aal_chat_accrej_s2.Properties.VariableNames = names;
    % T_aal_chat_accrej_s2 = [cell2table(pid_chat_s2'), T_aal_chat_accrej_s2];
    % T_aal_chat_accrej_s2.Properties.VariableNames{1} = 'PID';
    % 
    % T_aal_chat_acc_s2 = array2table(T_aal_chat_acc_s2);
    % T_aal_chat_acc_s2.Properties.VariableNames = names;
    % T_aal_chat_acc_s2 = [cell2table(pid_chat_s2'), T_aal_chat_acc_s2];
    % T_aal_chat_acc_s2.Properties.VariableNames{1} = 'PID';
    % 
    % T_aal_chat_rej_s2 = array2table(T_aal_chat_rej_s2);
    % T_aal_chat_rej_s2.Properties.VariableNames = names;
    % T_aal_chat_rej_s2 = [cell2table(pid_chat_s2'), T_aal_chat_rej_s2];
    % T_aal_chat_rej_s2.Properties.VariableNames{1} = 'PID';

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
    
    % T_aal_mid_ant_s2_c1 = array2table(T_aal_mid_ant_s2_c1);
    % T_aal_mid_ant_s2_c1.Properties.VariableNames = names;
    % T_aal_mid_ant_s2_c1 = [cell2table(pid_midant_s2'),T_aal_mid_ant_s2_c1];
    % T_aal_mid_ant_s2_c1.Properties.VariableNames{1} = 'PID';
    % 
    % T_aal_mid_ant_s2_c2 = array2table(T_aal_mid_ant_s2_c2);
    % T_aal_mid_ant_s2_c2.Properties.VariableNames = names;
    % T_aal_mid_ant_s2_c2 = [cell2table(pid_midant_s2'),T_aal_mid_ant_s2_c2];
    % T_aal_mid_ant_s2_c2.Properties.VariableNames{1} = 'PID';
    % 
    % T_aal_mid_ant_s2_c3 = array2table(T_aal_mid_ant_s2_c3);
    % T_aal_mid_ant_s2_c3.Properties.VariableNames = names;
    % T_aal_mid_ant_s2_c3 = [cell2table(pid_midant_s2'),T_aal_mid_ant_s2_c3];
    % T_aal_mid_ant_s2_c3.Properties.VariableNames{1} = 'PID';
    % 
    % T_aal_mid_out_s2_c1 = array2table(T_aal_mid_out_s2_c1);
    % T_aal_mid_out_s2_c1.Properties.VariableNames = names;
    % T_aal_mid_out_s2_c1 = [cell2table(pid_midout_s2'),T_aal_mid_out_s2_c1];
    % T_aal_mid_out_s2_c1.Properties.VariableNames{1} = 'PID';
    % 
    % T_aal_mid_out_s2_c2 = array2table(T_aal_mid_out_s2_c2);
    % T_aal_mid_out_s2_c2.Properties.VariableNames = names;
    % T_aal_mid_out_s2_c2 = [cell2table(pid_midout_s2'),T_aal_mid_out_s2_c2];
    % T_aal_mid_out_s2_c2.Properties.VariableNames{1} = 'PID';
    % 
    % T_aal_mid_out_s2_c3 = array2table(T_aal_mid_out_s2_c3);
    % T_aal_mid_out_s2_c3.Properties.VariableNames = names;
    % T_aal_mid_out_s2_c3 = [cell2table(pid_midout_s2'),T_aal_mid_out_s2_c3];
    % T_aal_mid_out_s2_c3.Properties.VariableNames{1} = 'PID';

    % save T_aal_chat_accrej_s1.mat T_aal_chat_accrej_s1
    % save T_aal_chat_accrej_s2.mat T_aal_chat_accrej_s2
    % save T_aal_chat_acc_s1.mat T_aal_chat_acc_s1
    % 
    % save T_aal_chat_acc_s2.mat T_aal_chat_acc_s2
    % save T_aal_chat_rej_s1.mat T_aal_chat_rej_s1
    % save T_aal_chat_rej_s2.mat T_aal_chat_rej_s2

    save T_aal_mid_ant_s1_c1.mat T_aal_mid_ant_s1_c1
    save T_aal_mid_ant_s1_c2.mat T_aal_mid_ant_s1_c2
    save T_aal_mid_ant_s1_c3.mat T_aal_mid_ant_s1_c3

    save T_aal_mid_out_s1_c1.mat T_aal_mid_out_s1_c1
    save T_aal_mid_out_s1_c2.mat T_aal_mid_out_s1_c2
    save T_aal_mid_out_s1_c3.mat T_aal_mid_out_s1_c3

    %save T_aal_mid_ant_s2_c1.mat T_aal_mid_ant_s2_c1
    %save T_aal_mid_ant_s2_c2.mat T_aal_mid_ant_s2_c2
    %save T_aal_mid_ant_s2_c3.mat T_aal_mid_ant_s2_c3

    %save T_aal_mid_out_s2_c1.mat T_aal_mid_out_s2_c1
    %save T_aal_mid_out_s2_c2.mat T_aal_mid_out_s2_c2
    %save T_aal_mid_out_s2_c3.mat T_aal_mid_out_s2_c3

end

%%write out to csvs

% writetable(T_aal_chat_acc_s1, 'AAL_chat_acc_s1.txt', 'Delimiter','\t');
% writetable(T_aal_chat_acc_s2, 'AAL_chat_acc_s2.txt', 'Delimiter','\t');
% writetable(T_aal_chat_rej_s1, 'AAL_chat_rej_s1.txt', 'Delimiter','\t');
% writetable(T_aal_chat_rej_s2, 'AAL_chat_rej_s2.txt', 'Delimiter','\t');
% writetable(T_aal_chat_accrej_s1, 'AAL_chat_accrej_s1.txt', 'Delimiter','\t');
% writetable(T_aal_chat_accrej_s2, 'AAL_chat_accrej_s2.txt', 'Delimiter','\t');
% 
% writetable(T_chats1acc, 'chat_acc_s1.txt', 'Delimiter','\t');
% writetable(T_chats2acc, 'chat_acc_s2.txt', 'Delimiter','\t');
% writetable(T_chats1rej, 'chat_rej_s1.txt', 'Delimiter','\t');
% writetable(T_chats2rej, 'chat_rej_s2.txt', 'Delimiter','\t');
% writetable(T_chats1accrej, 'chat_accrej_s1.txt', 'Delimiter','\t');
% writetable(T_chats2accrej, 'chat_accrej_s2.txt', 'Delimiter','\t');

writetable(T_aal_mid_ant_s1_c1, 'AAL_MID_ant_S1C1.txt', 'Delimiter','\t');
writetable(T_aal_mid_ant_s1_c2, 'AAL_MID_ant_S1C2.txt', 'Delimiter','\t');
writetable(T_aal_mid_ant_s1_c3, 'AAL_MID_ant_S1C3.txt', 'Delimiter','\t');
%writetable(T_aal_mid_ant_s2_c1, 'AAL_MID_ant_S2C1.txt', 'Delimiter','\t');
%writetable(T_aal_mid_ant_s2_c2, 'AAL_MID_ant_S2C2.txt', 'Delimiter','\t');
%writetable(T_aal_mid_ant_s2_c3, 'AAL_MID_ant_S2C3.txt', 'Delimiter','\t');

writetable(T_aal_mid_out_s1_c1, 'AAL_MID_out_S1C1.txt', 'Delimiter','\t');
writetable(T_aal_mid_out_s1_c2, 'AAL_MID_out_S1C2.txt', 'Delimiter','\t');
writetable(T_aal_mid_out_s1_c3, 'AAL_MID_out_S1C3.txt', 'Delimiter','\t');
%writetable(T_aal_mid_out_s2_c1, 'AAL_MID_out_S2C1.txt', 'Delimiter','\t');
%writetable(T_aal_mid_out_s2_c2, 'AAL_MID_out_S2C2.txt', 'Delimiter','\t');
%writetable(T_aal_mid_out_s2_c3, 'AAL_MID_out_S2C3.txt', 'Delimiter','\t');

writetable(T_midants1_c1, 'MID_ant_S1C1.txt', 'Delimiter','\t');
writetable(T_midants1_c2, 'MID_ant_S1C2.txt', 'Delimiter','\t');
writetable(T_midants1_c3, 'MID_ant_S1C3.txt', 'Delimiter','\t');
%writetable(T_midants2_c1, 'MID_ant_S2C1.txt', 'Delimiter','\t');
%writetable(T_midants2_c2, 'MID_ant_S2C2.txt', 'Delimiter','\t');
%writetable(T_midants2_c3, 'MID_ant_S2C3.txt', 'Delimiter','\t');

writetable(T_midouts1_c1, 'MID_out_S1C1.txt', 'Delimiter','\t');
writetable(T_midouts1_c2, 'MID_out_S1C2.txt', 'Delimiter','\t');
writetable(T_midouts1_c3, 'MID_out_S1C3.txt', 'Delimiter','\t');
%writetable(T_midouts2_c1, 'MID_out_S2C1.txt', 'Delimiter','\t');
%writetable(T_midouts2_c2, 'MID_out_S2C2.txt', 'Delimiter','\t');
%writetable(T_midouts2_c3, 'MID_out_S2C3.txt', 'Delimiter','\t');