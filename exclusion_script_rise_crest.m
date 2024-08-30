% define directories where your .tsv files are. Matlab does not like tsv
% extension so it may be necessary to rename the files to a txt extension. 

basedir = '/Users/zacharyanderson/Desktop/confounds_for_all_sessions/';
studydir = 'rise'; % rise crest
studytask = 'mid'; % chatroom mid

% assign a variable to contain all filenames. I'm using the 'filenames'
% command that comes with Tor's tools. There are other ways to do wildcards
% in matlab that you can use if needed
cd(fullfile(basedir,studydir,studytask))
fnames = filenames(fullfile('*.txt'));

% need to grab the subject ID, the session, and the task

if strcmp(studydir, 'rise')
    for sub = 1:length(fnames)
        % load in the file
        txt = readtable(fnames{sub});
        
        % pull out relevant information for identification
        PID{sub,1} = fnames{sub}(5:9);
        session{sub,1} = fnames{sub}(15);
        task{sub,1} = studytask(1:length(studytask));
        if strcmp(studytask,'mid')
            run{sub,1} = fnames{sub}(31);
        elseif strcmp(studytask,'chatroom')
            run{sub,1} = fnames{sub}(36);
        end

        % motion related information. FD and percent spikes. Note that
        % motion estimates like FD are NaN for the first TR because it
        % involves the derivative variables which cannot be calculated at
        % the first measurement
        FD(sub,1) = nanmean(txt.framewise_displacement);
        spike_percentage(sub,1) = sum(sum(table2array(txt(:,contains(txt.Properties.VariableNames,'motion')))))./size(txt,1);
    end
elseif strcmp(studydir,'crest')
    for sub = 1:length(fnames)
        % load in the file
        txt = readtable(fnames{sub});
        
        % pull out relevant information for identification
        PID{sub,1} = fnames{sub}(5:10);
        session{sub,1} = fnames{sub}(16);
        task{sub,1} = studytask(1:length(studytask));
        if strcmp(studytask,'mid')
            run{sub,1} = fnames{sub}(32);
        elseif strcmp(studytask,'chatroom')
            run{sub,1} = fnames{sub}(37);
        end

        % motion related information. FD and percent spikes. Note that
        % motion estimates like FD are NaN for the first TR because it
        % involves the derivative variables which cannot be calculated at
        % the first measurement
        FD(sub,1) = nanmean(txt.framewise_displacement);
        spike_percentage(sub,1) = sum(sum(table2array(txt(:,contains(txt.Properties.VariableNames,'motion')))))./size(txt,1);
    end
end

% create some arrays of zeros. I'm going to tag certain frames given
% particular degrees of motion.
exclude_FD1 = zeros(length(fnames),1);exclude_FD2 = zeros(length(fnames),1);exclude_FD3 = zeros(length(fnames),1);
exclude_FD4 = zeros(length(fnames),1);exclude_FD5 = zeros(length(fnames),1);exclude_FD6 = zeros(length(fnames),1);

% FD related exclusions: 0.2 0.3 0.5

exclude_FD1(FD>0.2) = 1;
exclude_FD2(FD>0.3) = 1;
exclude_FD3(FD>0.5) = 1;

% based on percentage of frames that are unusable: 10%, 20%, 30%

exclude_FD4(spike_percentage>0.1) = 1;
exclude_FD5(spike_percentage>0.2) = 1;
exclude_FD6(spike_percentage>0.3) = 1;

% now create a final table that contains the different exclusionary types

final = [cell2table(PID),cell2table(session),cell2table(task),cell2table(run),...
    array2table([exclude_FD1,exclude_FD2,exclude_FD3,...
    exclude_FD4,exclude_FD5,exclude_FD6])];

final.Properties.VariableNames{5} = 'FD>0.2';
final.Properties.VariableNames{6} = 'FD>0.3';
final.Properties.VariableNames{7} = 'FD>0.5';

final.Properties.VariableNames{8} = 'spike_percentage>10%';
final.Properties.VariableNames{9} = 'spike_percentage>20%';
final.Properties.VariableNames{10} = 'spike_percentage>30%';

temp_fname = fullfile(basedir,strcat(studydir,'_',studytask,'_exclusions.txt'));

writetable(final,temp_fname)

