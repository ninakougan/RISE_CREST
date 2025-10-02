% RUN Chatroom PracticeTask
% Code by Busra Tanriverdi,
% Last updated Sep 23rd, 2022
% Contact: busra.tanriverdi@temple.edu

%%%%% !!!!!! IMPORTANT NOTES FOR ANY PROJECT-SPECIFIC EDITS !!!!!! %%%%%
% LINE 25 --> rootDir variable below must match the folder directory. If you don't change this to the directory of your project folder, 
% the task will not work! 

% LINES 44-45 --> The experiment is currently set to be displayed at the maximum monitor number (e.g., if you have 2 monitors, the trials will be
% shown on the 2nd monitor). You can change it to minimum by commenting out the line 45, and removing the "%" sign in front of the line 44. 

%% Initialization
clear; close all; clc

% check system & define keyboard number - important for Mac/Windows compatibility !!! DO NOT delete or edit this !!!
if ismac
    k = GetKeyboardIndices;
    deviceNumber = PsychHID('Devices');
else
    k = 0;
end

%% Set directories and structures
rootDir = '/Users/tum99916/Desktop/chatroom_Matlab/2_Chatroom_Practice'; 
addpath(genpath(fullfile(rootDir)));
practiceDir = [rootDir,filesep,'stimuli']; 

ListenChar(2); % make sure MATLAB is listening to the keyboard inputs

%% Collect subject ID, gender & session info 
% I don't think we need to collect all of these for practice, we only need
% gender, but keeping it for now.
% 1. Subject Sex/Gender
genderlist={'male','female'};
subGender = listdlg('PromptString','Please enter Subject''s Sex:', ...
    'SelectionMode','single','ListString',genderlist);  % gets the index for gender
T.subGender = genderlist{subGender};

%% Set Screen parameters
% open display
clear Screen % remove any previously opened screens
P.screens = Screen('Screens'); % get screen numbers
%P.screenNumber = min(P.screens); % keep the first screen if multiple exist
P.screenNumber = max(P.screens); % keep the last screen if multiple exist
Screen('Preference', 'SkipSyncTests', 1); % skip sync tests

[w, P.rect] = Screen('OpenWindow', P.screenNumber, [], []); % get screen coordinates

P.screen.width  = P.rect(RectRight); 
P.screen.height = P.rect(RectBottom);
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

% set screen parameters for experimental trials
P.screen.xTextCenter = P.screen.xCenter - P.screen.xCenter/2;
P.screen.leftCenter = P.screen.xCenter/2;
P.screen.rightCenter = P.screen.xCenter + P.screen.xCenter/2;
P.screen.upperCenter = P.screen.height - 3/2 * P.screen.yCenter;
P.screen.lowerCenter = P.screen.height - 1/2 * P.screen.yCenter;
P.screen.profileTextCenter = P.screen.xCenter - P.screen.leftCenter/2; % for displayPlayers.m

% get coordinates for the player image on left lower corner
P.screen.lowerCorner = P.screen.height - 1/3 * P.screen.yCenter;
P.screen.leftCorner = 1/3 * P.screen.leftCenter; 

% profile center points
P.screen.target1LocationX = (P.screen.xCenter/2 * 4/3);
P.screen.target2LocationX = ((P.screen.xCenter/2) * 5/2) + 120;
P.screen.target12LocationY = P.screen.target1LocationX - 100; % seems similar enough, & both should share the same location

