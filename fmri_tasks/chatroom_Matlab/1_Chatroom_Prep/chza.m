% RUN Chatroom (Player) Photo Selection Task
% Code by Busra Tanriverdi,
% Last updated Dec 1st, 2022
% Contact: busra.tanriverdi@temple.edu or cablab@temple.edu

%%%%% !!!!!! IMPORTANT NOTES FOR ANY PROJECT-SPECIFIC EDITS !!!!!! %%%%%
% LINE 17 --> rootDir variable below must match the folder directory. If you don't change this to the directory of your project folder, 
% the task will not work! 

% LINES 120-121 --> The experiment is currently set to be displayed at the maximum monitor number (e.g., if you have 2 monitors, the trials will be
% shown on the 2nd monitor). You can change it to minimum by commenting out the line 121, and removing the "%" sign in front of the line 120. 

%% Initialization
clear; close all; clc  
 
%% Set directories and structures
rootDir = '/Users/tum99916/Desktop/chatroom_Matlab';
addpath(genpath(fullfile(rootDir)));

dataDir = [rootDir,filesep,'data']; % data directory
prepDir = [rootDir,filesep,'1_Chatroom_Prep']; 
stimDir = [prepDir,filesep,'stimuli']; % stimulus (player images) directory  
cd(prepDir)

% Set structures for parameters & subject data
P = [];
T = [];

ListenChar; % make sure MATLAB is listening to the keyboard inputs

%% Collect subject ID, gender & session info
% 1. Subject Number
subID = inputdlg('Please enter the Subject Number:');
T.subID = str2double(subID);
if ~exist('subID','var') % if subject ID is missing, abort
    error('No subject ID entered. Try again!')
end

% 2. Session Number
sesNum = inputdlg('Please enter the Session Number:'); 
T.sesNum = str2double(sesNum);

% 3. Subject's Name
subName = inputdlg('Please enter Subject''s Name:'); 
T.subName = char(subName);

% 4. Subject's Age
subAge = inputdlg('Please enter the Subject''s Age:');
T.subAge = str2double(subAge);

% 5. Subject Sex/Gender
genderlist={'male','female'};
subGender = listdlg('PromptString','Please enter Subject''s Sex:', ...
    'SelectionMode','single','ListString',genderlist);  % gets the index for gender
T.subGender = genderlist{subGender};

% 6. Summary of info 
opts.Interpreter = 'tex'; opts.Default = 'Yes';
answer = questdlg({sprintf('Subject: %d',T.subID), ...
    sprintf('Session: %d',T.sesNum), ...
    sprintf('Name: %s',T.subName), ...
    sprintf('Age: %d',T.subAge), ...
    sprintf('Sex: %s \n',T.subGender), ...
    'Continue with the above startup info?'}, ...
    'Summary of Startup Info','Yes','No','Cancel',opts); 

% if info is incorrect, reprompt all the questions above to allow editing
if strcmp(answer, 'No')
    subID = inputdlg('Please enter the Subject Number:');
    T.subID = str2double(subID);
    if ~exist('subID','var') % if subject ID is missing, abort
        error('No subject ID entered. Try again!')
    end

    sesNum = inputdlg('Please enter the Session Number:');
    T.sesNum = str2double(sesNum);

    subName = inputdlg('Please enter Subject''s Name:');
    T.subName = char(subName);

    subAge = inputdlg('Please enter the Subject''s Age:');
    T.subAge = str2double(subAge);

    subGender = listdlg('PromptString','Please enter Subject''s Sex:', ...
        'SelectionMode','single','ListString',genderlist);  % gets the index for gender
    T.subGender = genderlist{subGender};

    opts.Interpreter = 'tex'; opts.Default = 'Yes';
    answer = questdlg({sprintf('Subject: %d',T.subID), ...
        sprintf('Session: %d',T.sesNum), ...
        sprintf('Name: %s',T.subName), ...
        sprintf('Sex: %s \n',T.subGender), ...
        'Continue with the above startup info?'}, ...
        'Summary of Startup Info','Yes','No','Cancel',opts);
end

%% Set output directory & filename for this subject
subjDir = [dataDir,filesep,num2str(T.subID)]; % subject's data directory
outputFile = [subjDir,filesep,'chza-',num2str(T.subID),'.dat']; % define output file to store results

% check if this results directory already exists
if exist(subjDir, 'dir') == 7 % if yes, check if the output file exists
    if isfile(outputFile) % if yes, decide whether to overwrite
        overwrite = questdlg({'WARNING: The data file and/or recovery file already exists:', ...
            sprintf('FILE: %s \n',outputFile), ...
            'Do you want to overwrite?'}, ...
            '','Yes','No','');
        if strcmp(overwrite, 'No') 
            error('Not overwriting. Aborting experiment now.')
        end
    end
else % otherwise, create results subdirectory for this subject
    mkdir(subjDir); 
end

%% Set Screen parameters
% open display
clear Screen % remove any previously opened screens
P.screens = Screen('Screens'); % get screen numbers
%P.screenNumber = min(P.screens); % keep the first screen if multiple exist
P.screenNumber = max(P.screens); % draw to external screen if available
Screen('Preference', 'SkipSyncTests', 1); % skip sync tests

[w, P.rect] = Screen('OpenWindow', P.screenNumber, [], []); % get screen coordinates

