basedir = '/projects/b1108/studies/rise/data/processed/neuroimaging/fmriprep/ses-1/raw_counfounds/';
savedir = '/projects/b1108/studies/rise/data/processed/neuroimaging/fmriprep/ses-1/spm_confounds/';

fnames = filenames(fullfile(strcat(basedir,'sub*ses-1*chatroom*run-01*txt')));
%keyboard
ndummies = 0;
ex1 = 33;
for sub = 1:length(fnames)
    T = readtable(fnames{sub}, 'Delimiter', '\t');
    
    pid =  fnames{sub}(92:96);
    outliers = table2array(T(:,contains(T.Properties.VariableNames,'motion')));
    transx = table2array(T(:,contains(T.Properties.VariableNames,'trans_x')));
    transy = table2array(T(:,contains(T.Properties.VariableNames,'trans_y')));
    transz = table2array(T(:,contains(T.Properties.VariableNames,'trans_z')));
    rotx = table2array(T(:,contains(T.Properties.VariableNames,'rot_x'))); %pitch
    roty = table2array(T(:,contains(T.Properties.VariableNames,'rot_y'))); %roll
    rotz = table2array(T(:,contains(T.Properties.VariableNames,'rot_z'))); %yaw
    gs = table2array(T(:,contains(T.Properties.VariableNames,'global_signal')));
    %csf = T.csf;
    %wm = T.white_matter;
    fd(sub) = nanmean(T.framewise_displacement);

    R = [transx(:,1:2),transy(:,1:2),transz(:,1:2),rotx(:,1:2),roty(:,1:2),rotz(:,1:2),gs(:,1:2),outliers]; %change for incl derivatives, check w break first
   %keyboard
    R(isnan(R)) = 0;
    R = R(ndummies+1:size(R,1),:);

    if nanmean(T.framewise_displacement) > 0.5 
        pid_exclude_list{ex1,1} = pid;
        pid_exclude_list{ex1,2} = 'ses-1_chatroom_run-01';
        ex1 = ex1 + 1;
    end

    save_name = fullfile(savedir,strcat('sub-',pid,'_ses-1_chatroom_run-01.mat'));
    save(save_name,"R")
end