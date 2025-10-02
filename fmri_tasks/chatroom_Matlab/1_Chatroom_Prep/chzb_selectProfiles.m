function [profile, profileSaved, P] = chzb_selectProfiles(P, profile, profileSaved, xClicked, yClicked, whichButton)

% Code by Busra Tanriverdi
% Last updated Dec 12th, 2022
% Contact: busra.tanriverdi@temple.edu

% Check mouse clicks for which profiles are selected or deselected - to later
% highlight the selected profiles with a red line underneath them

%%% variables %%%
% profileSaved: count of total number of selected profiles -> must end at 2
% P.clickedPos: the position coordinates for clicked position for selected profiles
% profile: saves the profile info for the selected ones

% first find number of available buttons for the mouse being used, this is
% important when assigning mouse clicks for selecting/deselecting peer photos
[~,~,buttons] = GetMouse;
nButtons = length(buttons);

if isempty(profile{:,1}) == 1 && isempty(profile{:,2}) == 1 % if the entire profile variable is empty

    if whichButton == 1 % left click -> select profile & save it in position1 (profile{:,1})
        nText = 1;
        for nPos = 1:5
            if IsInRect(xClicked, yClicked, P.screen.posRect(nPos,:))
                profile{:,1} = P.profileListRand(nText:nText+3,:); % profile in center is selected
                P.clickedPos(1,:) = P.screen.posRect(nPos,:); % save pos1 coordinates for clicked position for first profile
                P.clickedLinePos(1,:) = P.screen.lineCoord(nPos,:); % save pos1 line coordinates for clicked position for first profile
                profileSaved = profileSaved + 1; % increase count for saved profiles
            end
            nText = nText+4;
        end
    elseif whichButton == nButtons % if right click when the entire profile variable is empty
        profile = profile; % keep the profile as is (in this case empty)
        profileSaved = profileSaved;
    end

elseif isempty(profile{:,1}) == 0 && isempty(profile{:,2}) == 1 % if first profile is filled, and the second is empty
    if whichButton == 1 % left click -> select profile & save it in position2 (profile{2,:})
        nText = 1;
        for nPos = 1:5
            if IsInRect(xClicked, yClicked, P.screen.posRect(nPos,:))
                profile{:,2} = P.profileListRand(nText:nText+3,:); % profile in center is selected
                P.clickedPos(2,:) = P.screen.posRect(nPos,:); % save pos2 coordinates for clicked position for first profile
                P.clickedLinePos(2,:) = P.screen.lineCoord(nPos,:); % save pos2 line coordinates for clicked position for first profile
                profileSaved = profileSaved + 1; % increase count for saved profiles
            end
            nText = nText+4;
        end
    elseif whichButton == nButtons % right click -> unselect profile in position1 (profile{1,:})
        nText = 1;
        for nPos = 1:5
            if IsInRect(xClicked, yClicked, P.screen.posRect(nPos,:)) % check if in pos1
                if strcmp(P.profileListRand(nText:nText+3,:), profile{:,1}) == 1 % if this position''s profile matches the profile at previously saved but now unclicked location
                    profile{:,1} = {};
                    P.clickedPos(1,:) = [];
                    P.clickedLinePos(1,:) = NaN;
                elseif strcmp(P.profileListRand(nText:nText+3,:), profile{:,2}) == 1 % if this position''s profile matches the profile at previously saved but now unclicked location
                    profile{:,2} = {};
                    P.clickedPos(2,:) = NaN;
                    P.clickedLinePos(2,:) = NaN;
                end
                profileSaved = profileSaved - 1; % decrease count for saved profiles
            end
            nText = nText+4;
        end
    end

elseif isempty(profile{:,1}) == 1 && isempty(profile{:,2}) == 0 % if first profile is empty, and the second is filled
    if whichButton == 1 % left click -> select profile
        nText = 1;
        for nPos = 1:5
            if IsInRect(xClicked, yClicked, P.screen.posRect(nPos,:))
                profile{:,1} = P.profileListRand(nText:nText+3,:); % profile in center is selected
                P.clickedPos(1,:) = P.screen.posRect(nPos,:); % save pos1 coordinates for clicked position for first profile
                P.clickedLinePos(1,:) = P.screen.lineCoord(nPos,:); % save pos1 line coordinates for clicked position for first profile
                profileSaved = profileSaved + 1; % increase count for saved profiles
            end
            nText = nText+4;
        end
    elseif whichButton == nButtons % right click -> unselect profile
        nText = 1;
        for nPos = 1:5
            if IsInRect(xClicked, yClicked, P.screen.posRect(nPos,:)) % check if in pos1
                if strcmp(P.profileListRand(nText:nText+3,:), profile{:,1}) == 1 % if this position''s profile matches the profile at previously saved but now unclicked location
                    profile{:,1} = {}; % profile in center is unselected
                    P.clickedPos(1,:) = NaN;
                    P.clickedLinePos(1,:) = NaN;
                elseif strcmp(P.profileListRand(nText:nText+3,:), profile{:,2}) == 1 % if this position''s profile matches the profile at previously saved but now unclicked location
                    profile{:,2} = {}; % profile in center is unselected
                    P.clickedPos(2,:) = NaN;
                    P.clickedLinePos(2,:) = NaN;
                end
                profileSaved = profileSaved - 1; % decrease count for saved profiles
            end
            nText = nText+4;
        end
    end
elseif isempty(profile{:,1}) == 0 && isempty(profile{:,2}) == 0 % if  both cells are filled
    if whichButton == nButtons % right click -> unselect profile
        nText = 1;
        for nPos = 1:5
            if IsInRect(xClicked, yClicked, P.screen.posRect(nPos,:)) % check if in pos1
                if strcmp(P.profileListRand(nText:nText+3,:), profile{:,1}) == 1 % if this position''s profile matches the profile at previously saved but now unclicked location
                    profile{:,1} = {};
                    P.clickedPos(1,:) = NaN;
                    P.clickedLinePos(1,:) = NaN;
                elseif strcmp(P.profileListRand(nText:nText+3,:), profile{:,2}) == 1 % if this position''s profile matches the profile at previously saved but now unclicked location
                    profile{:,2} = {};
                    P.clickedPos(2,:) = NaN;
                    P.clickedLinePos(2,:) = NaN;
                end
                profileSaved = profileSaved - 1; % decrease count for saved profiles
            end
            nText = nText+4;
        end
    elseif whichButton < nButtons
        if whichButton == 1 % left click & profile is already filled, don't change it
            if IsInRect(xClicked, yClicked, P.screen.posQuest) % check if pressed in question box
                profile = profile;
                profileSaved = profileSaved + 1;
            else
                profile = profile;
                profileSaved = profileSaved;
            end
        else % middle click to end the session
            profile = profile;
            profileSaved = profileSaved + 1;
        end
    end
end
end

