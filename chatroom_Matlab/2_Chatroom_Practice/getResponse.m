function [P, resp, thisRT, funcOffset] = getResponse(funcOnset, P, k, thisBlock,responseDeadline)
% Code by Busra Tanriverdi
% Last updated Oct 6th, 2022
% Contact: busra.tanriverdi@temple.edu

% Collects keypresses for a given duration. Note that in this version, the given
% duration is trial duration, which is set with the "P.timing.trialdisp"
% variable (because we save parameters in a P struct). You must change it as you need.

% funcOnset: Time when the function is called 
% P: structure with all necessary information about keys 
% k: deviceNumber; If using OSX, you MUST provide a deviceNumber.I f using Windows, 
% you do not need to provide a deviceNumber -- if you do, it will be ignored.
% thisBlock: a table for the block information, including durations
% responseDeadline: Duration in seconds; set within the function based on the block condition.

% Using deviceNumber:
% KbCheck only collects from the first key input device found. On a laptop,
% this is usually the laptop keyboard. However, often you'll want to collect
% from another device, like the buttonbox in the scanner! You MUST specify
% the device number, or none of the input from the buttonbox will be
% collected. Device numbers change according to what order the USB devices
% were plugged in, and you may find that you can only perform this check
% ONCE using the command d=PsychHID('Devices'); so DO NOT change the device
% arrangement (which port each is plugged into) after performing the check.
% Restarting Matlab will allow you to use d=PsychHID('Devices') again
% successfully.
% On Windows, KbCheck records simultaneously from all keyboards -- you
% cannot specify.

resp = [];
thisRT = [];

% Don't start until keys are released
if IsOSX
    if ~exist('k','var')
        fprintf('You are using OSX and you MUST provide a deviceNumber(k)! Or key presses will fail.\n');
    end
    while KbCheck(k)
        if (GetSecs-funcOnset)>responseDeadline
            resp = 'NaN';
            thisRT = 'NaN';
            funcOffset = GetSecs; % get function offset
            break;
        end
    end
else
    while KbCheck % no deviceNumber for Windows
        if (GetSecs-funcOnset)>responseDeadline
            resp = 'NaN';
            thisRT = 'NaN';
            funcOffset = GetSecs; % get function offset
            break;
        end
    end
end

% Now check for keys
while 1
    if IsOSX
        [keyIsDown,secs,keyCode] = KbCheck(k);
    else
        [keyIsDown,secs,keyCode] = KbCheck; % no deviceNumber(k) for Windows
    end
    if keyIsDown
        %resp = getResp(keyCode, P, thisBlock); % get the selected player for this trial
        if any(ismember(P.key.resp1, KbName(keyCode)) | ismember(P.key.resp7, KbName(keyCode))) %the image on the left selected
            resp = char(thisBlock.Target1Name{1});
        elseif any(ismember(P.key.resp2, KbName(keyCode)) | ismember(P.key.resp6, KbName(keyCode)))  %the image on the right selected
            resp = char(thisBlock.Target2Name{1});
        else
            resp = 'NaN';
        end
        
        thisRT = secs - funcOnset; % calculate rt for this trial
        WaitSecs(responseDeadline - thisRT); % i.e., 4 seconds for first block, and 8 secs for blocks 2:4 in total
        funcOffset = GetSecs; % get function offset

        break;
    end
    if (GetSecs-funcOnset)>responseDeadline
        resp = 'NaN';
        thisRT = 'NaN';
        funcOffset = GetSecs; % get function offset
        break;
    end
end
end

