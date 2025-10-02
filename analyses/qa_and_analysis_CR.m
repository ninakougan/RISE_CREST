fldir = '/Users/ninakougan/Documents/rise';
datadir = '/Users/ninakougan/Documents/rise';

remake_data_obj = 1;

if remake_data_obj == 1

    cd(fldir)
    fchat_s1_accrej = filenames(fullfile('sub-*/ses-1/chatroom/run-01/con_0001.nii'));
    fchat_s1_acc = filenames(fullfile('sub-*/ses-1/chatroom/run-01/con_0002.nii'));
    fchat_s1_rej = filenames(fullfile('sub-*/ses-1/chatroom/run-01/con_0003.nii'));
    
    %% apply exclusions based on 0.5mm FD
     %load('/projects/b1108/studies/rise/data/processed/neuroimaging/exclusions_based_on_motion.mat');
     %chat_exclude_s1 = pid_exclude_list(contains(pid_exclude_list(:,2),'ses-1_chat'));
     %chat_exclude_s2 = pid_exclude_list(contains(pid_exclude_list(:,2),'ses-2_chat'));
     %mid_exclude_s1 = pid_exclude_list(contains(pid_exclude_list(:,2),'ses-1_mid'));
     %mid_exclude_s2 = pid_exclude_list(contains(pid_exclude_list(:,2),'ses-1_mid'));
     
    chatroom ses1
    for ex = 1:length(chat_exclude_s1)
        fchat_s1_accrej(contains(fchat_s1_accrej(:),chat_exclude_s1{ex})) = [];
        fchat_s1_acc(contains(fchat_s1_acc(:),chat_exclude_s1{ex})) = [];
        fchat_s1_rej(contains(fchat_s1_rej(:),chat_exclude_s1{ex})) = [];
    end

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% chatroom ses-1
    final_data_chatroom_ses1_accrej = fmri_data(fchat_s1_accrej);
    final_data_chatroom_ses1_acc = fmri_data(fchat_s1_acc);
    final_data_chatroom_ses1_rej = fmri_data(fchat_s1_rej);

    for sub = 1:length(fchat_s1_accrej)
        pid_chat_s1{sub} = fchat_s1_accrej{sub}(5:9);
    end

 
    %% save all pids to be added to tables below
    save pids.mat pid_chat_s1

    %% save all chatroom ses1
    save final_data_chatroom_ses1_accrej.mat final_data_chatroom_ses1_accrej
    save final_data_chatroom_ses1_acc.mat final_data_chatroom_ses1_acc
    save final_data_chatroom_ses1_rej.mat final_data_chatroom_ses1_rej

else
    load(fullfile(datadir,"final_data_chatroom_ses1_accrej.mat"))
    load(fullfile(datadir,"final_data_chatroom_ses1_acc.mat"))
    load(fullfile(datadir,"final_data_chatroom_ses1_rej.mat"))

    load(fullfile(datadir,"pids.mat"));
end

%% whole brain for chatroom

final_data_chatroom_ses1_accrej.X = ones(size(final_data_chatroom_ses1_accrej.dat,2),1);
final_data_chatroom_ses1_acc.X = ones(size(final_data_chatroom_ses1_acc.dat,2),1);
final_data_chatroom_ses1_rej.X = ones(size(final_data_chatroom_ses1_rej.dat,2),1);

stat_chatroom_ses1_accrej = regress(final_data_chatroom_ses1_accrej);
stat_chatroom_ses1_acc = regress(final_data_chatroom_ses1_acc);
stat_chatroom_ses1_rej = regress(final_data_chatroom_ses1_rej);

thresh_chatroom_ses1_accrej = threshold(stat_chatroom_ses1_accrej.t,0.05,'fdr','k',10);
thresh_chatroom_ses1_acc = threshold(stat_chatroom_ses1_acc.t,0.05,'fdr','k',10);
thresh_chatroom_ses1_rej = threshold(stat_chatroom_ses1_rej.t,0.05,'fdr','k',10);

%%
redo_regions = 1;

