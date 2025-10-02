% RUN Chatroom Main Task (in the Scanner)
% Code by Busra Tanriverdi,
% Last updated March 29th, 2023
% Contact: busra.tanriverdi@temple.edu or cablab@temple.edu

% Functions & scripts below should be in the same folder with this one (chzc_RISECREST_SCAN.m) for a smooth run:
% --->  waitForScanner.m
% --->  waitForSpacebar.m
% --->  getResponse.m
% --->  whoIsSelected.m

%%%%% !!!!!! IMPORTANT NOTES FOR ANY PROJECT-SPECIFIC EDITS !!!!!! %%%%%
% NOTE: After the first scanner trigger, the task waits for 2 seconds to launch, and after the last trial, it takes 8 secs to end. 
% So the scanner protocol (timing) should be fixed accordingly (current estimation is "802" secs) to make sure scanner data covers all trials!

% LINE 43 --> rootDir variable below must match the folder directory. If you don't change this to the directory of your project folder, 
% the task will not work! 

% LINES 167-168 --> The experiment is currently set to be displayed at the maximum monitor number (e.g., if you have 2 monitors, the trials will be
% shown on the 2nd monitor). You can change it to minimum by commenting out the line 168, and removing the "%" sign in front of the line 167. 
% Note: Sometimes the scanner monitor is the 2nd, but Matlab somehow mistakes it for the 1st, if that happens, just play around min/max, one of them should work!

% LINES 278:284 --> This is where we assign the peer images based on the participant age, depending on your needs
% (e.g., if your age boundaries are different than the current code, you may choose to edit it).

% LINE 429 loads subject's photo into the program; and LINES 457:458 loads peer images. Peer images are in .png and subject image is in .bmp format; 
% make sure to change them accordinly in these lines if you change your photo-extension.

%% Initialization
clear; close all; clc; % clear the screen & variable environment

% check system & define keyboard number - important for Mac/Windows compatibility !!! DO NOT delete or edit this !!!
if ismac
    k = GetKeyboardIndices;
    deviceNumber = PsychHID('Devices');
else
    k = 0;
end

PsychDefaultSetup(1); % configure Psychtoolbox

%% Set directories and structures
rootDir = '/Users/tum99916/Desktop/chatroom_Matlab'; % should be same as the project folder directory
addpath(genpath(fullfile(rootDir)));
cd(rootDir); 

% Set structures for parameters & subject data
P = [];  T = []; 

stimDir = [rootDir,filesep,'stimuli']; % stimulus (player images) directory 
dataDir = [rootDir,filesep,'data']; % data directory 

P.sesDate = datestr(now,'yy.mm.dd'); % collect session date/time: will be printed in the output file's name!
P.sesName = "RISE_CREST"; % for RISE in Alloy Lab: will be printed in the output file's name!
P.timing.globalStartTime = GetSecs; % record start time for the experiment

ListenChar(0); % make sure MATLAB is listening to the keyboard inputs

%% Collect subject ID & session info
% This will prompt the questions about subject's number, sex, name, age & session
% Note age is added because this version of the task use different peer images for different ages.

%%%% 1. Subject Number
subID = inputdlg('Please enter the Subject Number:');
P.subID = str2double(subID);
if ~exist('subID','var') % if subject ID is missing, abort
    error('No subject ID entered. Try again!')
end

%%%% 2. Session Number
sesNum = inputdlg('Please enter the Session Number:'); 
P.sesNum = str2double(sesNum);

%%%% 3. Subject Name
subName = inputdlg('Please enter Subject''s Name:'); 
P.subName = char(subName);

%%%% 4. Subject Gender
% PS: You can play with how the question/response options appear to make it
% similar to the EPrime code (but not the most important thing!)
genderlist={'male','female'};
subGender = listdlg('PromptString','Please enter Subject''s Sex:', ...
    'SelectionMode','single','ListString',genderlist);  % gets the index for gender
P.subGender = genderlist{subGender};

%%%% Sub Age
subAge = inputdlg('Please enter the Subject''s Age:');
P.subAge = str2double(subAge);

%%%% 5. Double check if all the info is correct
opts.Interpreter = 'tex'; opts.Default = 'Yes';
answer = questdlg({sprintf('Subject: %d',P.subID), ...
    sprintf('Session: %d',P.sesNum), ...
    sprintf('Name: %s',P.subName), ...
    sprintf('Sex: %s \n',P.subGender), ...
    'Continue with the above startup info?'}, ...
    'Summary of Startup Info','Yes','No','Cancel',opts); 

% if info is incorrect, reprompt all the questions above to allow editing
if strcmp(answer, 'No')
    subID = inputdlg('Please enter the Subject Number:');
    P.subID = str2double(subID);
    if ~exist('subID','var') % if subject ID is missing, abort
        error('No subject ID entered. Try again!')
    end

    sesNum = inputdlg('Please enter the Session Number:');
    P.sesNum = str2double(sesNum);

    subName = inputdlg('Please enter Subject''s Name:');
    P.subName = char(subName);

    subGender = listdlg('PromptString','Please enter Subject''s Sex:', ...
        'SelectionMode','single','ListString',genderlist);  % gets the index for gender
    P.subGender = genderlist{subGender};

    opts.Interpreter = 'tex'; opts.Default = 'Yes';
    answer = questdlg({sprintf('Subject: %d',P.subID), ...
        sprintf('Session: %d',P.sesNum), ...
        sprintf('Name: %s',P.subName), ...
        sprintf('Sex: %s \n',P.subGender), ...
        'Continue with the above startup info?'}, ...
        'Summary of Startup Info','Yes','No','Cancel',opts);
end

%%%% 6. Set output directory & filename for this subject
subjDir = [dataDir,filesep,num2str(P.subID)]; % subject's data directory 
trialfile = ['chzc_Scanner_',char(P.sesName),'_',P.sesDate,'-',num2str(P.subID),'-',num2str(P.sesNum)];
    
% define output files 
outputFile_Trials = [subjDir,filesep,trialfile,'.csv']; % define output file to store results
outputFile_Params = [subjDir,filesep,trialfile,'_parameters.mat']; % define output file to store parameters

% check if this results directory already exists; this is kind of arbitrary
% because the folder should exist & have some files from prepatory tasks (chza & chzb)!
if exist(subjDir, 'dir') == 7 % if yes, check if the output file exists
    if isfile(outputFile_Trials) % if yes, decide whether to overwrite
        overwrite = questdlg({'WARNING: The data file and/or recovery file already exists:', ...
            sprintf('FILE: %s \n',trialfile), ...
            'Do you want to overwrite?'}, ...
            '','Yes','No','');
        if strcmp(overwrite, 'No') % in case the same task is tried twice with a participant on the same day, this option would create a separate output file than the 1st one. 
            fprintf('Not overwriting. Creating a new output file now.')
            % re-define output files (subject to change)
            outputFile_Trials = [subjDir,filesep,trialfile,'-attempt2.csv']; % define a new output file to store results
            outputFile_Params = [subjDir,filesep,trialfile,'_parameters-attempt2.mat']; % define a new output file to store parameters
        end
    end
else % otherwise, create results subdirectory for this subject
    mkdir(subjDir); 
end

