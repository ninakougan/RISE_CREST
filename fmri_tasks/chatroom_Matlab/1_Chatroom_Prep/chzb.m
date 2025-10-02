  % RUN Chatroom (Profile) Topic Selection Task
% Code by Busra Tanriverdi,
% Last updated Dec 1st, 2022
% Contact: busra.tanriverdi@temple.edu or cablab@temple.edu

%%%%% !!!!!! IMPORTANT NOTES FOR ANY PROJECT-SPECIFIC EDITS !!!!!! %%%%%
% LINE 17 --> rootDir variable below must match the folder directory. If you don't change this to the directory of your project folder, 
% the task will not work! 

% LINES 111-112 --> The experiment is currently set to be displayed at the maximum monitor number (e.g., if you have 2 monitors, the trials will be
% shown on the 2nd monitor). You can change it to minimum by commenting out the line 112, and removing the "%" sign in front of the line 111. 

%% Initialization    
clear; close all; clc

%% Set directories and structures
rootDir = '/Users/tum99916/Desktop/chatroom_Matlab';
addpath(genpath(fullfile(rootDir)));

dataDir = [rootDir,filesep,'data']; % data directory
prepDir = [rootDir,filesep,'1_Chatroom_Prep']; 
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

% 3. Subject's Age
subAge = inputdlg('Please enter the Subject''s Age:');
T.subAge = str2double(subAge);

% 4. Subject Sex/Gender
genderlist={'male','female'};
subGender = listdlg('PromptString','Please enter Subject''s Sex:', ...
    'SelectionMode','single','ListString',genderlist);  % gets the index for gender
T.subGender = genderlist{subGender};