if redo_regions == 1

    % chatroom accrej ses1
    T_chats1accrej = [];
    names = [];
    all_regions = filenames(fullfile('/Users/ninakougan/Documents/acnl/rise_crest/progress_reports/roi/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_chatroom_ses1_accrej,roi);
        T_chats1accrej = [T_chats1accrej,temp_region.dat];
        names{r} = name; 
    end
    T_chats1accrej=array2table(T_chats1accrej);
    T_chats1accrej.Properties.VariableNames = names;
    T_chats1accrej = [cell2table(pid_chat_s1'), T_chats1accrej];
    T_chats1accrej.Properties.VariableNames{1} = 'PID';
    save T_chats1accrej.mat T_chats1accrej

    % chatroom acc ses1
    T_chats1acc = [];
    names = [];
    all_regions = filenames(fullfile('/Users/ninakougan/Documents/acnl/rise_crest/progress_reports/roi/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_chatroom_ses1_acc,roi);
        T_chats1acc = [T_chats1acc,temp_region.dat];
        names{r} = name; 
    end
    T_chats1acc=array2table(T_chats1acc);
    T_chats1acc.Properties.VariableNames = names;
    T_chats1acc = [cell2table(pid_chat_s1'), T_chats1acc];
    T_chats1acc.Properties.VariableNames{1} = 'PID';
    save T_chats1acc.mat T_chats1acc

    % chatroom rej ses1
    T_chats1rej = [];
    names = [];
    all_regions = filenames(fullfile('/Users/ninakougan/Documents/acnl/rise_crest/progress_reports/roi/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_chatroom_ses1_rej,roi);
        T_chats1rej = [T_chats1rej,temp_region.dat];
        names{r} = name; 
    end
    T_chats1rej=array2table(T_chats1rej);
    T_chats1rej.Properties.VariableNames = names;
    T_chats1rej = [cell2table(pid_chat_s1'), T_chats1rej];
    T_chats1rej.Properties.VariableNames{1} = 'PID';
    save T_chats1rej.mat T_chats1rej
    %%
    

    % AAL3 atlas for all
    clear names
    atl = fmri_data('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/aal3/AAL3v1.nii');
    labels = readtable('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/aal3/AAL3v1.nii.txt');
    labels(isnan(labels.Var3),:) = [];

    aal_chat_accrej_s1 = extract_roi_averages(final_data_chatroom_ses1_accrej,atl);
    aal_chat_acc_s1 = extract_roi_averages(final_data_chatroom_ses1_acc,atl);
    aal_chat_rej_s1 = extract_roi_averages(final_data_chatroom_ses1_rej,atl);
   
    for i = 1:length(labels.Var2)
        T_aal_chat_accrej_s1(:,i) = aal_chat_accrej_s1(i).dat;
        T_aal_chat_acc_s1(:,i) = aal_chat_acc_s1(i).dat;
        T_aal_chat_rej_s1(:,i) = aal_chat_rej_s1(i).dat;
        names{i} = labels.Var2{i};
     end
    
    T_aal_chat_accrej_s1 = array2table(T_aal_chat_accrej_s1);
    T_aal_chat_accrej_s1.Properties.VariableNames = names;
    T_aal_chat_accrej_s1 = [cell2table(pid_chat_s1'), T_aal_chat_accrej_s1];
    T_aal_chat_accrej_s1.Properties.VariableNames{1} = 'PID';

    T_aal_chat_acc_s1 = array2table(T_aal_chat_acc_s1);
    T_aal_chat_acc_s1.Properties.VariableNames = names;
    T_aal_chat_acc_s1 = [cell2table(pid_chat_s1'), T_aal_chat_acc_s1];
    T_aal_chat_acc_s1.Properties.VariableNames{1} = 'PID';

    T_aal_chat_rej_s1 = array2table(T_aal_chat_rej_s1);
    T_aal_chat_rej_s1.Properties.VariableNames = names;
    T_aal_chat_rej_s1 = [cell2table(pid_chat_s1'), T_aal_chat_rej_s1];
    T_aal_chat_rej_s1.Properties.VariableNames{1} = 'PID';


    save T_aal_chat_accrej_s1.mat T_aal_chat_accrej_s1
    save T_aal_chat_acc_s1.mat T_aal_chat_acc_s1
    save T_aal_chat_rej_s1.mat T_aal_chat_rej_s1
end

%write out to csvs

writetable(T_aal_chat_acc_s1, 'AAL_chat_acc_s1.txt', 'Delimiter','\t');
writetable(T_aal_chat_rej_s1, 'AAL_chat_rej_s1.txt', 'Delimiter','\t');
writetable(T_aal_chat_accrej_s1, 'AAL_chat_accrej_s1.txt', 'Delimiter','\t');

writetable(T_chats1acc, 'chat_acc_s1.txt', 'Delimiter','\t');
writetable(T_chats1rej, 'chat_rej_s1.txt', 'Delimiter','\t');
writetable(T_chats1accrej, 'chat_accrej_s1.txt', 'Delimiter','\t');