%%%% 7. Prompt "Open Chat" window
% % PS: a black screen should appear before and after this 'Open Chat' window
chatName = inputdlg({'Type in your Chat name:'},'Open Chat'); 
P.chatName = char(chatName);

%%%% 8. Prompt "Connect" window
opts.Interpreter = 'tex'; opts.Default = 'Yes';
connect = questdlg({sprintf('Hello %s, \nconnect?', P.chatName)},'Connect','Yes','No',opts); 

%% Set Screen parameters

%%%% open display
clear Screen % remove any previously opened screens
P.screen.nScreens = Screen('Screens'); % get screen numbers   
P.screen.screenNumber = 1; % keep the first screen if multiple exist -this works well for the 2-display set up in TUBRIC!
%P.screen.screenNumber = max(P.screen.nScreens); % draw to external screen if available
Screen('Preference', 'SkipSyncTests', 1); % skip sync tests
[w, P.screen.rect] = Screen('OpenWindow', P.screen.screenNumber, [], []); % get screen coordinates

%%%% set screen-related parameters
P.screen.width  = P.screen.rect(RectRight); 
P.screen.height = P.screen.rect(RectBottom);
P.screen.xCenter = P.screen.width/2;
P.screen.yCenter = P.screen.height/2;
P.screen.flipDuration = Screen('GetFlipInterval',w); 
P.screen.white = double(WhiteIndex(w)); 
P.screen.black = double(BlackIndex(w));
P.screen.gray = double(GrayIndex(w)); 
P.screen.backgroundColor = [200 200 200];
P.screen.feedbackColor = [120 120 120];
P.screen.textColor = [100 100 100];
P.screen.textRed = [250 0 0];  
P.screen.textGreen = [10 100 10];
P.screen.invalidColor = [P.screen.white 0 0];

%%%% set screen parameters for experimental trials
P.screen.xTextCenter = P.screen.xCenter - P.screen.xCenter/2;
P.screen.leftCenter = P.screen.xCenter/2;
P.screen.rightCenter = P.screen.xCenter + P.screen.xCenter/2;
P.screen.upperCenter = P.screen.height - 3/2 * P.screen.yCenter;
P.screen.lowerCenter = P.screen.height - 1/2 * P.screen.yCenter;
P.screen.profileTextCenter = P.screen.xCenter - P.screen.leftCenter/2; % to display Players

% get coordinates for the player image on left lower corner
P.screen.lowerCorner = P.screen.height - 1/3 * P.screen.yCenter;
P.screen.leftCorner = 1/3 * P.screen.leftCenter; 

% profile center points
P.screen.target1LocationX = (P.screen.xCenter/2 * 4/3);
P.screen.target2LocationX = ((P.screen.xCenter/2) * 5/2) + 120;
P.screen.target12LocationY = P.screen.target1LocationX - 100; % seems similar enough, & both should share the same location

