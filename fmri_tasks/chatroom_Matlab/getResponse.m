function [P, keyPressed, resp, thisRT, funcOffset] = getResponse(funcOnset, P, k, thisBlock,responseDeadline)
% Code by Busra Tanriverdi
% Last updated March 29th, 2023
% Contact: busra.tanriverdi@temple.edu

% Collects keypresses for a given duration. Note that in this version, the given
% duration is trial duration, which is set with the "P.timing.trialdisp"
% variable (because we save parameters in a P struct). You must change it as you need.

% funcOnset: Time when the function is called
% P: structure with all necessary information about keys
% k: deviceNumber; If using OSX, you MUST provide a deviceNumber. If using Windows,
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

% restrict keys to response keys only, so triggers (or wrong keys) are not registered as button presses
RestrictKeysForKbCheck([P.key.resp1,P.key.resp1_alt,P.key.resp2,P.key.resp2_alt,P.key.resp6,...
    P.key.resp6_alt,P.key.resp7,P.key.resp7_alt,P.key.quit]);

% empty varibles before the next key check
resp = 'NaN';
thisRT = 'NaN';
keyPressed = 'NaN';

% Don't start until keys are released
if IsOSX
    if ~exist('k','var')
        fprintf('You are using OSX and you MUST provide a deviceNumber(k)! Or key presses will fail.\n');
    end
    while KbCheck(k)
        if (GetSecs-funcOnset)>responseDeadline
            keyPressed = 'NaN';
            resp = 'NaN';
            thisRT = 'NaN';
            funcOffset = GetSecs; % get function offset
            break;
        end
    end
else
    while KbCheck % no deviceNumber for Windows
        if (GetSecs-funcOnset)>responseDeadline
            keyPressed = 'NaN';
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

        if any(keyCode(P.key.resp1) | keyCode(P.key.resp7) | keyCode(P.key.resp1_alt) | keyCode(P.key.resp7_alt)) %the image on the left selected
            resp = char(thisBlock.Target1Name{1});
        elseif any(keyCode(P.key.resp2) | keyCode(P.key.resp6) | keyCode(P.key.resp2_alt) | keyCode(P.key.resp6_alt)) %the image on the right selected
            resp = char(thisBlock.Target2Name{1});
        elseif keyCode(P.key.quit) % if pressed to quit
            fprintf("You have pressed a key to exit the experiment.");
            sca; return;
        end

        keyPressed = KbName(find(keyCode==1)); % save the pressed key to output (in case we need to troubleshoot responses)
        thisRT = secs - funcOnset; % calculate rt for this trial
        WaitSecs(responseDeadline - thisRT); % i.e., 4 seconds for first block, and 8 secs for blocks 2:4 in total
        funcOffset = GetSecs; % get function offset
        break;
    end
    if (GetSecs-funcOnset)>responseDeadline
        keyPressed = 'NaN';
        resp = 'NaN';
        thisRT = 'NaN';
        funcOffset = GetSecs; % get function offset
        break;
    end
end

% remove key restriction
RestrictKeysForKbCheck([]);

end