% set screen-related parameters
P.screen.width  = P.rect(RectRight);
P.screen.height = P.rect(RectBottom);
P.screen.xCenter = P.screen.width/2;
P.screen.yCenter = P.screen.height/2;
P.screen.leftCenter = P.screen.xCenter/2;
P.screen.rightCenter = P.screen.xCenter + P.screen.xCenter/2;
P.screen.upperCenter = P.screen.height - 3/2 * P.screen.yCenter;
P.screen.lowerCenter = P.screen.height - 1/2 * P.screen.yCenter;
P.screen.flipDuration = Screen('GetFlipInterval',w);
P.screen.white = double(WhiteIndex(w)); 
P.screen.black = double(BlackIndex(w));
P.screen.gray = double(GrayIndex(w));
P.screen.backgroundColor = [200 200 200];
P.screen.textColor = P.screen.black;
P.screen.red = [255 0 0];
P.screen.blue = [0 0 255];
P.screen.green = [10 100 10];
P.screen.invalidColor = [P.screen.white 0 0];

% open first screen; set parameters for on-screen background and font
% setup alpha blending for smoothed (anti-aliased) lines
Screen(w, 'BlendFunction', GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% fill screen with background color
Screen('FillRect', w, P.screen.backgroundColor);
Screen('Flip', w);

% set text font
Screen('TextFont', w, 'Courier New');

% set up instruction text
textFemale = ['We will now show you the pictures and profiles \n'...
    'of other participants in this study. \n\n'...
    'Please select 5 females you are INTERESTED in chatting with. \n'...
    'To select, please click the left button of your mouse. \n\n' ...
    'Press space to continue.'];

textMale = ['We will now show you the pictures and profiles \n'...
    'of other participants in this study. \n\n'...
    'Please select 5 males you are INTERESTED in chatting with. \n'...
    'To select, please click the left button of your mouse. \n\n' ...
    'Press space to continue.'];

%% Set Experimental Parameters NEEDS UPDATE
% Get Coordinates for image boxes, to mark clicks on peer images
% divide the remaining screen height to 8 to define upper and lower squares
P.peerImg.width = P.screen.width/15; % width for each peer image
P.peerImg.height = floor(P.screen.height/8); % height for each peer image

% set the location Rectinates for all 20 peer images on top, and 5 selected in lower right part of the screen
P.peerRect(1,:) = [0, 0, P.peerImg.width, P.peerImg.height];
P.peerRect(2,:) = [P.peerImg.width, 0, (2*P.peerImg.width), P.peerImg.height];
P.peerRect(3,:) = [(2*P.peerImg.width), 0, (3*P.peerImg.width), P.peerImg.height];
P.peerRect(4,:) = [(3*P.peerImg.width), 0, (4*P.peerImg.width), P.peerImg.height];
P.peerRect(5,:) = [(4*P.peerImg.width), 0, (5*P.peerImg.width), P.peerImg.height];
P.peerRect(6,:) = [(5*P.peerImg.width), 0, (6*P.peerImg.width), P.peerImg.height];
P.peerRect(7,:) = [(6*P.peerImg.width), 0, (7*P.peerImg.width), P.peerImg.height];
P.peerRect(8,:) = [(7*P.peerImg.width), 0, (8*P.peerImg.width), P.peerImg.height];
P.peerRect(9,:) = [(8*P.peerImg.width), 0, (9*P.peerImg.width), P.peerImg.height];
P.peerRect(10,:) = [(9*P.peerImg.width), 0, (10*P.peerImg.width), P.peerImg.height];
P.peerRect(11,:) = [(10*P.peerImg.width), 0, (11*P.peerImg.width), P.peerImg.height];
P.peerRect(12,:) = [(11*P.peerImg.width), 0, (12*P.peerImg.width), P.peerImg.height];
P.peerRect(13,:) = [(12*P.peerImg.width), 0, (13*P.peerImg.width), P.peerImg.height];
P.peerRect(14,:) = [(13*P.peerImg.width), 0, (14*P.peerImg.width), P.peerImg.height];
P.peerRect(15,:) = [(14*P.peerImg.width), 0, (15*P.peerImg.width), P.peerImg.height];
P.peerRect(16,:) = [0, P.peerImg.height, (P.peerImg.width), (2*P.peerImg.height)];
P.peerRect(17,:) = [(P.peerImg.width), P.peerImg.height, (2*P.peerImg.width), (2*P.peerImg.height)];
P.peerRect(18,:) = [(2*P.peerImg.width), P.peerImg.height, (3*P.peerImg.width), (2*P.peerImg.height)];
P.peerRect(19,:) = [(3*P.peerImg.width), P.peerImg.height, (4*P.peerImg.width), (2*P.peerImg.height)];
P.peerRect(20,:) = [(4*P.peerImg.width), P.peerImg.height, (5*P.peerImg.width), (2*P.peerImg.height)];
P.selectedRectFemale(1,:) = [P.screen.xCenter, P.screen.yCenter, (P.screen.xCenter + P.peerImg.width), (P.screen.yCenter + P.peerImg.height)];
P.selectedRectFemale(2,:) = [(P.screen.xCenter + P.peerImg.width), P.screen.yCenter, (P.screen.xCenter + (2*P.peerImg.width)), (P.screen.yCenter + P.peerImg.height)];
P.selectedRectFemale(3,:) = [(P.screen.xCenter + (2*P.peerImg.width)), P.screen.yCenter, (P.screen.xCenter + (3*P.peerImg.width)), (P.screen.yCenter + P.peerImg.height)];
P.selectedRectFemale(4,:) = [(P.screen.xCenter + (3*P.peerImg.width)), P.screen.yCenter, (P.screen.xCenter + (4*P.peerImg.width)), (P.screen.yCenter + P.peerImg.height)];
P.selectedRectFemale(5,:) = [(P.screen.xCenter + (4*P.peerImg.width)), P.screen.yCenter, (P.screen.xCenter + (5*P.peerImg.width)), (P.screen.yCenter + P.peerImg.height)];
P.selectedRectMale(1,:) = [0, P.screen.yCenter, P.peerImg.width, (P.screen.yCenter + P.peerImg.height)];
P.selectedRectMale(2,:) = [P.peerImg.width, P.screen.yCenter, (2*P.peerImg.width), (P.screen.yCenter + P.peerImg.height)];
P.selectedRectMale(3,:) = [(2*P.peerImg.width), P.screen.yCenter, (3*P.peerImg.width), (P.screen.yCenter + P.peerImg.height)];
P.selectedRectMale(4,:) = [(3*P.peerImg.width), P.screen.yCenter, (4*P.peerImg.width), (P.screen.yCenter + P.peerImg.height)];
P.selectedRectMale(5,:) = [(4*P.peerImg.width), P.screen.yCenter,  (5*P.peerImg.width), (P.screen.yCenter + P.peerImg.height)];

P.unselectionAreaFemale = [P.screen.xCenter, P.screen.yCenter, (P.screen.xCenter + (5*P.peerImg.width)), (P.screen.yCenter + P.peerImg.height)];
P.unselectionAreaMale = [0, P.screen.yCenter, (5*P.peerImg.width), (P.screen.yCenter + P.peerImg.height)];

% define these centers of these image boxes to display the images at center
P.peerCenter(1,:) = [P.peerImg.width/2, P.peerImg.height/2];
P.peerCenter(2,:) = [(P.peerImg.width * 3/2), P.peerImg.height/2];
P.peerCenter(3,:) = [(P.peerImg.width * 5/2), P.peerImg.height/2];
P.peerCenter(4,:) = [(P.peerImg.width * 7/2), P.peerImg.height/2];
P.peerCenter(5,:) = [(P.peerImg.width * 9/2), P.peerImg.height/2];
P.peerCenter(6,:) = [(P.peerImg.width * 11/2), P.peerImg.height/2];
P.peerCenter(7,:) = [(P.peerImg.width * 13/2), P.peerImg.height/2];
P.peerCenter(8,:) = [(P.peerImg.width * 15/2), P.peerImg.height/2];
P.peerCenter(9,:) = [(P.peerImg.width * 17/2), P.peerImg.height/2];
P.peerCenter(10,:) = [(P.peerImg.width * 19/2), P.peerImg.height/2];
P.peerCenter(11,:) = [(P.peerImg.width * 21/2), P.peerImg.height/2];
P.peerCenter(12,:) = [(P.peerImg.width * 23/2), P.peerImg.height/2];
P.peerCenter(13,:) = [(P.peerImg.width * 25/2), P.peerImg.height/2];
P.peerCenter(14,:) = [(P.peerImg.width * 27/2), P.peerImg.height/2];
P.peerCenter(15,:) = [(P.peerImg.width * 29/2), P.peerImg.height/2];
P.peerCenter(16,:) = [P.peerImg.width/2, (P.peerImg.height *3/2)];
P.peerCenter(17,:) = [(P.peerImg.width * 3/2), (P.peerImg.height * 3/2)];
P.peerCenter(18,:) = [(P.peerImg.width * 5/2), (P.peerImg.height * 3/2)];
P.peerCenter(19,:) = [(P.peerImg.width * 7/2), (P.peerImg.height * 3/2)];
P.peerCenter(20,:) = [(P.peerImg.width * 9/2), (P.peerImg.height * 3/2)];
P.selectedCenterFemale(1,:) = [(P.selectedRectFemale(1,1) + P.peerImg.width/2), (P.screen.yCenter + P.peerImg.height/2)];
P.selectedCenterFemale(2,:) = [(P.selectedRectFemale(2,1) + P.peerImg.width/2), (P.screen.yCenter + P.peerImg.height/2)];
P.selectedCenterFemale(3,:) = [(P.selectedRectFemale(3,1) + P.peerImg.width/2), (P.screen.yCenter + P.peerImg.height/2)];
P.selectedCenterFemale(4,:) = [(P.selectedRectFemale(4,1) + P.peerImg.width/2), (P.screen.yCenter + P.peerImg.height/2)];
P.selectedCenterFemale(5,:) = [(P.selectedRectFemale(5,1) + P.peerImg.width/2), (P.screen.yCenter + P.peerImg.height/2)];
P.selectedCenterMale(1,:) = [(P.selectedRectMale(1,1) + P.peerImg.width/2), (P.screen.yCenter + P.peerImg.height/2)];
P.selectedCenterMale(2,:) = [(P.selectedRectMale(2,1) + P.peerImg.width/2), (P.screen.yCenter + P.peerImg.height/2)];
P.selectedCenterMale(3,:) = [(P.selectedRectMale(3,1) + P.peerImg.width/2), (P.screen.yCenter + P.peerImg.height/2)];
P.selectedCenterMale(4,:) = [(P.selectedRectMale(4,1) + P.peerImg.width/2), (P.screen.yCenter + P.peerImg.height/2)];
P.selectedCenterMale(5,:) = [(P.selectedRectMale(5,1) + P.peerImg.width/2), (P.screen.yCenter + P.peerImg.height/2)];

% get position dimensions for the lower left corner -> for subjects to click when complete:
P.screen.posMaleComplete = [0, P.screen.yCenter, P.screen.xCenter, P.screen.height];
P.screen.posFemaleComplete = [P.screen.xCenter, P.screen.yCenter, P.screen.width, P.screen.height];
P.maleTextCenter = [(P.screen.posMaleComplete(3)-50), (P.screen.posMaleComplete(4)-50)]; 
P.femaleTextCenter = [(P.screen.posFemaleComplete(3)-50), (P.screen.posFemaleComplete(4)-50)];

% set keyboard parameters
% keyboard and keypresses
KbName('UnifyKeyNames'); % unify keyboard for different operating systems
P.key.space = KbName('space');
RestrictKeysForKbCheck([]); % no keys restricted from checking

%% Read male/female stimuli
% Note that the below coding corresponds to reading the following files
% F=importdata('chzaF.dat');
% M=importdata('chzaM.dat'); 
% randF=importdata('chzaordF.dat'); % randomized A
% randM=importdata('chzaordM.dat'); % randomized B

% NOT: If you want to keep using the old faces from the BMPSM folder, you
% should uncomment the line below (265), and comment out the lines 267-277. 
% stimDir = [prepDir,filesep,'BMPSM']; ageStimDir = stimDir; % old code when we had only one set of stimuli

% select stimuli for different age ranges! REMEMBER TO CHANGE AGE GROUPS FOR ALLOY LAB
if T.subAge >= 17 % young adults
    ageStimDir = [stimDir,filesep,'youngadults'];

elseif T.subAge <= 16 && T.subAge >= 12 % teens
    ageStimDir = [stimDir,filesep,'adolescents'];

elseif T.subAge <= 11 % children
    ageStimDir = [stimDir,filesep,'children'];  % stimuli directory

end

P.stimuli.Stimuli = dir(ageStimDir); % load the correct image directory

% Females
femaleImgs = P.stimuli.Stimuli(contains({P.stimuli.Stimuli.name}, 'F'),:);

for indConn = 1:length(femaleImgs)
    number(indConn)= indConn;
    gender{indConn} = 'female';
    baseFileName{indConn} = femaleImgs(indConn).name;
    fullFileName{indConn} = fullfile(ageStimDir, baseFileName{indConn});
    name{indConn} = femaleImgs(indConn).name(1:end-4);
end

P.stimuli.Female = table(number', gender', fullFileName', baseFileName', name');
P.stimuli.Female.Properties.VariableNames = {'number', 'gender', ...
    'fullFileName', 'baseFileName', 'name'};

clear number baseFileName fullFileName name gender;

% Males
maleImgs = femaleImgs;

for indM=1:length(contains({maleImgs.name}, 'F'))

    maleImgs(indM).name = strrep(maleImgs(indM).name,'F','M');

end

for indConn = 1:length(maleImgs)
    number(indConn)= indConn;
    gender{indConn} = 'male';
    baseFileName{indConn} = maleImgs(indConn).name;
    fullFileName{indConn} = fullfile(ageStimDir, baseFileName{indConn});
    name{indConn} = maleImgs(indConn).name(1:end-4);
end

P.stimuli.Male = table(number', gender', fullFileName', baseFileName', name');
P.stimuli.Male.Properties.VariableNames = {'number', 'gender', ...
    'fullFileName', 'baseFileName', 'name'}; 

clear number baseFileName fullFileName name gender;
 
%% Allocate gender-specific variables -conditional on gender of the subject
if strcmp(T.subGender, 'female')
    P.playerImgs = P.stimuli.Female;  % chzaF
    selectionGender = "Females";
    P.screen.posComplete = P.screen.posMaleComplete;
    P.selectedRect = P.selectedRectFemale;
    P.selectedCenter = P.selectedCenterFemale;
    P.unselectionArea = P.unselectionAreaFemale;
    P.genderTextCenter = P.femaleTextCenter;
    P.genderCountCenter = [P.genderTextCenter(1)-20, P.genderTextCenter(1)-20]; 
    instructions = textFemale;

elseif strcmp(T.subGender, 'male')
    P.playerImgs = P.stimuli.Male;  % chzaM
    selectionGender = "Males"; 
    P.screen.posComplete = P.screen.posFemaleComplete;
    P.selectedRect = P.selectedRectMale;
    P.selectedCenter = P.selectedCenterMale;
    P.unselectionArea = P.unselectionAreaMale;
    P.genderTextCenter = P.maleTextCenter;
    P.genderCountCenter = [P.genderTextCenter(1)-20, P.genderTextCenter(1)-20]; 
    instructions = textMale;

end

genderText = char(selectionGender);

%% Prepare all peer images
% first randomize order of images
P.playerImgs = P.playerImgs(randperm(height(P.playerImgs)),:); % randomize order

% create image textures for display
P.peer1Image = imread(P.playerImgs.fullFileName{1}); P.peerImgTexture(1) = Screen('MakeTexture', w, P.peer1Image);
P.peer2Image = imread(P.playerImgs.fullFileName{2}); P.peerImgTexture(2) = Screen('MakeTexture', w, P.peer2Image);
P.peer3Image = imread(P.playerImgs.fullFileName{3}); P.peerImgTexture(3) = Screen('MakeTexture', w, P.peer3Image);
P.peer4Image = imread(P.playerImgs.fullFileName{4}); P.peerImgTexture(4) = Screen('MakeTexture', w, P.peer4Image);
P.peer5Image = imread(P.playerImgs.fullFileName{5}); P.peerImgTexture(5) = Screen('MakeTexture', w, P.peer5Image);
P.peer6Image = imread(P.playerImgs.fullFileName{6}); P.peerImgTexture(6) = Screen('MakeTexture', w, P.peer6Image);
P.peer7Image = imread(P.playerImgs.fullFileName{7}); P.peerImgTexture(7) = Screen('MakeTexture', w, P.peer7Image);
P.peer8Image = imread(P.playerImgs.fullFileName{8}); P.peerImgTexture(8) = Screen('MakeTexture', w, P.peer8Image);
P.peer9Image = imread(P.playerImgs.fullFileName{9}); P.peerImgTexture(9) = Screen('MakeTexture', w, P.peer9Image);
P.peer10Image = imread(P.playerImgs.fullFileName{10}); P.peerImgTexture(10) = Screen('MakeTexture', w, P.peer10Image);
P.peer11Image = imread(P.playerImgs.fullFileName{11}); P.peerImgTexture(11) = Screen('MakeTexture', w, P.peer11Image);
P.peer12Image = imread(P.playerImgs.fullFileName{12}); P.peerImgTexture(12) = Screen('MakeTexture', w, P.peer12Image);
P.peer13Image = imread(P.playerImgs.fullFileName{13}); P.peerImgTexture(13) = Screen('MakeTexture', w, P.peer13Image);
P.peer14Image = imread(P.playerImgs.fullFileName{14}); P.peerImgTexture(14) = Screen('MakeTexture', w, P.peer14Image);
P.peer15Image = imread(P.playerImgs.fullFileName{15}); P.peerImgTexture(15) = Screen('MakeTexture', w, P.peer15Image);
P.peer16Image = imread(P.playerImgs.fullFileName{16}); P.peerImgTexture(16) = Screen('MakeTexture', w, P.peer16Image);
P.peer17Image = imread(P.playerImgs.fullFileName{17}); P.peerImgTexture(17) = Screen('MakeTexture', w, P.peer17Image);
P.peer18Image = imread(P.playerImgs.fullFileName{18}); P.peerImgTexture(18) = Screen('MakeTexture', w, P.peer18Image);
P.peer19Image = imread(P.playerImgs.fullFileName{19}); P.peerImgTexture(19) = Screen('MakeTexture', w, P.peer19Image);
P.peer20Image = imread(P.playerImgs.fullFileName{20}); P.peerImgTexture(20) = Screen('MakeTexture', w, P.peer20Image);

%% Display instructions
Screen('TextSize', w, 50);
DrawFormattedText(w, instructions, 'center', 'center', P.screen.black);
Screen('Flip', w);
RestrictKeysForKbCheck([P.key.space]); % restrict keys to spacebar only
KbStrokeWait; % wait for a keystroke (of the spacebar)
RestrictKeysForKbCheck([]); % re-enable all keys

%% Display images in the randomized order
Screen('TextSize', w, 20);
% peer 1: 
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:));  Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5,6:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(6), [], P.peerRect(6,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(6,3)-20), P.peerRect(6,2), P.peerRect(6,3), (P.peerRect(6,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5,6,7:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(6), [], P.peerRect(6,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(6,3)-20), P.peerRect(6,2), P.peerRect(6,3), (P.peerRect(6,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(7), [], P.peerRect(7,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(7,3)-20), P.peerRect(7,2), P.peerRect(7,3), (P.peerRect(7,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5,6,7,8:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(6), [], P.peerRect(6,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(6,3)-20), P.peerRect(6,2), P.peerRect(6,3), (P.peerRect(6,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(7), [], P.peerRect(7,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(7,3)-20), P.peerRect(7,2), P.peerRect(7,3), (P.peerRect(7,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(8), [], P.peerRect(8,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(8,3)-20), P.peerRect(8,2), P.peerRect(8,3), (P.peerRect(8,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5,6,7,8,9:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(6), [], P.peerRect(6,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(6,3)-20), P.peerRect(6,2), P.peerRect(6,3), (P.peerRect(6,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(7), [], P.peerRect(7,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(7,3)-20), P.peerRect(7,2), P.peerRect(7,3), (P.peerRect(7,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(8), [], P.peerRect(8,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(8,3)-20), P.peerRect(8,2), P.peerRect(8,3), (P.peerRect(8,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(9), [], P.peerRect(9,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(9,3)-20), P.peerRect(9,2), P.peerRect(9,3), (P.peerRect(9,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5,6,7,8,9,10:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(6), [], P.peerRect(6,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(6,3)-20), P.peerRect(6,2), P.peerRect(6,3), (P.peerRect(6,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(7), [], P.peerRect(7,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(7,3)-20), P.peerRect(7,2), P.peerRect(7,3), (P.peerRect(7,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(8), [], P.peerRect(8,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(8,3)-20), P.peerRect(8,2), P.peerRect(8,3), (P.peerRect(8,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(9), [], P.peerRect(9,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(9,3)-20), P.peerRect(9,2), P.peerRect(9,3), (P.peerRect(9,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(10), [], P.peerRect(10,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(10,3)-20), P.peerRect(10,2), P.peerRect(10,3), (P.peerRect(10,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5,6,7,8,9,10,11:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(6), [], P.peerRect(6,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(6,3)-20), P.peerRect(6,2), P.peerRect(6,3), (P.peerRect(6,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(7), [], P.peerRect(7,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(7,3)-20), P.peerRect(7,2), P.peerRect(7,3), (P.peerRect(7,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(8), [], P.peerRect(8,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(8,3)-20), P.peerRect(8,2), P.peerRect(8,3), (P.peerRect(8,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(9), [], P.peerRect(9,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(9,3)-20), P.peerRect(9,2), P.peerRect(9,3), (P.peerRect(9,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(10), [], P.peerRect(10,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(10,3)-20), P.peerRect(10,2), P.peerRect(10,3), (P.peerRect(10,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(11), [], P.peerRect(11,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(11,3)-20), P.peerRect(11,2), P.peerRect(11,3), (P.peerRect(11,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5,6,7,8,9,10,11,12:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(6), [], P.peerRect(6,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(6,3)-20), P.peerRect(6,2), P.peerRect(6,3), (P.peerRect(6,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(7), [], P.peerRect(7,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(7,3)-20), P.peerRect(7,2), P.peerRect(7,3), (P.peerRect(7,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(8), [], P.peerRect(8,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(8,3)-20), P.peerRect(8,2), P.peerRect(8,3), (P.peerRect(8,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(9), [], P.peerRect(9,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(9,3)-20), P.peerRect(9,2), P.peerRect(9,3), (P.peerRect(9,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(10), [], P.peerRect(10,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(10,3)-20), P.peerRect(10,2), P.peerRect(10,3), (P.peerRect(10,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(11), [], P.peerRect(11,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(11,3)-20), P.peerRect(11,2), P.peerRect(11,3), (P.peerRect(11,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(12), [], P.peerRect(12,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(12,3)-20), P.peerRect(12,2), P.peerRect(12,3), (P.peerRect(12,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5,6,7,8,9,10,11,12,13:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(6), [], P.peerRect(6,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(6,3)-20), P.peerRect(6,2), P.peerRect(6,3), (P.peerRect(6,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(7), [], P.peerRect(7,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(7,3)-20), P.peerRect(7,2), P.peerRect(7,3), (P.peerRect(7,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(8), [], P.peerRect(8,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(8,3)-20), P.peerRect(8,2), P.peerRect(8,3), (P.peerRect(8,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(9), [], P.peerRect(9,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(9,3)-20), P.peerRect(9,2), P.peerRect(9,3), (P.peerRect(9,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(10), [], P.peerRect(10,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(10,3)-20), P.peerRect(10,2), P.peerRect(10,3), (P.peerRect(10,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(11), [], P.peerRect(11,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(11,3)-20), P.peerRect(11,2), P.peerRect(11,3), (P.peerRect(11,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(12), [], P.peerRect(12,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(12,3)-20), P.peerRect(12,2), P.peerRect(12,3), (P.peerRect(12,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(13), [], P.peerRect(13,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(13,3)-20), P.peerRect(13,2), P.peerRect(13,3), (P.peerRect(13,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5,6,7,8,9,10,11,12,13,14:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(6), [], P.peerRect(6,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(6,3)-20), P.peerRect(6,2), P.peerRect(6,3), (P.peerRect(6,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(7), [], P.peerRect(7,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(7,3)-20), P.peerRect(7,2), P.peerRect(7,3), (P.peerRect(7,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(8), [], P.peerRect(8,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(8,3)-20), P.peerRect(8,2), P.peerRect(8,3), (P.peerRect(8,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(9), [], P.peerRect(9,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(9,3)-20), P.peerRect(9,2), P.peerRect(9,3), (P.peerRect(9,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(10), [], P.peerRect(10,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(10,3)-20), P.peerRect(10,2), P.peerRect(10,3), (P.peerRect(10,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(11), [], P.peerRect(11,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(11,3)-20), P.peerRect(11,2), P.peerRect(11,3), (P.peerRect(11,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(12), [], P.peerRect(12,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(12,3)-20), P.peerRect(12,2), P.peerRect(12,3), (P.peerRect(12,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(13), [], P.peerRect(13,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(13,3)-20), P.peerRect(13,2), P.peerRect(13,3), (P.peerRect(13,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(14), [], P.peerRect(14,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(14,3)-20), P.peerRect(14,2), P.peerRect(14,3), (P.peerRect(14,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(6), [], P.peerRect(6,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(6,3)-20), P.peerRect(6,2), P.peerRect(6,3), (P.peerRect(6,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(7), [], P.peerRect(7,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(7,3)-20), P.peerRect(7,2), P.peerRect(7,3), (P.peerRect(7,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(8), [], P.peerRect(8,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(8,3)-20), P.peerRect(8,2), P.peerRect(8,3), (P.peerRect(8,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(9), [], P.peerRect(9,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(9,3)-20), P.peerRect(9,2), P.peerRect(9,3), (P.peerRect(9,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(10), [], P.peerRect(10,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(10,3)-20), P.peerRect(10,2), P.peerRect(10,3), (P.peerRect(10,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(11), [], P.peerRect(11,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(11,3)-20), P.peerRect(11,2), P.peerRect(11,3), (P.peerRect(11,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(12), [], P.peerRect(12,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(12,3)-20), P.peerRect(12,2), P.peerRect(12,3), (P.peerRect(12,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(13), [], P.peerRect(13,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(13,3)-20), P.peerRect(13,2), P.peerRect(13,3), (P.peerRect(13,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(14), [], P.peerRect(14,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(14,3)-20), P.peerRect(14,2), P.peerRect(14,3), (P.peerRect(14,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(15), [], P.peerRect(15,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(15,3)-20), P.peerRect(15,2), P.peerRect(15,3), (P.peerRect(15,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(6), [], P.peerRect(6,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(6,3)-20), P.peerRect(6,2), P.peerRect(6,3), (P.peerRect(6,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(7), [], P.peerRect(7,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(7,3)-20), P.peerRect(7,2), P.peerRect(7,3), (P.peerRect(7,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(8), [], P.peerRect(8,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(8,3)-20), P.peerRect(8,2), P.peerRect(8,3), (P.peerRect(8,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(9), [], P.peerRect(9,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(9,3)-20), P.peerRect(9,2), P.peerRect(9,3), (P.peerRect(9,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(10), [], P.peerRect(10,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(10,3)-20), P.peerRect(10,2), P.peerRect(10,3), (P.peerRect(10,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(11), [], P.peerRect(11,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(11,3)-20), P.peerRect(11,2), P.peerRect(11,3), (P.peerRect(11,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(12), [], P.peerRect(12,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(12,3)-20), P.peerRect(12,2), P.peerRect(12,3), (P.peerRect(12,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(13), [], P.peerRect(13,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(13,3)-20), P.peerRect(13,2), P.peerRect(13,3), (P.peerRect(13,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(14), [], P.peerRect(14,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(14,3)-20), P.peerRect(14,2), P.peerRect(14,3), (P.peerRect(14,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(15), [], P.peerRect(15,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(15,3)-20), P.peerRect(15,2), P.peerRect(15,3), (P.peerRect(15,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(16), [], P.peerRect(16,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(16,3)-20), P.peerRect(16,2), P.peerRect(16,3), (P.peerRect(16,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(6), [], P.peerRect(6,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(6,3)-20), P.peerRect(6,2), P.peerRect(6,3), (P.peerRect(6,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(7), [], P.peerRect(7,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(7,3)-20), P.peerRect(7,2), P.peerRect(7,3), (P.peerRect(7,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(8), [], P.peerRect(8,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(8,3)-20), P.peerRect(8,2), P.peerRect(8,3), (P.peerRect(8,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(9), [], P.peerRect(9,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(9,3)-20), P.peerRect(9,2), P.peerRect(9,3), (P.peerRect(9,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(10), [], P.peerRect(10,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(10,3)-20), P.peerRect(10,2), P.peerRect(10,3), (P.peerRect(10,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(11), [], P.peerRect(11,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(11,3)-20), P.peerRect(11,2), P.peerRect(11,3), (P.peerRect(11,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(12), [], P.peerRect(12,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(12,3)-20), P.peerRect(12,2), P.peerRect(12,3), (P.peerRect(12,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(13), [], P.peerRect(13,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(13,3)-20), P.peerRect(13,2), P.peerRect(13,3), (P.peerRect(13,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(14), [], P.peerRect(14,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(14,3)-20), P.peerRect(14,2), P.peerRect(14,3), (P.peerRect(14,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(15), [], P.peerRect(15,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(15,3)-20), P.peerRect(15,2), P.peerRect(15,3), (P.peerRect(15,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(16), [], P.peerRect(16,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(16,3)-20), P.peerRect(16,2), P.peerRect(16,3), (P.peerRect(16,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(17), [], P.peerRect(17,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(17,3)-20), P.peerRect(17,2), P.peerRect(17,3), (P.peerRect(17,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(6), [], P.peerRect(6,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(6,3)-20), P.peerRect(6,2), P.peerRect(6,3), (P.peerRect(6,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(7), [], P.peerRect(7,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(7,3)-20), P.peerRect(7,2), P.peerRect(7,3), (P.peerRect(7,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(8), [], P.peerRect(8,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(8,3)-20), P.peerRect(8,2), P.peerRect(8,3), (P.peerRect(8,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(9), [], P.peerRect(9,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(9,3)-20), P.peerRect(9,2), P.peerRect(9,3), (P.peerRect(9,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(10), [], P.peerRect(10,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(10,3)-20), P.peerRect(10,2), P.peerRect(10,3), (P.peerRect(10,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(11), [], P.peerRect(11,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(11,3)-20), P.peerRect(11,2), P.peerRect(11,3), (P.peerRect(11,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(12), [], P.peerRect(12,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(12,3)-20), P.peerRect(12,2), P.peerRect(12,3), (P.peerRect(12,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(13), [], P.peerRect(13,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(13,3)-20), P.peerRect(13,2), P.peerRect(13,3), (P.peerRect(13,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(14), [], P.peerRect(14,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(14,3)-20), P.peerRect(14,2), P.peerRect(14,3), (P.peerRect(14,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(15), [], P.peerRect(15,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(15,3)-20), P.peerRect(15,2), P.peerRect(15,3), (P.peerRect(15,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(16), [], P.peerRect(16,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(16,3)-20), P.peerRect(16,2), P.peerRect(16,3), (P.peerRect(16,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(17), [], P.peerRect(17,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(17,3)-20), P.peerRect(17,2), P.peerRect(17,3), (P.peerRect(17,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(18), [], P.peerRect(18,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(18,3)-20), P.peerRect(18,2), P.peerRect(18,3), (P.peerRect(18,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(6), [], P.peerRect(6,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(6,3)-20), P.peerRect(6,2), P.peerRect(6,3), (P.peerRect(6,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(7), [], P.peerRect(7,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(7,3)-20), P.peerRect(7,2), P.peerRect(7,3), (P.peerRect(7,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(8), [], P.peerRect(8,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(8,3)-20), P.peerRect(8,2), P.peerRect(8,3), (P.peerRect(8,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(9), [], P.peerRect(9,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(9,3)-20), P.peerRect(9,2), P.peerRect(9,3), (P.peerRect(9,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(10), [], P.peerRect(10,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(10,3)-20), P.peerRect(10,2), P.peerRect(10,3), (P.peerRect(10,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(11), [], P.peerRect(11,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(11,3)-20), P.peerRect(11,2), P.peerRect(11,3), (P.peerRect(11,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(12), [], P.peerRect(12,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(12,3)-20), P.peerRect(12,2), P.peerRect(12,3), (P.peerRect(12,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(13), [], P.peerRect(13,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(13,3)-20), P.peerRect(13,2), P.peerRect(13,3), (P.peerRect(13,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(14), [], P.peerRect(14,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(14,3)-20), P.peerRect(14,2), P.peerRect(14,3), (P.peerRect(14,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(15), [], P.peerRect(15,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(15,3)-20), P.peerRect(15,2), P.peerRect(15,3), (P.peerRect(15,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(16), [], P.peerRect(16,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(16,3)-20), P.peerRect(16,2), P.peerRect(16,3), (P.peerRect(16,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(17), [], P.peerRect(17,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(17,3)-20), P.peerRect(17,2), P.peerRect(17,3), (P.peerRect(17,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(18), [], P.peerRect(18,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(18,3)-20), P.peerRect(18,2), P.peerRect(18,3), (P.peerRect(18,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(19), [], P.peerRect(19,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(19,3)-20), P.peerRect(19,2), P.peerRect(19,3), (P.peerRect(19,2)+20)]);
Screen('Flip', w); WaitSecs(0.1);

% peers 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20:
Screen('DrawTexture', w, P.peerImgTexture(1), [], P.peerRect(1,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(1,3)-20), P.peerRect(1,2), P.peerRect(1,3), (P.peerRect(1,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(2), [], P.peerRect(2,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(2,3)-20), P.peerRect(2,2), P.peerRect(2,3), (P.peerRect(2,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(3), [], P.peerRect(3,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(3,3)-20), P.peerRect(3,2), P.peerRect(3,3), (P.peerRect(3,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(4), [], P.peerRect(4,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(4,3)-20), P.peerRect(4,2), P.peerRect(4,3), (P.peerRect(4,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(5), [], P.peerRect(5,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(5,3)-20), P.peerRect(5,2), P.peerRect(5,3), (P.peerRect(5,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(6), [], P.peerRect(6,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(6,3)-20), P.peerRect(6,2), P.peerRect(6,3), (P.peerRect(6,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(7), [], P.peerRect(7,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(7,3)-20), P.peerRect(7,2), P.peerRect(7,3), (P.peerRect(7,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(8), [], P.peerRect(8,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(8,3)-20), P.peerRect(8,2), P.peerRect(8,3), (P.peerRect(8,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(9), [], P.peerRect(9,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(9,3)-20), P.peerRect(9,2), P.peerRect(9,3), (P.peerRect(9,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(10), [], P.peerRect(10,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(10,3)-20), P.peerRect(10,2), P.peerRect(10,3), (P.peerRect(10,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(11), [], P.peerRect(11,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(11,3)-20), P.peerRect(11,2), P.peerRect(11,3), (P.peerRect(11,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(12), [], P.peerRect(12,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(12,3)-20), P.peerRect(12,2), P.peerRect(12,3), (P.peerRect(12,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(13), [], P.peerRect(13,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(13,3)-20), P.peerRect(13,2), P.peerRect(13,3), (P.peerRect(13,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(14), [], P.peerRect(14,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(14,3)-20), P.peerRect(14,2), P.peerRect(14,3), (P.peerRect(14,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(15), [], P.peerRect(15,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(15,3)-20), P.peerRect(15,2), P.peerRect(15,3), (P.peerRect(15,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(16), [], P.peerRect(16,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(16,3)-20), P.peerRect(16,2), P.peerRect(16,3), (P.peerRect(16,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(17), [], P.peerRect(17,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(17,3)-20), P.peerRect(17,2), P.peerRect(17,3), (P.peerRect(17,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(18), [], P.peerRect(18,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(18,3)-20), P.peerRect(18,2), P.peerRect(18,3), (P.peerRect(18,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(19), [], P.peerRect(19,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(19,3)-20), P.peerRect(19,2), P.peerRect(19,3), (P.peerRect(19,2)+20)]);
Screen('DrawTexture', w, P.peerImgTexture(20), [], P.peerRect(20,:)); Screen('FillOval', w, [0 0 255], [(P.peerRect(20,3)-20), P.peerRect(20,2), P.peerRect(20,3), (P.peerRect(20,2)+20)]);
WaitSecs(0.1);
DrawFormattedText(w, genderText, 'center', 'center', P.screen.black, [],[],[],[],[], [(P.genderTextCenter(1)-50), (P.genderTextCenter(2)-40), P.genderTextCenter(1), P.genderTextCenter(2)]); 
Screen('DrawLine', w, P.screen.blue, 0, (P.screen.yCenter-5), P.screen.width, (P.screen.yCenter-5), 5);
Screen('DrawLine', w, P.screen.blue, (P.screen.xCenter-5), (P.screen.yCenter-5), (P.screen.xCenter-5), P.screen.height, 5);
Screen('Flip', w);

%% Collect subject's selections (in total: 5 out of 20 peers)
% Subjects are allowed to select (left click) and unselect (right click) peer images
% initiate profile, profileSaved, pos1Clicked, & pos2Clicked for the function selectProfile2

peerSaved = 0; peerCount = 0;
P.clickedRect = NaN(5,4);
P.filledPos = NaN(5,4);
P.filledName = cell(1,5);
P.filledImgTexture = NaN(5,1);
P.clickedImgNumber = []; 

while peerCount <= 5

    [clicks, xClicked, yClicked, whichButton] = GetClicks(P.screenNumber, 0); %immediately will go to next line once one click happens
    [P, peerSaved] = chza_selectPeerImages(P, peerSaved, xClicked, yClicked, whichButton);
    peerCount = peerSaved; % count of profiles as filled

    chza_displaySelectedPeers;

    if peerCount == 5
        [clicks, xClicked, yClicked, whichButton] = GetClicks(P.screenNumber, 0); %immediately will go to next line once one click happens

        if clicks % if mouse clicked

            [P, peerSaved] = chza_selectPeerImages(P, peerSaved, xClicked, yClicked, whichButton);
            peerCount = peerSaved; % decrease the count after unselection

            chza_displaySelectedPeers;
        end
    end
end

%% Save profile selection together with this subject's information
T.subDetails = sprintf('%s,%s,%d',T.subName, T.subGender, T.subAge); 

T.SessionResult = {T.subDetails; selectionGender; P.filledName{1}; ...
    P.filledName{2}; P.filledName{3}; P.filledName{4}; P.filledName{5}};

% save the session results into subject's .dat file
cd(subjDir)
writecell(T.SessionResult, sprintf('chza-%d.dat',T.subID))

%% Close the experiment  
text = 'Goodbye!';
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor);
Screen('Flip', w); WaitSecs(0.5);
Screen('CloseAll');
sca