%%%% open first screen; set parameters for on-screen background and font
% setup alpha blending for smoothed (anti-aliased) lines
Screen(w, 'BlendFunction', GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% fill screen with background color
Screen('FillRect', w, P.screen.backgroundColor);
Screen('Flip', w);

% set size and font of text
Screen('TextSize', w, 40);
Screen('TextFont', w, 'Courier New');

%%%% keyboard and keypresses
KbName('UnifyKeyNames'); % unify keyboard for different operating systems
RestrictKeysForKbCheck([]); % no keys restricted from checking

%% Set Experimental Parameters
%%%% Time parameters:
P.timing.trialtextdisp = 2; % trial text display time
P.timing.playerselectiondisp = 8; % duration for the selected player display
P.timing.profiledisp = 4; % profile display time- before the experiment
P.timing.trialdisp = 4; % trial duration 
P.timing.conndisp = 2; % connecting images display duration

%%%% Counters parameters:
P.counters.numBlocks = 4; % FOR PILOT1, SUBJECT TO CHANGE!
P.counters.numLists = 3; % FOR NOW, SUBJECT TO CHANGE!
P.counters.numTrials = 15; % FOR NOW, SUBJECT TO CHANGE! 
P.counters.nAllTrials = P.counters.numBlocks * P.counters.numTrials;

%%%% Keypress related parameters
% resp1 & resp7 for left presses, and resp2 & resp6 for right presses. 
% Restrict keys for KbCheck
P.key.backtick = '='; % define backtick for scanner trigger
P.key.space = 'space'; % define spacebar
P.key.resp1 = KbName('1'); P.key.resp1_alt = KbName('1!'); % define both alternatives for button/key-1
P.key.resp2 = KbName('2'); P.key.resp2_alt = KbName('2@'); % define both alternatives for button/key-2
P.key.resp6 = KbName('6'); P.key.resp6_alt = KbName('6^'); % define both alternatives for button/key-6
P.key.resp7 = KbName('7'); P.key.resp7_alt = KbName('7&'); % define both alternatives for button/key-7
P.key.quit = KbName('z'); % if pressed while participant input is expected, it should end the session

%%%% Stimulus image size-related parameters
P.connImg.width = 2/3 * P.screen.width; % subject to change
P.connImg.height = 2/3 * P.screen.height; % subject to change
 
P.prompt.width = 1/5 * P.screen.width; % subject to change
P.prompt.height = 1/5 * P.screen.height; % subject to change

% the following dimensions are picked from the original design:
% profile images for the display of profiles before experiment starts
P.profileImg.width = 400; % 235
P.profileImg.height = 600; % 360

% target images for 'selection' (to-be-appeared upper x/y centers)
P.targetImg.width = 460; % 560
P.targetImg.height = 620; % 857

% agent who 'selects' among the players (to-be-appeared on lower left corner)
P.agentImg.width = 120; % 78; 
P.agentImg.height = 150; % 120;

%%%% Stimulus selection (feedback) parameters
% calculate the coordinates for the box around selected player
P.selected.RightX = CenterRectOnPointd([0 0 P.targetImg.width P.targetImg.height], P.screen.target2LocationX, P.screen.target12LocationY);
P.selected.LeftX = CenterRectOnPointd([0 0 P.targetImg.width P.targetImg.height], P.screen.target1LocationX, P.screen.target12LocationY);

% Once a selection is made (left/right), the remaining image is unselected player
P.unselected.LeftX = P.selected.RightX;
P.unselected.RightX = P.selected.LeftX;

%% Read All Stimuli (Faces & Connection Images)
%%%% Read all stimuli
% select stimuli for different age ranges! 
if P.subAge >= 15 % teens
    ageStimDir = [stimDir,filesep,'teens'];
elseif P.subAge <= 14 && P.subAge >= 12 % middle
    ageStimDir = [stimDir,filesep,'middle'];
elseif P.subAge <= 11 % youth
    ageStimDir = [stimDir,filesep,'youth'];  % stimuli directory
end
P.stimuli.Stimuli = dir(ageStimDir); % load the correct image directory

%%%% Connecting images for early display in the experiment 
connectDir = [stimDir,filesep,'connection'];
P.stimuli.connect = dir(connectDir); % load the correct image directory

connectImgs = P.stimuli.connect(contains({P.stimuli.connect.name}, 'CONNECT'),:);
for indConn = 1:length(connectImgs)
    number(indConn)= indConn;
    baseFileName{indConn} = connectImgs(indConn).name;
    fullFileName{indConn} = fullfile(connectDir, baseFileName{indConn});
    name{indConn} = connectImgs(indConn).name(1:end-4);
end

P.stimuli.Connect = table(number', name', baseFileName', fullFileName'); 
P.stimuli.Connect.Properties.VariableNames = {'number', 'name', 'baseFileName', 'fullFileName'};

clear number baseFileName fullFileName name;

%% Display 'connecting between sites' images       
% There are 8 connecting images, each will follow each other in order
% displayed in the same way. So we loop them together:
for indConn = 1:length(P.stimuli.Connect.fullFileName)
    % prepare the image
    connImage = imread(char(P.stimuli.Connect.fullFileName(indConn))); 
    connRect = CenterRectOnPointd([0 0 P.connImg.width P.connImg.height], P.screen.xCenter, P.screen.yCenter); 
    connTexture = Screen('MakeTexture', w, connImage);
    
    % show the image
    Screen('DrawTexture', w, connTexture, [], connRect);
    Screen('Flip', w);
    WaitSecs(P.timing.conndisp);
end

%% Display Task Instructions
%%%% Task instructions in the following order
%%%%% 1
text = ['Chat Choose 1 \n\n'...
    'We will match you with other teens based on \n'...
    'the choices you just made and the choices the \n'...
    'other teens make. \n\n' ...
    'You will now play the game. \n'...
    'The first 3 rounds are with you and \n'...
    'two other teens.'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor); Screen('Flip', w);
KbStrokeWait(); % wait for a keystroke from subject 

%%%%% 2
text = ['Chat Choose 2 \n\n'...
    'First, you will see your information and then \n'...
    'you will meet the two other teens. When this \n'...
    'happens you don''t need to press anything, \n'...
    'it will move on automatically. \n\n'...
    'Then each teen will take turns choosing which \n'...  
    'of the two they would rather chat with about \n' ...
    'certain topics.'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor); Screen('Flip', w);
KbStrokeWait(); % wait for a keystroke from subject 

%%%%% 3
text = ['Chat Choose 3 \n\n'...
    'You will use your pointer and middle fingers \n'...
    'to respond. \n\n'...
    'If it is your turn to choose please \n'...
    'use the left button to choose the left person \n'...
    'or use the right button to choose the right \n'...
    'person on each question. \n\n'...
    'Please answer as quickly as possible -you \n'...
    'have 3 seconds to make a response.'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor); Screen('Flip', w);
KbStrokeWait(); % wait for a keystroke from subject 

%%%%% 4
text = ['Chat Choose 4 \n\n'...
    'If it is NOT your turn to choose, please \n'...
    'indicate whether the person on the left \n'...1267   
    '(Press the left button) or right (Press the \n'...
    'right button) was chosen on each question.'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor); Screen('Flip', w);
KbStrokeWait(); % wait for a keystroke from subject 

%%%%% 5
text = ['Chat Choose 5 \n\n'...
    'In order to understand how teens'' brains \n'...
    'respond to interacting with other teens we \n'...
    'need to know what happens when teens just \n'...
    'look at pictures and words. \n\n'...
    'So at the end of the task we will ask you to \n'...
    'just look at each other''s pictures and the \n'...
    'sentence at the bottom of the screen while a \n'...
    'dot appears on different sides of the screen.'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor); Screen('Flip', w);
KbStrokeWait(); % wait for a keystroke from subject 

%%%%% 6
text = ['Chat Choose 6 \n\n'...
    'You will be asked to press a button to show \n'...
    'which side of the screen the dot is on. You \n'...
    'should press the left button if the dot is on \n'...
    'the left, and the right button if the dot is \n'...
    'on the right.'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor); Screen('Flip', w);
KbStrokeWait(); % wait for a keystroke from subject  

%%%%% 7
text = ['Do you have any questions? \n\n'...
    'As a reminder, next you will see the profiles \n'...
    'and then after a brief pause the scanner and \n'...
    'game will start.'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor);
Screen('Flip', w); KbStrokeWait(); % wait for a keystroke from subject

%%%% not sure if there is any blank scren that follows the last instruction page
% keeping this as is for now in case there is a blank page in there.
% brief blank screen before moving on
Screen('FillRect',w, P.screen.backgroundColor);
Screen('Flip', w);
WaitSecs(0.1);
FlushEvents;

%% Display Players
% Here the subject is introduced to the players: themselves, player1 &
% player2, both of which comes from their own preferences.
% So, first get subject preferences:
%%%% Open the directory
cd(subjDir); % subjects data from the preference task must have been saved here!

%%%% Read Information from this Subject's preferences
% read the (image) names of preferred players by this subject
chza = importdata(sprintf('chza-%d.dat',P.subID)); 

% read subject's own name: (note the name, gender & age are saved into the
% same cell, separate them when you recode the chza task script, so it's
% easier to extract it here. for now we can do this:
chza_sub = regexp(chza(1),',','split');
subject = cellstr(chza_sub{1}{1,1}); 

% read their own interests:
subject(2:4,:) = importdata(sprintf('s%d.dat',P.subID)); 
if sum(contains(subject,'"')) > 0 % remove the unnecessary "" from the names -which some of the old RISE/CREST data has
    subject = strrep(subject,'"','');
end

% get subject's image & its directory:
subject_img = sprintf('s%d.bmp',P.subID);
subject_img_fullfile = sprintf('%s',[subjDir,filesep,subject_img]);

%%%% Read the interests of preferred players by this subject
chzb = importdata(sprintf('chzb-%d.dat',P.subID)); 

% extract the players' info:
profile1 = chzb(1:4); profile2 = chzb(5:8); 
if sum(contains(profile1,'"')) > 0 % remove the unnecessary "" from the names -which some of the old RISE/CREST data has
    profile1 = strrep(profile1,'"','');
end
if sum(contains(profile2,'"')) > 0 % remove the unnecessary "" from the names -which some of the old RISE/CREST data has
    profile2 = strrep(profile2,'"','');
end

% get players' images:
% randomize peer images, and get two random peers as the profile images
indPeerImgs = 3:7; indPeerImgs = indPeerImgs(randperm(length(indPeerImgs)));
profile1_img = char(chza(indPeerImgs(1))); profile2_img = char(chza(indPeerImgs(2))); 

if sum(contains(profile1_img,'"')) > 0 % remove the unnecessary "" from the names -which some of the old RISE/CREST data has
    profile1_img = strrep(profile1_img,'"','');
end
if sum(contains(profile2_img,'"')) > 0 % remove the unnecessary "" from the names -which some of the old RISE/CREST data has
    profile2_img = strrep(profile2_img,'"','');
end

% get players' image directory
profile1_img_fullfile = sprintf('%s',[ageStimDir,filesep,profile1_img(1,1:end-3)],'png');
profile2_img_fullfile = sprintf('%s',[ageStimDir,filesep,profile2_img(1,1:end-3)],'png');

%%%% Now Display PLayers
%%%% 1. Subject themselves
% prepare stimulus for this trial
subImage = imread(subject_img_fullfile);

% center the image on the left, and text on the right
subImgRect = CenterRectOnPointd([0 0 P.profileImg.width P.profileImg.height], (P.screen.leftCenter-100), P.screen.yCenter);
subImgTexture = Screen('MakeTexture', w, subImage);

% extract the text from subject1
subject_txt = sprintf('%s \n\n%s \n\n%s \n\n%s',subject{1},subject{2},subject{3},subject{4});

%%%% show stimulus together with the subject's preferences text
DrawFormattedText(w, subject_txt, P.screen.profileTextCenter, 'center', P.screen.textColor);
Screen('DrawTexture', w, subImgTexture, [], subImgRect);
Screen('Flip', w);
WaitSecs(P.timing.profiledisp); 

%%%% 1. Profile-1
% Profile-1's photo from the bmpsm directory on the left & text on the right:
profile1Image = imread(profile1_img_fullfile); 

% center the image on the left, and text on the right
profile1ImgRect = CenterRectOnPointd([0 0 P.profileImg.width P.profileImg.height], (P.screen.leftCenter-100), P.screen.yCenter);
profile1ImgTexture = Screen('MakeTexture', w, profile1Image);

% extract the text from subject1
profile1_txt = sprintf('%s \n\n%s \n\n%s \n\n%s',profile1{1},profile1{2},profile1{3},profile1{4});

%%%% show stimulus together with the profile's text
DrawFormattedText(w, profile1_txt, P.screen.profileTextCenter, 'center', P.screen.textColor);
Screen('DrawTexture', w, profile1ImgTexture, [], profile1ImgRect);
Screen('Flip', w);
WaitSecs(P.timing.profiledisp); 

%%%% 2. Profile-2
% Profile-2's photo from the bmpsm directory on the left & text on the right:
profile2Image = imread(profile2_img_fullfile);

% center the image on the left, and text on the right
profile2ImgRect = CenterRectOnPointd([0 0 P.profileImg.width P.profileImg.height], (P.screen.leftCenter-100), P.screen.yCenter);
profile2ImgTexture = Screen('MakeTexture', w, profile2Image);

% extract the text from subject1
profile2_txt = sprintf('%s \n\n%s \n\n%s \n\n%s',profile2{1},profile2{2},profile2{3},profile2{4});

%%%% show stimulus together with the profile's text
DrawFormattedText(w, profile2_txt, P.screen.profileTextCenter, 'center', P.screen.textColor);
Screen('DrawTexture', w, profile2ImgTexture, [], profile2ImgRect);
Screen('Flip', w);
WaitSecs(P.timing.profiledisp); 

%% Prepare Stimuli 
%%%% Topic Lists 
% There are 3 lists for 3 experimental blocks 
% The same list is used for each block. (Do jitters change? CHECK!!!)
topics = {'SCHOOL';'PARTIES';'VACATIONS';'HOBBIES';'MUSIC';'TV';'MOVIES'; ...
    'FOOD';'SHOPPING';'COMPUTERS';'PETS';'BOOKS';'FRIENDS';'FAMILY';'SPORTS'};
topicsNum = (1:15)';
ITIj = [1; .5; 1.5; 1; 1.5; 1; .5; 1.5; .5; .5; .5; 1.5; 1; 1; 1.5];

% List1 for Block 1 (ListT in old code)
P.list1 = table(topicsNum, topics, ITIj);
P.list1.Properties.VariableNames = {'TopicNumber', 'Topic', 'ITIj'};

% List2 for the block where subject is selected less
subjSelectedLess = [1 1 1 1 1 0 0 0 0 0 0 0 0 0 0];
subjSelectedLess = subjSelectedLess(randperm(length(subjSelectedLess)));
P.list2 = [P.list1, table(subjSelectedLess')];
P.list2.Properties.VariableNames = {'TopicNumber', 'Topic', 'ITIj', 'AgentsChoice'};

% List 3 for the block where subject is selected more
subjSelectedMore = [1 1 1 1 1 0 0 0 0 0 1 1 1 1 1];
subjSelectedMore = subjSelectedMore(randperm(length(subjSelectedMore))); 
P.list3 = [P.list1, table(subjSelectedMore')];
P.list3.Properties.VariableNames = {'TopicNumber', 'Topic', 'ITIj', 'AgentsChoice'};

% List 4 for the block, i.e., the visuo-motor control block
list4subjSelection = [1 1 0 1 1 0 0 0 0 0 1 1 0 1 1];
list4subjSelection = list4subjSelection(randperm(length(list4subjSelection)));
P.list4 = [P.list1, table(list4subjSelection')];
P.list4.Properties.VariableNames = {'TopicNumber', 'Topic', 'ITIj', 'DotProbe'};

%%%% Block Order Lists
% in block1 the subject is the 'agent'; the two profiles are 'targets'
% in block2 the profile1 is the 'agent'; subject & profile2 are 'targets'
% in block3 the profile2 is the 'agent'; subject & profile1 are 'targets'
blockNum = (1:3)';
ordPhrase = {'FIRST';'NEXT';'NEXT'}; 

% Get profile names based on this subject's info & preferences
agentName = {subject(1); profile1(1); profile2(1)};
target1Name = {profile2(1); subject(1); subject(1)};
target2Name = {profile1(1); profile2(1); profile1(1)};

% Get picture names based on this subject's info & preferences
agentPic = {subject_img; profile1_img; profile2_img}; 
target1Pic = {profile2_img; subject_img; subject_img}; 
target2Pic = {profile1_img; profile2_img; profile1_img};

% Get picture fullfile names based on agent & target names
agentPicDir = {subject_img_fullfile; profile1_img_fullfile; profile2_img_fullfile}; 
target1PicDir = {profile2_img_fullfile; subject_img_fullfile; subject_img_fullfile}; 
target2PicDir = {profile1_img_fullfile; profile2_img_fullfile; profile1_img_fullfile};

P.blockInfo = table(blockNum, agentPic, agentName, agentPicDir, target1Pic, target1Name, target1PicDir, target2Pic, target2Name, target2PicDir, ordPhrase);
P.blockInfo.Properties.VariableNames = {'BlockNumber', 'AgentPic', 'AgentName', 'AgentPicDir', 'Target1Pic', 'Target1Name', ...
    'Target1PicDir', 'Target2Pic', 'Target2Name', 'Target2PicDir', 'OrderPhrase'};

%%%% Block1 
% In this block, subject selects between the other players for each topic.
% the order of images come from the first row of the blocks
block1 = P.blockInfo(1,:);

% extract the agent for this block:
block1Agent =  char(block1.AgentName{1});
block1Target1 = char(block1.Target1Name{1});
block1Target2 = char(block1.Target2Name{1});

% prepare the agent's image for this block
block1AgentImage = imread(block1.AgentPicDir{1});
block1AgentImgRect = CenterRectOnPointd([0 0 P.agentImg.width P.agentImg.height], P.screen.leftCorner, P.screen.lowerCorner);
block1AgentImgTexture = Screen('MakeTexture', w, block1AgentImage);

% prepare target images for this block
% target 1
block1Target1Image = imread(block1.Target1PicDir{1}); 
block1Target1ImgRect = CenterRectOnPointd([0 0 P.targetImg.width P.targetImg.height], P.screen.target1LocationX, P.screen.target12LocationY);
block1Target1ImgTexture = Screen('MakeTexture', w, block1Target1Image);

% target 2
block1Target2Image = imread(block1.Target2PicDir{1});
block1Target2ImgRect = CenterRectOnPointd([0 0 P.targetImg.width P.targetImg.height], P.screen.target2LocationX, P.screen.target12LocationY);
block1Target2ImgTexture = Screen('MakeTexture', w, block1Target2Image);

%%%% Blocks 2, 3 & 4 will be prepared on the go, while displaying them, in a for loop

%% Wait For Scanner Trigger
%%%%% 1: Standby Mode
text = ['STANDBY MODE \n\n'...
    'You can relax. \n\n'...
    '(Press SPACEBAR to continue)'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textRed);
Screen('Flip', w);
waitForSpacebar; 

%%%%% 2: Wait for Scanner to send the Trigger
text = ['Waiting for \n\n'...
    'Scan to Start'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textGreen); 
Screen('Flip', w);

%%%%% 3: Get Scanner Trigger
nTrigger = 1; % start counting trigger info, because we collect it throughout (trying)
waitForScanner;
Screen('Flip', w ); WaitSecs(2); % wait for 2 secs -a TR 

%% Run the Experimental Blocks (1:4)
%%%% BLOCK 1
% In this block, subject selects between the other players for each topic.
% The order of images come from the first row of the blocks

% assign the block info to a common variable, needed for extracting subject's
% choices for each trial using the getResponse function
nBlock = 1;
thisBlock = block1;
thisBlckList = P.list1;
responseDeadline = P.timing.trialdisp;

% display who 'plays' (selects) in this block:
block1OrdPhrase = char(thisBlock.OrderPhrase{1});
agentBlck1Rect = CenterRectOnPointd([0 0 P.profileImg.width P.profileImg.height], P.screen.xCenter, (P.screen.yCenter-100));
agentBlck1Texture = Screen('MakeTexture', w, block1AgentImage);
textBlock1 = sprintf('%s WAS RANDOMLY CHOSEN TO GO \n%s', block1Agent,block1OrdPhrase);

Screen('TextSize', w, 40); Screen('TextFont', w, 'Courier New'); % set the text font & size
DrawFormattedText(w, textBlock1, 'center', P.screen.lowerCorner, P.screen.textColor);
Screen('DrawTexture', w, agentBlck1Texture, [], agentBlck1Rect);
Screen('Flip', w);
WaitSecs(P.timing.trialtextdisp);

% randomize the trial order for this subject for this block
indTrialRandomized = thisBlckList.TopicNumber(randperm(height(thisBlckList)));
indBlckTrial = 0; % initialize

for indTrial = 1: P.counters.numTrials

    thisTrialTopic = char(thisBlckList.Topic{indTrialRandomized(indTrial)});  % pick the topic for this trial
    thisITIj = thisBlckList.ITIj(indTrialRandomized(indTrial)); % pick the ITI for this trial
    textTrial = sprintf('%s, who would you rather talk to \nabout %s?', block1Agent,thisTrialTopic);

    % display images & question together on the screen
    Screen('TextSize', w, 40); Screen('TextFont', w, 'Courier New'); % set the text font & size
    DrawFormattedText(w, textTrial, 'center', P.screen.lowerCorner, P.screen.textColor);
    Screen('DrawTexture', w, block1AgentImgTexture, [], block1AgentImgRect);
    Screen('DrawTexture', w, block1Target1ImgTexture, [], block1Target1ImgRect);
    Screen('DrawTexture', w, block1Target2ImgTexture, [], block1Target2ImgRect);    
    Screen('Flip', w);
    tonset = GetSecs;  % get trial onset 
    funcOnset = tonset;
    [P, keyPressed, resp, thisRT, funcOffset] = getResponse(funcOnset, P, k, thisBlock, responseDeadline);
    toffset = funcOffset; % get trial offset

    % highlight the selected player with a gray box around it, and unselected player with an X on top of their face:
    if strcmp(resp, char(thisBlock.Target1Name{1})) % if the peer/player on the left is selected
        % first flip the window, i.e., erase the trial question from before
        Screen('FillRect', w, P.screen.backgroundColor);
        Screen('Flip', w );

        % display all images for the trial, including feedback selected/unselected peer
        Screen('TextSize', w, 300); Screen('TextFont', w, 'Microsoft Sans Serif'); % set the text font & size
        Screen('DrawTexture', w, block1AgentImgTexture, [], block1AgentImgRect);
        Screen('DrawTexture', w, block1Target1ImgTexture, [], block1Target1ImgRect);
        Screen('DrawTexture', w, block1Target2ImgTexture, [], block1Target2ImgRect);
        Screen('FrameRect', w, P.screen.feedbackColor, P.selected.LeftX, 30);
        DrawFormattedText(w, 'X', 'center', 'center', P.screen.feedbackColor,[],[],[],[],[],P.unselected.LeftX);
        Screen('Flip', w );
        fonset = GetSecs; % get feedback onset
        WaitSecs(P.timing.playerselectiondisp); % i.e., 8 seconds 
        foffset = GetSecs; % get feedback offset

    elseif strcmp(resp, char(thisBlock.Target2Name{1})) % if the peer/player on the right is selected
        % first flip the window, i.e., erase the trial question from before
        Screen('FillRect', w, P.screen.backgroundColor);
        Screen('Flip', w );

        % display all images for the trial, including feedback for selected/unselected peer
        Screen('TextSize', w, 300); Screen('TextFont', w, 'Microsoft Sans Serif'); % set the text font & size
        Screen('DrawTexture', w, block1AgentImgTexture, [], block1AgentImgRect);
        Screen('DrawTexture', w, block1Target1ImgTexture, [], block1Target1ImgRect);
        Screen('DrawTexture', w, block1Target2ImgTexture, [], block1Target2ImgRect);
        Screen('FrameRect', w, P.screen.feedbackColor, P.selected.RightX, 30);
        DrawFormattedText(w, 'X', 'center', 'center', P.screen.feedbackColor,[],[],[],[],[],P.unselected.RightX);
        Screen('Flip', w );
        fonset = GetSecs; % get feedback onset
        WaitSecs(P.timing.playerselectiondisp); % i.e., 8 seconds 
        foffset = GetSecs; % get feedback offset

    elseif strcmp(resp, 'NaN') % if participant did not select a player/peer
        % flip the window, i.e., erase the trial question from before
        Screen('FillRect', w, P.screen.backgroundColor);
        Screen('Flip', w );

        % display all images for the trial, without any feedback
        Screen('TextSize', w, 300); Screen('TextFont', w, 'Microsoft Sans Serif');
        Screen('DrawTexture', w, block1AgentImgTexture, [], block1AgentImgRect);
        Screen('DrawTexture', w, block1Target1ImgTexture, [], block1Target1ImgRect);
        Screen('DrawTexture', w, block1Target2ImgTexture, [], block1Target2ImgRect);
        Screen('Flip', w );
        fonset = GetSecs; % get feedback onset
        WaitSecs(P.timing.playerselectiondisp); % i.e., 8 seconds 
        foffset = GetSecs; % get feedback offset
    end

    %%%% save the info;
    indBlckTrial = indBlckTrial+1;
    subjectID(indBlckTrial) = P.subID;
    blockNum(indBlckTrial) = nBlock;
    blockAgent{indBlckTrial} = block1Agent;
    blockPlayer1{indBlckTrial} = block1Target1;
    blockPlayer2{indBlckTrial} = block1Target2;
    trialNumber(indBlckTrial) = indBlckTrial;
    trialTopic{indBlckTrial} = thisTrialTopic;
    trialOnset{indBlckTrial} = tonset - P.timing.triggerStart; %relative to the trigger
    P.timing.trialOnset(indBlckTrial) = tonset; %raw time stamp
    trialOffset{indBlckTrial} = toffset - P.timing.triggerStart; %relative to the trigger
    P.timing.trialOffset(indBlckTrial) = toffset; %raw time stamp
    trialITIj(indBlckTrial) = thisITIj;
    trialRT{indBlckTrial} = thisRT; % calculate & save the response time for this trial
    trialKeyPressed{indBlckTrial} = keyPressed; % save the key participant pressed for this response
    trialPlayerSelected{indBlckTrial} = resp; % save the selection subject makes for the trial
    trialCorrectSelection{indBlckTrial} = resp; % for this block, the correct selection is what subject chooses
    trialFeedbackOnset{indBlckTrial} = fonset - P.timing.triggerStart; %relative to the trigger
    P.timing.trialFeedbackOnset(indBlckTrial) = fonset; %raw time stamp
    trialFeedbackOffset{indBlckTrial} = foffset - P.timing.triggerStart; %relative to the trigger
    P.timing.trialFeedbackOffset(indBlckTrial) = foffset; %raw time stamp

    % keep a black screen for the duration of jittered ITI before the next trial
    Screen('TextSize', w, 40); Screen('TextFont', w, 'Courier New'); % set the text font & size
    textBtwTrials = '---'; Screen('FillRect', w, P.screen.black);
    DrawFormattedText(w, textBtwTrials, P.screen.xCenter, P.screen.yCenter, P.screen.white);
    Screen('Flip', w ); WaitSecs(thisITIj);

    % change back the background color to gray for trials
    Screen('FillRect', w, P.screen.backgroundColor);
    Screen('Flip', w );

end

%%%% BLOCKS 2 & 3
% Notes: For even-numbered subjects; 
% block 2 is where the subject is selected more (10 times), and the other player is selected less (5 times)
% block 3 is where the subject is selected less (5 times), and the other player is selected more (10 times)
% Odd-numbered subjects have the opposite order for the blocks 2 & 3
responseDeadline = P.timing.playerselectiondisp;

for nBlck = 2:3
    if nBlck == 2 % if block2
        nBlock = 2; thisBlock = P.blockInfo(2,:);
        if rem(P.subID,2) == 0 % even
            thisBlckList = P.list3;
        else  % odd
            thisBlckList = P.list2;
        end
    else % if block3
        nBlock = 3; thisBlock = P.blockInfo(3,:);
        if rem(P.subID,2) == 0 % even
            thisBlckList = P.list2;
        else  % odd
            thisBlckList = P.list3;
        end
    end

    %%% 1. PREPARE THE AGENT & TARGETS FOR THIS BLOCK %%%
    % extract the agent for this block:
    thisBlockAgent =  char(thisBlock.AgentName{1});
    blockTarget1 = char(thisBlock.Target1Name{1});
    blockTarget2 = char(thisBlock.Target2Name{1});

    % prepare the agent's image for this block
    blockAgentImage = imread(thisBlock.AgentPicDir{1});
    blockAgentImgRect = CenterRectOnPointd([0 0 P.agentImg.width P.agentImg.height], P.screen.leftCorner, P.screen.lowerCorner);
    blockAgentImgTexture = Screen('MakeTexture', w, blockAgentImage);

    % prepare target images for this block
    % target 1
    blockTarget1Image = imread(thisBlock.Target1PicDir{1});
    blockTarget1ImgRect = CenterRectOnPointd([0 0 P.targetImg.width P.targetImg.height], P.screen.target1LocationX, P.screen.target12LocationY);
    blockTarget1ImgTexture = Screen('MakeTexture', w, blockTarget1Image);

    % target 2
    blockTarget2Image = imread(thisBlock.Target2PicDir{1});
    blockTarget2ImgRect = CenterRectOnPointd([0 0 P.targetImg.width P.targetImg.height], P.screen.target2LocationX, P.screen.target12LocationY);
    blockTarget2ImgTexture = Screen('MakeTexture', w, blockTarget2Image);

    %%% 2. DISPLAY THE AGENT FOR THIS BLOCK %%%
    waitForScanner; % wait for scanner again (out of caution)

    blockOrdPhrase = char(thisBlock.OrderPhrase{1});
    agentBlckRect = CenterRectOnPointd([0 0 P.profileImg.width P.profileImg.height], P.screen.xCenter, (P.screen.yCenter-100));
    agentBlckTexture = Screen('MakeTexture', w, blockAgentImage);
    textBlock = sprintf('%s WAS RANDOMLY CHOSEN TO GO \n%s', thisBlockAgent,blockOrdPhrase);
    Screen('TextSize', w, 40); Screen('TextFont', w, 'Courier New');
    DrawFormattedText(w, textBlock, 'center', P.screen.lowerCorner, P.screen.textColor);
    Screen('DrawTexture', w, agentBlckTexture, [], agentBlckRect);
    Screen('Flip', w);
    WaitSecs(P.timing.trialtextdisp);
    
    % randomize the trial order for this subject for this block
    indTrialRandomized = thisBlckList.TopicNumber(randperm(height(thisBlckList)));

    %%% 3. DISPLAY TRIALS FOR THIS BLOCK %%%
    for indTrial = 1: P.counters.numTrials

        thisTrialTopic = char(thisBlckList.Topic{indTrialRandomized(indTrial)});  % pick the topic for this trial
        thisITIj = thisBlckList.ITIj(indTrialRandomized(indTrial)); % pick the ITI for this trial
        textTrial = sprintf('%s, who would you rather talk to \nabout %s?', thisBlockAgent,thisTrialTopic);

        % display images & question together on the screen
        Screen('TextSize', w, 40); Screen('TextFont', w, 'Courier New'); % set the text font & size
        DrawFormattedText(w, textTrial, 'center', P.screen.lowerCorner, P.screen.textColor);
        Screen('DrawTexture', w, blockAgentImgTexture, [], blockAgentImgRect);
        Screen('DrawTexture', w, blockTarget1ImgTexture, [], blockTarget1ImgRect);
        Screen('DrawTexture', w, blockTarget2ImgTexture, [], blockTarget2ImgRect);
        Screen('Flip', w);
        tonset = GetSecs; % get trial onset
        WaitSecs(P.timing.trialdisp); % I think it should be 4 sec, to match conditions
        toffset = GetSecs; % get trial offset

        % highlight the selected player with a gray box around it, and unselected player with an X on top of their face:
        trialResp = thisBlckList.AgentsChoice(indTrialRandomized(indTrial));
        agentsChoice = whoIsSelected(trialResp, thisBlock); % pre-set for the trial

        if strcmp(agentsChoice, char(thisBlock.Target1Name{1})) % if the peer/player on the left is selected (i.e. the subject)
            % first flip the window, i.e., erase the trial question from before
            Screen('FillRect', w, P.screen.backgroundColor);
            Screen('Flip', w );

            % display all images for the trial, including feedback selected/unselected peer
            Screen('TextSize', w, 300); Screen('TextFont', w, 'Microsoft Sans Serif'); % set the text font & size
            Screen('DrawTexture', w, blockAgentImgTexture, [], blockAgentImgRect);
            Screen('DrawTexture', w, blockTarget1ImgTexture, [], blockTarget1ImgRect);
            Screen('DrawTexture', w, blockTarget2ImgTexture, [], blockTarget2ImgRect);
            Screen('FrameRect', w, P.screen.feedbackColor, P.selected.LeftX, 30);
            DrawFormattedText(w, 'X', 'center', 'center', P.screen.feedbackColor,[],[],[],[],[],P.unselected.LeftX);
            Screen('Flip', w );
            fonset = GetSecs;  % get the feedback onset      
            funcOnset = fonset;
            [P, keyPressed, resp, thisRT, funcOffset] = getResponse(funcOnset, P, k, thisBlock, responseDeadline);
            foffset = funcOffset; % get feedback offset

        elseif strcmp(agentsChoice, char(thisBlock.Target2Name{1})) % if the peer/player on the right is selected (i.e. the other target/player)
            % first flip the window, i.e., erase the trial question from before
            Screen('FillRect', w, P.screen.backgroundColor);
            Screen('Flip', w );

            % display all images for the trial, including feedback for selected/unselected peer
            Screen('TextSize', w, 300); Screen('TextFont', w, 'Microsoft Sans Serif'); % set the text font & size
            Screen('DrawTexture', w, blockAgentImgTexture, [], blockAgentImgRect);
            Screen('DrawTexture', w, blockTarget1ImgTexture, [], blockTarget1ImgRect);
            Screen('DrawTexture', w, blockTarget2ImgTexture, [], blockTarget2ImgRect);
            Screen('FrameRect', w, P.screen.feedbackColor, P.selected.RightX, 30);
            DrawFormattedText(w, 'X', 'center', 'center', P.screen.feedbackColor,[],[],[],[],[],P.unselected.RightX);
            Screen('Flip', w );
            fonset = GetSecs;  % get feedback onset
            funcOnset = fonset;
            [P, keyPressed, resp, thisRT, funcOffset] = getResponse(funcOnset, P, k, thisBlock, responseDeadline);
            foffset = funcOffset; % get feedback offset
        end

        %%%% save the info;
        indBlckTrial = indBlckTrial+1;
        subjectID(indBlckTrial) = P.subID;
        blockNum(indBlckTrial) = nBlock;
        blockAgent{indBlckTrial} = thisBlockAgent;
        blockPlayer1{indBlckTrial} = blockTarget1;
        blockPlayer2{indBlckTrial} = blockTarget2;
        trialNumber(indBlckTrial) = indBlckTrial;
        trialTopic{indBlckTrial} = thisTrialTopic;
        trialOnset{indBlckTrial} = tonset - P.timing.triggerStart; %relative to the trigger
        P.timing.trialOnset(indBlckTrial) = tonset; %raw time stamp
        trialOffset{indBlckTrial} = toffset - P.timing.triggerStart; %relative to the trigger
        P.timing.trialOffset(indBlckTrial) = toffset; %raw time stamp
        trialITIj(indBlckTrial) = thisITIj;
        trialRT{indBlckTrial} = thisRT; % calculate & save the response time for this trial
        trialKeyPressed{indBlckTrial} = keyPressed; % save the key participant pressed for this response
        trialPlayerSelected{indBlckTrial} = resp; % save the selection subject makes for the trial
        trialCorrectSelection{indBlckTrial} = agentsChoice; % pre-set for blocks 2:4
        trialFeedbackOnset{indBlckTrial} = fonset - P.timing.triggerStart; %relative to the trigger
        P.timing.trialFeedbackOnset(indBlckTrial) = fonset; %raw time stamp
        trialFeedbackOffset{indBlckTrial} = foffset - P.timing.triggerStart; %relative to the trigger
        P.timing.trialFeedbackOffset(indBlckTrial) = foffset; %raw time stamp

        % keep a black screen for the duration of jittered ITI before the next trial
        Screen('TextSize', w, 40); Screen('TextFont', w, 'Courier New'); % set the text font & size
        textBtwTrials = '---'; Screen('FillRect', w, P.screen.black);
        DrawFormattedText(w, textBtwTrials, P.screen.xCenter, P.screen.yCenter, P.screen.white);
        Screen('Flip', w ); WaitSecs(thisITIj);

        % change back the background color to gray for trials
        Screen('FillRect', w, P.screen.backgroundColor);
        Screen('Flip', w );
    end
end

%%%% BLOCK 4: Visuo-Motor Control 
nBlock = 4;
% One of the other players (randomized across subjects) should be the "agent" for this block
indAgent = Shuffle(Shuffle(Shuffle(2:3))); thisBlock = P.blockInfo(indAgent(1),:); 
thisBlckList = P.list4;

%%% 1. PREPARE THE AGENT & TARGETS FOR THIS BLOCK %%%
% extract the agent for this block:
thisBlockAgent =  char(thisBlock.AgentName{1});
blockTarget1 = char(thisBlock.Target1Name{1});
blockTarget2 = char(thisBlock.Target2Name{1});

% prepare the agent's image for this block
blockAgentImage = imread(thisBlock.AgentPicDir{1});
blockAgentImgRect = CenterRectOnPointd([0 0 P.agentImg.width P.agentImg.height], P.screen.leftCorner, P.screen.lowerCorner);
blockAgentImgTexture = Screen('MakeTexture', w, blockAgentImage);

% prepare target images for this block
% target 1
blockTarget1Image = imread(thisBlock.Target1PicDir{1});
blockTarget1ImgRect = CenterRectOnPointd([0 0 P.targetImg.width P.targetImg.height], P.screen.target1LocationX, P.screen.target12LocationY);
blockTarget1ImgTexture = Screen('MakeTexture', w, blockTarget1Image);

% target 2
blockTarget2Image = imread(thisBlock.Target2PicDir{1});
blockTarget2ImgRect = CenterRectOnPointd([0 0 P.targetImg.width P.targetImg.height], P.screen.target2LocationX, P.screen.target12LocationY);
blockTarget2ImgTexture = Screen('MakeTexture', w, blockTarget2Image);

%%% 2. DISPLAY THE AGENT FOR THIS BLOCK %%%
waitForScanner; % wait for scanner again (out of caution)

blockOrdPhrase = char(thisBlock.OrderPhrase{1});
agentBlckRect = CenterRectOnPointd([0 0 P.profileImg.width P.profileImg.height], P.screen.xCenter, (P.screen.yCenter-100));
agentBlckTexture = Screen('MakeTexture', w, blockAgentImage);
textBlock = sprintf('%s WAS RANDOMLY CHOSEN TO GO \n%s', thisBlockAgent,blockOrdPhrase);
Screen('TextSize', w, 40); Screen('TextFont', w, 'Courier New');
DrawFormattedText(w, textBlock, 'center', P.screen.lowerCorner, P.screen.textColor);
Screen('DrawTexture', w, agentBlckTexture, [], agentBlckRect);
Screen('Flip', w);
WaitSecs(P.timing.trialtextdisp);

% randomize the trial order for this subject for this block
indTrialRandomized = thisBlckList.TopicNumber(randperm(height(thisBlckList)));

%%% 3. DISPLAY TRIALS FOR THIS BLOCK %%%
for indTrial = 1: P.counters.numTrials

    thisITIj = thisBlckList.ITIj(indTrialRandomized(indTrial)); % pick the ITI for this trial
    textTrial = sprintf('%s, Please press a button on \nthe left or right Standby', thisBlockAgent);

    % display images & question together on the screen
    Screen('TextSize', w, 40); Screen('TextFont', w, 'Courier New'); % set the text font & size
    DrawFormattedText(w, textTrial, 'center', P.screen.lowerCorner, P.screen.textColor);
    Screen('DrawTexture', w, blockAgentImgTexture, [], blockAgentImgRect);
    Screen('DrawTexture', w, blockTarget1ImgTexture, [], blockTarget1ImgRect);
    Screen('DrawTexture', w, blockTarget2ImgTexture, [], blockTarget2ImgRect);
    Screen('Flip', w);
    tonset = GetSecs; % get trial onset
    WaitSecs(P.timing.trialdisp); % i.e., 4 seconds
    toffset = GetSecs; % get trial offset

    % highlight the selected 'target' player with a gray dot ('.') on top of their face:
    trialResp = thisBlckList.DotProbe(indTrialRandomized(indTrial));
    agentsChoice = whoIsSelected(trialResp, thisBlock); % pre-set for the trial

    if strcmp(agentsChoice, char(thisBlock.Target1Name{1})) % if the peer/player on the left is selected (i.e. the subject)
        % first flip the window, i.e., erase the trial question from before
        Screen('FillRect', w, P.screen.backgroundColor);
        Screen('Flip', w );

        % display all images for the trial, including feedback selected/unselected peer
        Screen('TextSize', w, 600); Screen('TextFont', w, 'Microsoft Sans Serif'); % set the text font & size
        Screen('DrawTexture', w, blockAgentImgTexture, [], blockAgentImgRect);
        Screen('DrawTexture', w, blockTarget1ImgTexture, [], blockTarget1ImgRect);
        Screen('DrawTexture', w, blockTarget2ImgTexture, [], blockTarget2ImgRect);
        Screen('FillOval', w, [120 120 120], [(P.screen.target1LocationX-40), (P.screen.target12LocationY-20), (P.screen.target1LocationX+40), (P.screen.target12LocationY+60)])
        Screen('Flip', w );
        fonset = GetSecs;  % get feedback onset
        funcOnset = fonset;
        [P, keyPressed, resp, thisRT, funcOffset] = getResponse(funcOnset, P, k, thisBlock, responseDeadline);
        foffset = funcOffset; % get feedback offset

    elseif strcmp(agentsChoice, char(thisBlock.Target2Name{1})) % if the peer/player on the right is selected (i.e. the other target/player)
        % first flip the window, i.e., erase the trial question from before
        Screen('FillRect', w, P.screen.backgroundColor);
        Screen('Flip', w );

        % display all images for the trial, including feedback for selected/unselected peer
        Screen('TextSize', w, 600); Screen('TextFont', w, 'Microsoft Sans Serif'); % set the text font & size
        Screen('DrawTexture', w, blockAgentImgTexture, [], blockAgentImgRect);
        Screen('DrawTexture', w, blockTarget1ImgTexture, [], blockTarget1ImgRect);
        Screen('DrawTexture', w, blockTarget2ImgTexture, [], blockTarget2ImgRect);
        Screen('FillOval', w, [120 120 120], [(P.screen.target2LocationX-40), (P.screen.target12LocationY-20), (P.screen.target2LocationX+40), (P.screen.target12LocationY+60)])
        Screen('Flip', w );
        fonset = GetSecs;  % get feedback onset
        funcOnset = fonset;
        [P, keyPressed, resp, thisRT, funcOffset] = getResponse(funcOnset, P, k, thisBlock, responseDeadline);
        foffset = funcOffset; % get feedback offset

    end

    %%%% save the info;
    indBlckTrial = indBlckTrial+1;
    subjectID(indBlckTrial) = P.subID;
    blockNum(indBlckTrial) = nBlock;
    blockAgent{indBlckTrial} = thisBlockAgent;
    blockPlayer1{indBlckTrial} = blockTarget1;
    blockPlayer2{indBlckTrial} = blockTarget2;
    trialNumber(indBlckTrial) = indBlckTrial;
    trialTopic{indBlckTrial} = thisTrialTopic;
    trialOnset{indBlckTrial} = tonset - P.timing.triggerStart; %relative to the trigger
    P.timing.trialOnset(indBlckTrial) = tonset; %raw time stamp
    trialOffset{indBlckTrial} = toffset - P.timing.triggerStart; %relative to the trigger
    P.timing.trialOffset(indBlckTrial) = toffset; %raw time stamp
    trialITIj(indBlckTrial) = thisITIj;
    trialRT{indBlckTrial} = thisRT; % calculate & save the response time for this trial
    trialKeyPressed{indBlckTrial} = keyPressed; % save the key participant pressed for this response
    trialPlayerSelected{indBlckTrial} = resp; % save the selection subject makes for the trial
    trialCorrectSelection{indBlckTrial} = agentsChoice; % pre-set for blocks 2:4
    trialFeedbackOnset{indBlckTrial} = fonset - P.timing.triggerStart; %relative to the trigger
    P.timing.trialFeedbackOnset(indBlckTrial) = fonset; %raw time stamp
    trialFeedbackOffset{indBlckTrial} = foffset - P.timing.triggerStart; %relative to the trigger
    P.timing.trialFeedbackOffset(indBlckTrial) = foffset; %raw time stamp

    % keep a black screen for the duration of jittered ITI before the next trial
    Screen('TextSize', w, 40); Screen('TextFont', w, 'Courier New'); % set the text font & size
    textBtwTrials = '---'; Screen('FillRect', w, P.screen.black);
    DrawFormattedText(w, textBtwTrials, P.screen.xCenter, P.screen.yCenter, P.screen.white);
    Screen('Flip', w ); WaitSecs(thisITIj);

    % change back the background color to gray for trials
    Screen('FillRect', w, P.screen.backgroundColor);
    Screen('Flip', w );

end

P.timing.taskEndTime = GetSecs; % record the end time for the entire session

%%%% Get the session info into results table;
T.results = table(subjectID', blockNum, blockAgent', blockPlayer1', blockPlayer2', trialNumber', trialTopic', trialOnset', ...
    trialOffset', trialKeyPressed', trialPlayerSelected', trialCorrectSelection', trialFeedbackOnset', trialFeedbackOffset', trialITIj', trialRT');

T.results.Properties.VariableNames = {'subjectID', 'blockNumber', 'blockAgent', 'blockPlayer1', 'blockPlayer2', 'trialNumber', 'trialTopic', 'trialOnset', ...
    'trialOffset', 'trialKeyPressed', 'trialPlayerSelected', 'trialCorrectSelection', 'trialFeedbackOnset', 'trialFeedbackOffset', 'trialITIj', 'trialRT'};

%% Save Session
P.timing.globalEndTime = GetSecs; % record the end time for the entire session
writetable(T.results, sprintf('%s',outputFile_Trials))

% save all the experimental parameters
save(outputFile_Params, '-struct', 'P');

%% Close the Experimental Session
text = 'Goodbye!';
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor);
Screen('Flip', w); 
WaitSecs(8); % wait for 8 secs -a few TRs before closing the session
Screen('CloseAll');
sca
