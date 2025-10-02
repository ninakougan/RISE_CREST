function agentsChoice = whoIsSelected(trialResp, thisBlock)
% Code by Busra Tanriverdi
% Last updated July 9th, 2022
% Contact: busra.tanriverdi@temple.edu

% In blocks 2 & 3, the agent's choice is preset, i.e., the subject is
% selected more or less in one of the blocks at a preset frequency.
    % The function get's agent's preset choice for a given trial, then records
    % the name of the target player (1 or 2, i.e., subject or the 2nd peer)
    % that is selected for that trial

% In block 4, a dot probe occurs on left or right image, based on a preset
% frequency.
    % So the function's selection works for the correct response for the dot
    % probe as well

% other peers/players are selecting; subject is always displayed on left (target1)
if trialResp == 1 % the subject is selected
    agentsChoice = char(thisBlock.Target1Name{1});

elseif trialResp == 0 % the subject is NOT selected
    agentsChoice = char(thisBlock.Target2Name{1});
end

end