% open first screen; set parameters for on-screen background and font
% setup alpha blending for smoothed (anti-aliased) lines
Screen(w, 'BlendFunction', GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% fill screen with background color
Screen('FillRect', w, P.screen.backgroundColor);
Screen('Flip', w);

% set text font
Screen('TextSize', w, 50);
Screen('TextFont', w, 'Courier New');

% keyboard and keypresses
KbName('UnifyKeyNames'); % unify keyboard for different operating systems
RestrictKeysForKbCheck([]); % no keys restricted from checking

%% Set Experimental Parameters
%%% Time parameters:
P.timing.trialtextdisp = 2; % trial text display time
P.timing.playerselectiondisp = 6; % duration for the selected player display
P.timing.profiledisp = 3; % profile display time- before the experiment
P.timing.trialdisp = 3; % trial duration 

%%% Counters parameters:
P.counters.numBlocks = 4; % FOR PILOT1, SUBJECT TO CHANGE!
P.counters.numLists = 3; % FOR NOW, SUBJECT TO CHANGE!
P.counters.numTrials = 3; % FOR NOW, SUBJECT TO CHANGE! 
P.counters.nAllTrials = P.counters.numBlocks * P.counters.numTrials;

%%% Stimulus image size-related parameters
P.buttonboxImg.width = 2/3 * P.screen.width; % subject to change
P.buttonboxImg.height = 2/3 * P.screen.height; % subject to change
 
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

%%% Stimulus selection (feedback) parameters
% calculate the coordinates for the box around selected player
P.selected.LeftX = [(P.screen.target1LocationX - P.targetImg.width/2 -30), (P.screen.target12LocationY - P.targetImg.height/2 -30), ...
    ((P.screen.target1LocationX - P.targetImg.width/2) + P.targetImg.width +30), (P.screen.target12LocationY + P.targetImg.height/2 +30)];
P.selected.RightX = [(P.screen.target2LocationX - P.targetImg.width/2 -30), (P.screen.target12LocationY - P.targetImg.height/2 -30), ...
    ((P.screen.target2LocationX - P.targetImg.width/2) + P.targetImg.width +30), (P.screen.target12LocationY + P.targetImg.height/2 +30)];

% calculate coordinates for X for unselected player
P.unselected.LeftX = [(P.screen.target1LocationX - 150), P.screen.target12LocationY + 150];
P.unselected.RightX = [(P.screen.target2LocationX - 150), P.screen.target12LocationY + 150];

%%% Restrict keys for KbCheck
P.key.equal = '='; 
P.key.space = 'space';
P.key.resp1 = '1'; 
P.key.resp2 = '2'; 
P.key.resp6 = '6'; 
P.key.resp7 = '7'; 

%% Prepare stimuli
%%% Visual stimuli (example images)
P.stimuli.Stimuli = dir(practiceDir);
P.stimuli.Names = {'BEYONCE','CHRIS','TAYLOR','SELENA','STEPH','DRAKE'};
P.stimuli.Gender = {'female','male','female','female','male','male'};

% load image directory information
for nCeleb = 1: length(P.stimuli.Names)
    celebImgs = P.stimuli.Stimuli(contains({P.stimuli.Stimuli.name}, P.stimuli.Names(nCeleb)),:);

    number(nCeleb,1)= nCeleb;
    baseFileName{nCeleb,1} = celebImgs.name;
    fullFileName{nCeleb,1} = fullfile(practiceDir, baseFileName{nCeleb,1});
    name{nCeleb,1} = celebImgs.name(1:end-4);
    gender{nCeleb,1} = P.stimuli.Gender{nCeleb};

end

P.stimuli.Celebs = table(number, name, gender, baseFileName, fullFileName); 
P.stimuli.Celebs.Properties.VariableNames = {'number', 'name', 'gender', 'baseFileName', 'fullFileName'};

clear number gender baseFileName fullFileName name celebImgs;

%%% Read the 'button box' images
P.stimuli.buttonboxLeft = P.stimuli.Stimuli(contains({P.stimuli.Stimuli.name}, 'Leftbuttonbox'),:);
P.stimuli.buttonboxLeft.fullFileName = fullfile(practiceDir, P.stimuli.buttonboxLeft.name);

P.stimuli.buttonboxRight = P.stimuli.Stimuli(contains({P.stimuli.Stimuli.name}, 'Rightbuttonbox'),:);
P.stimuli.buttonboxRight.fullFileName = fullfile(practiceDir, P.stimuli.buttonboxRight.name);

%%% Textual stimuli
smale = {'Chris'; 'On the track team'; 'Likes to text message with friends'; 'Wants to be an interior decorator'};
sfemale = {'Beyonce'; 'On the swim team'; 'Likes to text message with friends'; 'Wants to be an interior decorator'};

chzbmale = {'Steph';'Plays on his school basketball team';'Likes playing Wii bowling';'Wants to go to water skiing'; ...
    'Drake';'Belongs to environmental club';'Likes rapping';'Wants to see the pyramids of Egypt'};

chzbfemale = {'Taylor';'Plays soccer';'Likes dancing';'Wants to be an actress'; ...
    'Selena';'Plays the clarinet and bongos';'Likes playing with her two dogs';'Wants to go to Australia'};


%% Assign profiles based on gender 
if strcmp(T.subGender, 'female')
    subject = sfemale; profile1 = chzbfemale(1:4); profile2 = chzbfemale(5:8);

elseif strcmp(T.subGender, 'male')
    subject = smale; profile1 = chzbmale(1:4); profile2 = chzbmale(5:8);

end

%% Prepare blocks 
%%% Topic Lists 
% There are 3 lists for 3 experimental blocks 
% The same list is used for each block. (Do jitters change? CHECK!!!)
topics = {'SCHOOL'; 'PARTIES'; 'VACATIONS';'HOBBIES';'MUSIC';'TV';'MOVIES'; ...
    'FOOD';'SHOPPING';'COMPUTERS';'PETS';'BOOKS';'FRIENDS';'FAMILY';'SPORTS'};
topicsNum = (1:15)';

% List1 for Block 1 (ListT in old code)
P.list1 = table(topicsNum, topics);
P.list1.Properties.VariableNames = {'TopicNumber', 'Topic'};

% List2 for the block where subject is selected less
subjSelectedLess = [1 0 1 0 1 1 0 1 0 0 0 0 0 0 0];
P.list2 = [table(topicsNum, Shuffle(topics)), table(subjSelectedLess')];
P.list2.Properties.VariableNames = {'TopicNumber', 'Topic', 'AgentsChoice'};

% List 3 for the block where subject is selected more
subjSelectedMore = [0 1 0 1 0 0 0 1 1 1 1 1 1 1 1];
P.list3 = [table(topicsNum, Shuffle(topics)), table(subjSelectedMore')];
P.list3.Properties.VariableNames = {'TopicNumber', 'Topic','AgentsChoice'};

% List 4 for the block, i.e., the visuo-motor control block
list4subjSelection = [1 0 0 1 1 0 0 0 0 0 1 1 0 1 1];
P.list4 = [P.list1, table(list4subjSelection')];
P.list4.Properties.VariableNames = {'TopicNumber', 'Topic', 'DotProbe'};

%%% Create block information
blockNum = (1:3)'; ordPhrase = {'FIRST';'NEXT';'NEXT'}; 
celebStim = P.stimuli.Celebs(strcmp(P.stimuli.Celebs.gender, T.subGender),:);

% Get profile names based on this subject's info & preferences
agentName = {char(celebStim.name(1));char(celebStim.name(2));char(celebStim.name(3))}; 
target1Name = {char(celebStim.name(2));char(celebStim.name(3));char(celebStim.name(1))}; 
target2Name = {char(celebStim.name(3));char(celebStim.name(1));char(celebStim.name(2))}; 

% Get picture names based on this subject's info & preferences
agentPic = {char(celebStim.baseFileName(1));char(celebStim.baseFileName(2));char(celebStim.baseFileName(3))};
target1Pic = {char(celebStim.baseFileName(2));char(celebStim.baseFileName(3));char(celebStim.baseFileName(1))};
target2Pic = {char(celebStim.baseFileName(3));char(celebStim.baseFileName(1));char(celebStim.baseFileName(2))};

% Get picture fullfile names based on agent & target names
agentPicDir = {char(celebStim.fullFileName(1));char(celebStim.fullFileName(2));char(celebStim.fullFileName(3))};
target1PicDir = {char(celebStim.fullFileName(2));char(celebStim.fullFileName(3));char(celebStim.fullFileName(1))};
target2PicDir = {char(celebStim.fullFileName(3));char(celebStim.fullFileName(1));char(celebStim.fullFileName(2))};

P.blockInfo = table(blockNum, agentPic, agentName, agentPicDir, target1Pic, target1Name, target1PicDir, target2Pic, target2Name, target2PicDir, ordPhrase);
P.blockInfo.Properties.VariableNames = {'BlockNumber', 'AgentPic', 'AgentName', 'AgentPicDir', 'Target1Pic', 'Target1Name', ...
    'Target1PicDir', 'Target2Pic', 'Target2Name', 'Target2PicDir', 'OrderPhrase'};

%% Display instructions:
%%%%% 1
text = ['Chat Choose 1 \n\n'...
    'We will match you with other teens based on \n'...
    'the choices you just made and the choices the \n'...
    'other teens make. \n\n' ...
    'You will now play the game. \n'...
    'The first 3 rounds are with you and \n'...
    'two other teens.'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor);
Screen('Flip', w);
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
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor);
Screen('Flip', w);
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
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor);
Screen('Flip', w);
KbStrokeWait(); % wait for a keystroke from subject 

%%%%% 4
text = ['Chat Choose 4 \n\n'...
    'If it is NOT your turn to choose, please \n'...
    'indicate whether the person on the left \n'...
    '(Press the left button) or right (Press the \n'...
    'right button) was chosen on each question.'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor);
Screen('Flip', w);
KbStrokeWait(); % wait for a keystroke from subject 

%%%%% Left button (for right handed subjects)
% prepare the image
leftBBImage = imread(char(P.stimuli.buttonboxLeft.fullFileName));
leftBBRect = CenterRectOnPointd([0 0 P.buttonboxImg.width P.buttonboxImg.height], P.screen.xCenter, P.screen.yCenter);
leftBBTexture = Screen('MakeTexture', w, leftBBImage);

% show the image
Screen('DrawTexture', w, leftBBTexture, [], leftBBRect);
Screen('Flip', w);
KbStrokeWait(); % wait for a keystroke from subject

%%%%% Right button (for left handed subjects)
% prepare the image
rightBBImage = imread(char(P.stimuli.buttonboxRight.fullFileName));
rightBBRect = CenterRectOnPointd([0 0 P.buttonboxImg.width P.buttonboxImg.height], P.screen.xCenter, P.screen.yCenter);
rightBBTexture = Screen('MakeTexture', w, rightBBImage);

% show the image
Screen('DrawTexture', w, rightBBTexture, [], rightBBRect);
Screen('Flip', w);
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
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor);
Screen('Flip', w);
KbStrokeWait(); % wait for a keystroke from subject 

%%%%% 6
text = ['Chat Choose 6 \n\n'...
    'You will be asked to press a button to show \n'...
    'which side of the screen the dot is on. You \n'...
    'should press the left button if the dot is on \n'...
    'the left, and the right button if the dot is \n'...
    'on the right.'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor);
Screen('Flip', w);
KbStrokeWait(); % wait for a keystroke from subject 

%%%%% 7
text = ['Let''s start the Practice Game! \n\n'...
    'Now you will do a practice version of the \n'...
    'game with celebrities, instead of with real people \n'...
    'This is just to help you understand the actual game \n'...
    'you will be doing in the scanner \n'...
    'with other teens.'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor);
Screen('Flip', w);
KbStrokeWait(); % wait for a keystroke from subject 

%%%%% 8
text = ['Do you have any questions? \n\n'...
    'Next you will see the celebrity profiles and \n'...
    'then it will automatically start \n'...
    'the practice.'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor);
Screen('Flip', w);
KbStrokeWait(); % wait for a keystroke from subject


%% Display players
Screen('TextSize', w, 40); % smaller text size for profiles appear better

%%% 1. Subject themselves 
% prepare stimulus for this trial
subImage = imread(char(agentPicDir(1)));

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

%%% Profile-1
% Profile-1's photo from the bmpsm directory on the left & text on the right:
profile1Image = imread(char(agentPicDir(2))); 

% center the image on the left, and text on the right
profile1ImgRect = CenterRectOnPointd([0 0 P.profileImg.width P.profileImg.height], (P.screen.leftCenter-100), P.screen.yCenter);
profile1ImgTexture = Screen('MakeTexture', w, profile1Image);

% profile text
profile1_txt = sprintf('%s \n\n%s \n\n%s \n\n%s',profile1{1},profile1{2},profile1{3},profile1{4});

%%%% show stimulus together with the profile's text
DrawFormattedText(w, profile1_txt, P.screen.profileTextCenter, 'center', P.screen.textColor);
Screen('DrawTexture', w, profile1ImgTexture, [], profile1ImgRect);
Screen('Flip', w);
WaitSecs(P.timing.profiledisp); 

%%% Profile-2
% Profile-2's photo from the bmpsm directory on the left & text on the right:
profile2Image = imread(char(agentPicDir(3)));

% center the image on the left, and text on the right
profile2ImgRect = CenterRectOnPointd([0 0 P.profileImg.width P.profileImg.height], (P.screen.leftCenter-100), P.screen.yCenter);
profile2ImgTexture = Screen('MakeTexture', w, profile2Image);

% profile text
profile2_txt = sprintf('%s \n\n%s \n\n%s \n\n%s',profile2{1},profile2{2},profile2{3},profile2{4});

%%%% show stimulus together with the profile's text
DrawFormattedText(w, profile2_txt, P.screen.profileTextCenter, 'center', P.screen.textColor);
Screen('DrawTexture', w, profile2ImgTexture, [], profile2ImgRect);
Screen('Flip', w);
WaitSecs(P.timing.profiledisp); 


%% Display Trials
%%% Block 1
thisBlock = P.blockInfo(1,:); thisBlckList = P.list1;
responseDeadline = P.timing.trialdisp;

% extract the agent for this block:
block1Agent =  char(thisBlock.AgentName{1});
block1Target1 = char(thisBlock.Target1Name{1});
block1Target2 = char(thisBlock.Target2Name{1});

% prepare the agent's image for this block
block1AgentImage = imread(thisBlock.AgentPicDir{1});
block1AgentImgRect = CenterRectOnPointd([0 0 P.agentImg.width P.agentImg.height], P.screen.leftCorner, P.screen.lowerCorner);
block1AgentImgTexture = Screen('MakeTexture', w, block1AgentImage);

% prepare target images for this block
% target 1
block1Target1Image = imread(thisBlock.Target1PicDir{1}); 
block1Target1ImgRect = CenterRectOnPointd([0 0 P.targetImg.width P.targetImg.height], P.screen.target1LocationX, P.screen.target12LocationY);
block1Target1ImgTexture = Screen('MakeTexture', w, block1Target1Image);

% target 2
block1Target2Image = imread(thisBlock.Target2PicDir{1});
block1Target2ImgRect = CenterRectOnPointd([0 0 P.targetImg.width P.targetImg.height], P.screen.target2LocationX, P.screen.target12LocationY);
block1Target2ImgTexture = Screen('MakeTexture', w, block1Target2Image);

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

for indTrial = 1: P.counters.numTrials

    thisTrialTopic = char(thisBlckList.Topic{indTrial});  % pick the topic for this trial
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
    [P, resp, thisRT, funcOffset] = getResponse(funcOnset, P, k, thisBlock, responseDeadline);
    toffset = funcOffset; % get trial offset

    % highlight the selected player with a gray box around it, and unselected player with an X on top of their face:
    if strcmp(resp, char(thisBlock.Target1Name{1})) % if the peer/player on the left is selected
        % first flip the window, i.e., erase the trial question from before
        Screen('FillRect', w, P.screen.backgroundColor);
        Screen('Flip', w );

        % display all images for the trial, including feedback selected/unselected peer
        Screen('TextSize', w, 500); Screen('TextFont', w, 'Microsoft Sans Serif'); % set the text font & size
        Screen('DrawTexture', w, block1AgentImgTexture, [], block1AgentImgRect);
        Screen('DrawTexture', w, block1Target1ImgTexture, [], block1Target1ImgRect);
        Screen('DrawTexture', w, block1Target2ImgTexture, [], block1Target2ImgRect);
        Screen('FrameRect', w, P.screen.feedbackColor, P.selected.LeftX, 30);
        DrawFormattedText(w, 'X', P.unselected.RightX(1), P.unselected.RightX(2), P.screen.feedbackColor);
        Screen('Flip', w );
        fonset = GetSecs; % get feedback onset
        WaitSecs(P.timing.playerselectiondisp); % i.e., 8 seconds 
        foffset = GetSecs; % get feedback offset

    elseif strcmp(resp, char(thisBlock.Target2Name{1})) % if the peer/player on the right is selected
        % first flip the window, i.e., erase the trial question from before
        Screen('FillRect', w, P.screen.backgroundColor);
        Screen('Flip', w );

        % display all images for the trial, including feedback for selected/unselected peer
        Screen('TextSize', w, 500); Screen('TextFont', w, 'Microsoft Sans Serif'); % set the text font & size
        Screen('DrawTexture', w, block1AgentImgTexture, [], block1AgentImgRect);
        Screen('DrawTexture', w, block1Target1ImgTexture, [], block1Target1ImgRect);
        Screen('DrawTexture', w, block1Target2ImgTexture, [], block1Target2ImgRect);
        Screen('FrameRect', w, P.screen.feedbackColor, P.selected.RightX, 30);
        DrawFormattedText(w, 'X', P.unselected.LeftX(1), P.unselected.LeftX(2), P.screen.feedbackColor);
        Screen('Flip', w );
        fonset = GetSecs; % get feedback onset
        WaitSecs(P.timing.playerselectiondisp); % i.e., 8 seconds 
        foffset = GetSecs; % get feedback offset

    elseif strcmp(resp, 'NaN') % if participant did not select a player/peer
        % flip the window, i.e., erase the trial question from before
        Screen('FillRect', w, P.screen.backgroundColor);
        Screen('Flip', w );

        % display all images for the trial, without any feedback
        Screen('TextSize', w, 500); Screen('TextFont', w, 'Microsoft Sans Serif');
        Screen('DrawTexture', w, block1AgentImgTexture, [], block1AgentImgRect);
        Screen('DrawTexture', w, block1Target1ImgTexture, [], block1Target1ImgRect);
        Screen('DrawTexture', w, block1Target2ImgTexture, [], block1Target2ImgRect);
        Screen('Flip', w );
        fonset = GetSecs; % get feedback onset
        WaitSecs(P.timing.playerselectiondisp); % i.e., 8 seconds 
        foffset = GetSecs; % get feedback offset
    end

    % keep a black screen for the duration of 500 ms before the next trial
    Screen('TextSize', w, 40); Screen('TextFont', w, 'Courier New'); % set the text font & size
    textBtwTrials = '---'; Screen('FillRect', w, P.screen.black);
    DrawFormattedText(w, textBtwTrials, P.screen.xCenter, P.screen.yCenter, P.screen.white);
    Screen('Flip', w ); WaitSecs(0.5);

    % change back the background color to gray for trials
    Screen('FillRect', w, P.screen.backgroundColor);
    Screen('Flip', w );

end


%%% Blocks 2 & 3
responseDeadline = P.timing.playerselectiondisp;

for nBlck = 2:3
    if nBlck == 2 % if block2
        thisBlock = P.blockInfo(2,:); thisBlckList = P.list2;
    else % if block3
        thisBlock = P.blockInfo(3,:); thisBlckList = P.list3;
    end

    %%% 1. PREPARE THE AGENT & TARGETS FOR THIS BLOCK %%%
    % extract the agent for this block:
    thisBlockAgent =  char(thisBlock.AgentName{1});

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
    blockOrdPhrase = char(thisBlock.OrderPhrase{1});
    agentBlckRect = CenterRectOnPointd([0 0 P.profileImg.width P.profileImg.height], P.screen.xCenter, (P.screen.yCenter-100));
    agentBlckTexture = Screen('MakeTexture', w, blockAgentImage);
    textBlock = sprintf('%s WAS RANDOMLY CHOSEN TO GO \n%s', thisBlockAgent,blockOrdPhrase);
    Screen('TextSize', w, 40); Screen('TextFont', w, 'Courier New');
    DrawFormattedText(w, textBlock, 'center', P.screen.lowerCorner, P.screen.textColor);
    Screen('DrawTexture', w, agentBlckTexture, [], agentBlckRect);
    Screen('Flip', w);
    WaitSecs(P.timing.trialtextdisp);
    
    %%% 3. DISPLAY TRIALS FOR THIS BLOCK %%%
    for indTrial = 1: 3 

        thisTrialTopic = char(thisBlckList.Topic{(indTrial)});  % pick the topic for this trial
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
        trialResp = thisBlckList.AgentsChoice(indTrial);
        agentsChoice = whoIsSelected(trialResp, thisBlock); % pre-set for the trial

        if strcmp(agentsChoice, char(thisBlock.Target1Name{1})) % if the peer/player on the left is selected (i.e. the subject)
            % first flip the window, i.e., erase the trial question from before
            Screen('FillRect', w, P.screen.backgroundColor);
            Screen('Flip', w );

            % display all images for the trial, including feedback selected/unselected peer
            Screen('TextSize', w, 500); Screen('TextFont', w, 'Microsoft Sans Serif'); % set the text font & size
            Screen('DrawTexture', w, blockAgentImgTexture, [], blockAgentImgRect);
            Screen('DrawTexture', w, blockTarget1ImgTexture, [], blockTarget1ImgRect);
            Screen('DrawTexture', w, blockTarget2ImgTexture, [], blockTarget2ImgRect);
            Screen('FrameRect', w, P.screen.feedbackColor, P.selected.LeftX, 30);
            DrawFormattedText(w, 'X', P.unselected.RightX(1), P.unselected.RightX(2), P.screen.feedbackColor);
            Screen('Flip', w );
            fonset = GetSecs;  % get the feedback onset      
            funcOnset = fonset;
            [P, resp, thisRT, funcOffset] = getResponse(funcOnset, P, k, thisBlock, responseDeadline);
            foffset = funcOffset; % get feedback offset

        elseif strcmp(agentsChoice, char(thisBlock.Target2Name{1})) % if the peer/player on the right is selected (i.e. the other target/player)
            % first flip the window, i.e., erase the trial question from before
            Screen('FillRect', w, P.screen.backgroundColor);
            Screen('Flip', w );

            % display all images for the trial, including feedback for selected/unselected peer
            Screen('TextSize', w, 500); Screen('TextFont', w, 'Microsoft Sans Serif'); % set the text font & size
            Screen('DrawTexture', w, blockAgentImgTexture, [], blockAgentImgRect);
            Screen('DrawTexture', w, blockTarget1ImgTexture, [], blockTarget1ImgRect);
            Screen('DrawTexture', w, blockTarget2ImgTexture, [], blockTarget2ImgRect);
            Screen('FrameRect', w, P.screen.feedbackColor, P.selected.RightX, 30);
            DrawFormattedText(w, 'X', P.unselected.LeftX(1), P.unselected.LeftX(2), P.screen.feedbackColor);
            Screen('Flip', w );
            fonset = GetSecs;  % get feedback onset
            funcOnset = fonset;
            [P, resp, thisRT, funcOffset] = getResponse(funcOnset, P, k, thisBlock, responseDeadline);
            foffset = funcOffset; % get feedback offset
        end

        % keep a black screen for the duration of 500 ms before the next trial
        Screen('TextSize', w, 40); Screen('TextFont', w, 'Courier New'); % set the text font & size
        textBtwTrials = '---'; Screen('FillRect', w, P.screen.black);
        DrawFormattedText(w, textBtwTrials, P.screen.xCenter, P.screen.yCenter, P.screen.white);
        Screen('Flip', w ); WaitSecs(0.5);

        % change back the background color to gray for trials
        Screen('FillRect', w, P.screen.backgroundColor);
        Screen('Flip', w );

    end
end

%%% Block 4: Visuo-Motor Control 
thisBlock = P.blockInfo(2,:);
thisBlckList = P.list4;

%%% 1. PREPARE THE AGENT & TARGETS FOR THIS BLOCK's TRIALS %%%
% extract the agent for this block:
thisBlockAgent =  char(thisBlock.AgentName{1});

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

% display who 'plays' (selects) in this block:
agentBlck1Rect = CenterRectOnPointd([0 0 P.profileImg.width P.profileImg.height], P.screen.xCenter, (P.screen.yCenter-100));
textBlock1 = sprintf('%s WAS RANDOMLY CHOSEN TO GO NEXT', thisBlockAgent);

Screen('TextSize', w, 40); Screen('TextFont', w, 'Courier New'); % set the text font & size
DrawFormattedText(w, textBlock1, 'center', P.screen.lowerCorner, P.screen.textColor);
Screen('DrawTexture', w, blockAgentImgTexture, [], agentBlck1Rect);
Screen('Flip', w);
WaitSecs(P.timing.trialtextdisp);


%%% 3. DISPLAY TRIALS FOR THIS BLOCK %%%
for indTrial = 1: 3 

    thisTrialTopic = char('STANDBY');  % pick the topic for this trial
    textTrial = sprintf('%s, please press a button on \nthe left or right. %s', thisBlockAgent, thisTrialTopic);

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
    trialResp = thisBlckList.DotProbe(indTrial);
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
        [P, resp, thisRT, funcOffset] = getResponse(funcOnset, P, k, thisBlock, responseDeadline);
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
        [P, resp, thisRT, funcOffset] = getResponse(funcOnset, P, k, thisBlock, responseDeadline);
        foffset = funcOffset; % get feedback offset

    end

    % keep a black screen for the duration of 500 ms before the next trial
    Screen('TextSize', w, 40); Screen('TextFont', w, 'Courier New'); % set the text font & size
    textBtwTrials = '---'; Screen('FillRect', w, P.screen.black);
    DrawFormattedText(w, textBtwTrials, P.screen.xCenter, P.screen.yCenter, P.screen.white);
    Screen('Flip', w ); WaitSecs(0.5);

    % change back the background color to gray for trials
    Screen('FillRect', w, P.screen.backgroundColor);
    Screen('Flip', w );

end

%% Close the experiment
text = 'Goodbye!';
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor);
Screen('Flip', w); WaitSecs(0.5);
Screen('CloseAll');
sca;