% 5. Summary of info 
opts.Interpreter = 'tex'; opts.Default = 'Yes';
answer = questdlg({sprintf('Subject: %d',T.subID), ...
    sprintf('Session: %d',T.sesNum), ...
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
outputFile = [subjDir,filesep,'chzb-',num2str(T.subID),'.dat']; % define output file to store results

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
P.screen.red = [250 0 0];
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

% keyboard and keypresses
KbName('UnifyKeyNames'); % unify keyboard for different operating systems
RestrictKeysForKbCheck([]); % no keys restricted from checking

%% Set Experimental Parameters
% set screen position centers for profile text (need 5)
P.screen.posQuest = [0, 0, P.screen.width, 75];

%%% Get Coordinates for profile boxes, to mark clicks on profiles
% divide the remaining screen height to 4 to define upper and lower squares
P.screen.heightAvailableForText = P.screen.height - 200; % calculate the available height for profiles

% also divide the width to 4, but after removing 100 pixels from both sides (to leave sides empty)
P.screen.widthAvailableForText = P.screen.width - 200; % calculate the available width for profiles

% we first create a 400*200 square centering (xCenter, yCenter, and follow from that to create the rest of them
% around it (each are 50 pixels away from the center in each dimension):
P.screen.posRect(1,:) = [(P.screen.xCenter-250), (P.screen.yCenter-100), (P.screen.xCenter+250), (P.screen.yCenter+100)];
P.screen.posRect(2,:) = [(P.screen.xCenter-550), (P.screen.yCenter-350), (P.screen.xCenter-150), (P.screen.yCenter-150)];
P.screen.posRect(3,:) = [(P.screen.xCenter+150), (P.screen.yCenter-350), (P.screen.xCenter+550), (P.screen.yCenter-150)];
P.screen.posRect(4,:) = [(P.screen.xCenter-550), (P.screen.yCenter+150), (P.screen.xCenter-150), (P.screen.yCenter+350)];
P.screen.posRect(5,:) = [(P.screen.xCenter+150), (P.screen.yCenter+150), (P.screen.xCenter+550), (P.screen.yCenter+350)];

% define line coordinates for selected profiles
P.screen.lineCoord(1,:) = [(P.screen.posRect(1,1)-50), P.screen.posRect(1,4), (P.screen.posRect(1,3)+50), P.screen.posRect(1,4)];
P.screen.lineCoord(2,:) = [(P.screen.posRect(2,1)-50), P.screen.posRect(2,4), (P.screen.posRect(2,3)+50), P.screen.posRect(2,4)];
P.screen.lineCoord(3,:) = [(P.screen.posRect(3,1)-50), P.screen.posRect(3,4), (P.screen.posRect(3,3)+50), P.screen.posRect(3,4)];
P.screen.lineCoord(4,:) = [(P.screen.posRect(4,1)-50), P.screen.posRect(4,4), (P.screen.posRect(4,3)+50), P.screen.posRect(4,4)];
P.screen.lineCoord(5,:) = [(P.screen.posRect(5,1)-50), P.screen.posRect(5,4), (P.screen.posRect(5,3)+50), P.screen.posRect(5,4)];        

% set keyboard parameters
P.key.space = KbName('space');

%% import other .dat files (see what's what)
% Note that the below coding corresponds to reading the following files
% cd(rootDir);
% t=importdata('chzbt.dat'); % t : teens (15-17);
% m=importdata('chzbm.dat'); % m : middle (12-14);
% y=importdata('chzby.dat'); % y : youth (9-11);
m = {'Erin';'Competes in Jazz competitions';'Likes talking on the phone';'Wants to be a dancer';
    'Megan';'Sings in the choir';'Likes babysitting';'Wants to be a doctor';
    'Serena';'Plays flute in school band';'Loves animals';'Wants to be a scientist';
    'Molly';'Acts in community plays';'Likes shopping in the mall with friends';'Wants to work with computers';
    'Kathy';'Won poetry writing contest';'Likes reading';'Wants to be a writer';
    'Jake';'Good at skateboarding and dirtbikes';'Likes hanging out with friends';'Wants to become a competitive skateboarder';
    'Jesse';'Won first place at school art show';'Likes to play video games';'Wants to be a photographer';
    'Greg';'Plays football and baseball';'Likes playing sports with friends';'Wants to be a professional football player';
    'Dan';'Won first place at science fair';'Likes biking and hiking';'Wants to be a park ranger';
    'Josh';'President of student council';'Likes to hang out with friends';'Wants to be a lawyer'};

y = {'Cara';'Belongs to the art club';'Likes making jewelry';'Wants to be a teacher';
    'Tiffany';'Plays the clarinet';'Likes playing with her two dogs';'Wants to be a travel agent';
    'Julie';'Plays soccer';'Likes dancing';'Wants to be an actress';
    'Stephanie';'Participates in cheerleading';'Likes baking cookies';'Wants to be a skater';
    'Shawna';'Participates in girl scouts';'Likes acting and singing';'Wants to be a doctor';
    'Michael';'Plays soccer';'Likes playing video games';'Wants to be a policeman';
    'Brandon';'Participates in the math team';'Likes karate';'Wants to be a doctor';
    'Luke';'Plays football';'Likes building model airplanes';'Wants to be a pilot';
    'Erik';'Belongs to environmental club';'Likes drawing';'Wants to be a scientist';
    'Joey';'Plays on an ice hockey team';'Likes reading comic books';'Wants to be a hockey player'};

t = {'Breanne';'Designs jewelry';'Likes to cook for family and friends';'Wants to open a jewelry store';
    'Danielle';'On school dance team';'Likes to shop';'Wants to become a psychologist';
    'Lindsey';'Participates in cheerleading';'Likes to talk on the phone';'Wants to become a teacher';
    'Ashley';'Plays in jazz band';'Likes to design outfits';'Wants to be a model';
    'Chelsea';'On school debate forensics team';'Likes to chat online with friends';'Wants to become a lawyer';
    'Bryan';'JV tennis captain';'Likes to play Xbox Live with friends';'Wants to own and manage a hotel';
    'Steve';'Good at skateboarding';'Likes to hang out with friends';'Wants to be in secret service';
    'Nick';'Acts in school plays';'Likes to watch reality TV';'Wants to own a restaurant';
    'Matt';'Draws cartoons';'Likes to go camping';'Wants to travel to another country';
    'Justin';'Plays varsity hockey';'Likes to ski';'Wants to be a doctor'};

% now select m, t  or y for different age ranges!
if T.subAge >= 9 || T.subAge <= 11 % youth
    profileList = y;

elseif T.subAge >= 12 || T.subAge <= 14 % middle
    profileList = m;

elseif T.subAge >= 15 || T.subAge <= 17 % teens
    profileList = t;

end

%% Extract gender based profiles within the age-defined profileList
% do we want girls/boys language for young adults as well?
if strcmp(T.subGender, 'female')
    profileList = profileList(1:20,1);
    P.textPrompt = 'NOW CHOOSE TWO GIRLS FROM THESE PROFILES';

elseif strcmp(T.subGender, 'male')
    profileList = profileList(21:40,1);
    P.textPrompt = 'NOW CHOOSE TWO BOYS FROM THESE PROFILES';

end

%% get profile indices for 5 separate profiles
profileInd.P1 = 1:4;
profileInd.P2 = 5:8;
profileInd.P3 = 9:12;
profileInd.P4 = 13:16;
profileInd.P5 = 17:20;

% extract the text from profiles at randomized order
indP = randperm(5); pNames = fieldnames(profileInd);
listRandOrd = [profileInd.(pNames{indP(1)}), profileInd.(pNames{indP(2)}),profileInd.(pNames{indP(3)}), profileInd.(pNames{indP(4)}), profileInd.(pNames{indP(5)})];
P.profileListRand = profileList(listRandOrd);

P.textP1 = sprintf('%s \n\n%s \n\n%s \n\n%s',profileList{profileInd.(pNames{indP(1)})(1)}, profileList{profileInd.(pNames{indP(1)})(2)}, ...
    profileList{profileInd.(pNames{indP(1)})(3)},profileList{profileInd.(pNames{indP(1)})(4)});

P.textP2 = sprintf('%s \n\n%s \n\n%s \n\n%s',profileList{profileInd.(pNames{indP(2)})(1)}, profileList{profileInd.(pNames{indP(2)})(2)}, ...
    profileList{profileInd.(pNames{indP(2)})(3)},profileList{profileInd.(pNames{indP(2)})(4)});

P.textP3 = sprintf('%s \n\n%s \n\n%s \n\n%s',profileList{profileInd.(pNames{indP(3)})(1)}, profileList{profileInd.(pNames{indP(3)})(2)}, ...
    profileList{profileInd.(pNames{indP(3)})(3)},profileList{profileInd.(pNames{indP(3)})(4)});

P.textP4 = sprintf('%s \n\n%s \n\n%s \n\n%s',profileList{profileInd.(pNames{indP(4)})(1)}, profileList{profileInd.(pNames{indP(4)})(2)}, ...
    profileList{profileInd.(pNames{indP(4)})(3)},profileList{profileInd.(pNames{indP(4)})(4)});

P.textP5 = sprintf('%s \n\n%s \n\n%s \n\n%s',profileList{profileInd.(pNames{indP(5)})(1)}, profileList{profileInd.(pNames{indP(5)})(2)}, ...
    profileList{profileInd.(pNames{indP(5)})(3)},profileList{profileInd.(pNames{indP(5)})(4)});

%% Display instructions
Screen('TextSize', w, 50);

% instructions page 1
text = ['Welcome back to CHAT CHOICE \n\n'...
    'We have shown your picture and profile \n'...
    'to other kids and have recorded \n'...
    'your choices based on the photographs you \n' ...
    'chose. \n\n'...
    'Press space to continue.'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor);
Screen('Flip', w);
RestrictKeysForKbCheck([P.key.space]); % restrict keys to spacebar only
KbStrokeWait; % wait for a keystroke (of the spacebar)
RestrictKeysForKbCheck([]); % re-enable all keys

% instructions page 2
text = ['Welcome back to Chat Choice \n\n'...
    'We will now show you brief profiles of 5 \n'...
    'boys who matched with you if you are a boy or \n'...
    '5 girls who matched with you if you are a \n' ...
    'girl. \n\n'...
    'Please choose the top two kids you would most \n' ...
    'like to chat with.'];
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor);
Screen('Flip', w);
RestrictKeysForKbCheck([P.key.space]); % restrict keys to spacebar only
KbStrokeWait; % wait for a keystroke (of the spacebar)
RestrictKeysForKbCheck([]); % re-enable all keys

%% Display profiles & collect responses via mouse click
% initiate profile, profileSaved, pos1Clicked, & pos2Clicked for the function selectProfile2
profile = cell(1,2);
P.clickedPos = []; P.clickedLinePos = [];
profileCount = 0; profileSaved = 0; % number of profiles saved/needed

% display the text prompt on top
Screen('TextSize', w, 40); 
DrawFormattedText(w, P.textPrompt, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posQuest);

% display all profiles together, but at randomized locations
Screen('TextSize', w, 20);
DrawFormattedText(w, P.textP1, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posRect(1,:));
DrawFormattedText(w, P.textP2, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posRect(2,:));
DrawFormattedText(w, P.textP3, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posRect(3,:));
DrawFormattedText(w, P.textP4, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posRect(4,:));
DrawFormattedText(w, P.textP5, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posRect(5,:));
Screen('Flip', w);

while profileCount <= 2

    [clicks, xClicked, yClicked, whichButton] = GetClicks(P.screenNumber, 0); %immediately will go to next line once one click happens
    [profile, profileSaved, P] = chzb_selectProfiles(P, profile, profileSaved, xClicked, yClicked, whichButton); % return profile & number of saved profiles
    profileCount = profileSaved; % count of profiles as filled

    % display the text prompt on top
    Screen('TextSize', w, 40); 
    DrawFormattedText(w, P.textPrompt, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posQuest);

    % display all profiles together, but at randomized locations
    Screen('TextSize', w, 20);
    DrawFormattedText(w, P.textP1, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posRect(1,:));
    DrawFormattedText(w, P.textP2, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posRect(2,:));
    DrawFormattedText(w, P.textP3, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posRect(3,:));
    DrawFormattedText(w, P.textP4, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posRect(4,:));
    DrawFormattedText(w, P.textP5, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posRect(5,:));

    if isempty(profile{:,1}) == 1 && isempty(profile{:,2}) == 1 
        Screen('Flip', w);

    elseif isempty(profile{:,1}) == 0 && isempty(profile{:,2}) == 1
        Screen('DrawLine', w, [250, 0, 0], P.clickedLinePos(1,1), P.clickedLinePos(1,2), P.clickedLinePos(1,3), P.clickedLinePos(1,4), 5); Screen('Flip', w);

    elseif isempty(profile{:,1}) == 1 && isempty(profile{:,2}) == 0
        Screen('DrawLine', w, [250, 0, 0], P.clickedLinePos(2,1), P.clickedLinePos(2,2), P.clickedLinePos(2,3), P.clickedLinePos(2,4), 5); Screen('Flip', w);

    elseif isempty(profile{:,1}) == 0 && isempty(profile{:,2}) == 0
        Screen('DrawLine', w, [250, 0, 0], P.clickedLinePos(1,1), P.clickedLinePos(1,2), P.clickedLinePos(1,3), P.clickedLinePos(1,4), 5); 
        Screen('DrawLine', w, [250, 0, 0], P.clickedLinePos(2,1), P.clickedLinePos(2,2), P.clickedLinePos(2,3), P.clickedLinePos(2,4), 5);
        Screen('Flip', w);
    end

    if profileCount == 2
        [clicks, xClicked, yClicked, whichButton] = GetClicks(P.screenNumber, 0); %immediately will go to next line once one click happens

        if clicks % if mouse clicked
            [profile, profileSaved, P] = chzb_selectProfiles(P, profile, profileSaved, xClicked, yClicked, whichButton); % return profile & number of saved profiles
            profileCount = profileSaved; % decrease the count after unselection

            % display the text prompt on top
            Screen('TextSize', w, 40);
            DrawFormattedText(w, P.textPrompt, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posQuest);

            % display all profiles together, but at randomized locations
            Screen('TextSize', w, 20);
            DrawFormattedText(w, P.textP1, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posRect(1,:));
            DrawFormattedText(w, P.textP2, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posRect(2,:));
            DrawFormattedText(w, P.textP3, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posRect(3,:));
            DrawFormattedText(w, P.textP4, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posRect(4,:));
            DrawFormattedText(w, P.textP5, 'center', 'center', P.screen.textColor, [], [], [], [], [], P.screen.posRect(5,:));

            if isempty(profile{:,1}) == 1 && isempty(profile{:,2}) == 1
                Screen('Flip', w);

            elseif isempty(profile{:,1}) == 0 && isempty(profile{:,2}) == 1
                Screen('DrawLine', w, [250, 0, 0], P.clickedLinePos(1,1), P.clickedLinePos(1,2), P.clickedLinePos(1,3), P.clickedLinePos(1,4), 5); Screen('Flip', w);

            elseif isempty(profile{:,1}) == 1 && isempty(profile{:,2}) == 0
                Screen('DrawLine', w, [250, 0, 0], P.clickedLinePos(2,1), P.clickedLinePos(2,2), P.clickedLinePos(2,3), P.clickedLinePos(2,4), 5); Screen('Flip', w);

            elseif isempty(profile{:,1}) == 0 && isempty(profile{:,2}) == 0
                Screen('DrawLine', w, [250, 0, 0], P.clickedLinePos(1,1), P.clickedLinePos(1,2), P.clickedLinePos(1,3), P.clickedLinePos(1,4), 5);
                Screen('DrawLine', w, [250, 0, 0], P.clickedLinePos(2,1), P.clickedLinePos(2,2), P.clickedLinePos(2,3), P.clickedLinePos(2,4), 5);
                Screen('Flip', w);
            end
        end
    end
end

%% Save profile selection
% merge the profiles into a list
T.selectedProfiles = vertcat(profile{:,1},profile{:,2});

% save them into subject's .dat file
cd(subjDir)
writecell(T.selectedProfiles, sprintf('chzb-%d.dat',T.subID))

%% Close the experiment 
text = 'Goodbye!';
DrawFormattedText(w, text, 'center', 'center', P.screen.textColor);
Screen('Flip', w); WaitSecs(0.5);
Screen('CloseAll');
sca