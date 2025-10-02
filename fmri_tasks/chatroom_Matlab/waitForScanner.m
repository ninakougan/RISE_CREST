% Chatroom Waiting for Scanner Trigger

% Code by Busra Tanriverdi, 
% Last updated Oct 6th, 2022
% Contact: busra.tanriverdi@temple.edu

% collect keyboard input for scanner backtick ('=') to start next block
while 1
    while 1
        if IsOSX
            [keyIsDown, secs, keyCode] = KbCheck(k);
        else
            [keyIsDown, secs, keyCode] = KbCheck; % no deviceNumber for Windows
        end
        if keyIsDown
            break;
        end
    end
    if ismember(P.key.backtick, KbName(keyCode))  % if keyboard input matches '='
        P.timing.countTriggers(nTrigger,1) = secs; % trying to save triggers for each block

        if nTrigger == 1
            P.timing.triggerStart = secs; % save the time for the trigger
        end

        nTrigger = nTrigger + 1; % increase trigger number count
        break
    end
end
