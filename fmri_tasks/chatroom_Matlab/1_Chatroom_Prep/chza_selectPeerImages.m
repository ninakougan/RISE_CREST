function [P, peerSaved] = chza_selectPeerImages(P, peerSaved, xClicked, yClicked, whichButton)

% Code by Busra Tanriverdi
% Last updated Dec 1st, 2022
% Contact: busra.tanriverdi@temple.edu

% Check mouse clicks for which peer images are selected or deselected,
% highlight the selected images by turning their blue dot to red 

%%% variables %%%
% P.clickedRect: saves the rect center for the selected peer image (one of 20)
% peerSaved: count of total number of selected peers -> must end at 5
% P.filledPos: the position that is filled (one of 5 in bottom right corner)
% P.filledName: saves fullfilename for the peer saved in a specific position
% P.filledImgTexture: saves imgtexture for the selected image
% P.clickedImgNumber: keeps track of which images are selected already, to avoid their reselection

% first find number of available buttons for the mouse being used, this is
% important when assigning mouse clicks for selecting/deselecting peer photos
[~,~,buttons] = GetMouse;
nButtons = length(buttons); 

% start with the condition that the entire selection list is empty
if peerSaved == 0 
    if whichButton == 1 % if left click, save selection for 1st pos in selection list
        P.filledPos(1,:) = P.selectedRect(1,:); % fill position 1
        for nPeers = 1:20 % check if the clicked location matches one of the peer images, if yes, save image info
            if IsInRect(xClicked, yClicked, P.peerRect(nPeers,:))
                P.filledImgTexture(1) = P.peerImgTexture(nPeers);
                P.clickedRect(1,:) = P.peerRect(nPeers,:);
                P.filledName{1,1} = P.playerImgs.baseFileName{nPeers};
                P.clickedImgNumber(1) = nPeers;
                peerSaved = peerSaved + 1;
            end
        end
    elseif whichButton == nButtons % the length of the mouse denotes the last button, which is the right click
        P.filledImgTexture = P.filledImgTexture; P.clickedRect = P.clickedRect;
        P.filledPos = P.filledPos; P.filledName = P.filledName; peerSaved = peerSaved; 
    end
elseif peerSaved >= 1 && peerSaved < 5
    if whichButton == 1 % if left click, save selection for the first empty position in selection list
        for nPos = 1:5
            if isempty(P.filledName{1,nPos}) % if n'th position in the selection list is empty
                for nPeers = 1:20 % check if the clicked location matches one of the peer images, if yes, save image info
                    if IsInRect(xClicked, yClicked, P.peerRect(nPeers,:))
                        % if ~ismember(nPeers, P.clickedImgNumber) % only save if the clicked image was not already selected
                        if ~ismember(cellstr(P.playerImgs.baseFileName{nPeers}), P.filledName(find(~cellfun(@isempty,P.filledName))))  % this should work better
                            P.filledPos(nPos,:) = P.selectedRect(nPos,:); % fill position nth
                            P.filledImgTexture(nPos) = P.peerImgTexture(nPeers);
                            P.clickedRect(nPos,:) = P.peerRect(nPeers,:);
                            P.filledName{1,nPos} = P.playerImgs.baseFileName{nPeers};
                            P.clickedImgNumber(length(P.clickedImgNumber)+1) = nPeers;
                            peerSaved = peerSaved + 1;
                        end
                    end
                end
            end
        end
    elseif whichButton == nButtons % the length of the mouse denotes the last button, which is the right click
        % They could right-click only on one of 5 locations at once. Depending on which one they right-clicked, that location should be emptied
        if IsInRect(xClicked, yClicked, P.unselectionArea) % But do this *only if* the cight click falls inside the selection area that is *not* empty already
            % -otherwise a right click should mean nothing
            for nPos = 1:5
                if ~isempty(P.filledName{1,nPos})
                    if IsInRect(xClicked, yClicked, P.filledPos(nPos,:)) % if matches with nth position in selected position list
                        P.filledPos(nPos,:) = NaN;
                        P.filledImgTexture(nPos) = NaN;
                        P.clickedRect(nPos,:) = NaN;
                        P.filledName{1,nPos} = {};
                        peerSaved = peerSaved - 1;
                    end
                end
            end
        end
    end
elseif peerSaved == 5 % if all 5 peers were selected
    if whichButton == 1 
        if IsInRect(xClicked, yClicked, P.screen.posComplete) % check if pressed in the empty bottom box to end the session
            P.filledPos = P.filledPos; P.filledImgTexture = P.filledImgTexture; P.clickedRect = P.clickedRect; P.filledName = P.filledName; peerSaved = peerSaved + 1;
        else % leave everything as is & wait for the next click
            P.filledPos = P.filledPos; P.filledImgTexture = P.filledImgTexture; P.clickedRect = P.clickedRect; P.filledName = P.filledName; peerSaved = peerSaved;
        end
    elseif whichButton == nButtons % check which peer image is unselected remember the length of the mouse denotes the right click 
        % At this point, all 5 locations in selection list are filled, empty the one that matches the current click
        if IsInRect(xClicked, yClicked, P.unselectionArea) % But do this *only if* the cight click falls inside the selection area that is *not* empty already
            % -otherwise a right click should mean nothing
            for nPos = 1:5
                if IsInRect(xClicked, yClicked, P.filledPos(nPos,:)) % if matches with nth position in selected position list
                    P.filledPos(nPos,:) = NaN;
                    P.filledImgTexture(nPos) = NaN;
                    P.clickedRect(nPos,:) = NaN;
                    P.filledName{1,nPos} = {};
                    peerSaved = peerSaved - 1;
                end
            end
        end
    else
        if nButtons > 2 
            if whichButton == 2 % middle click to end the session
               P.filledPos = P.filledPos; P.filledImgTexture = P.filledImgTexture; P.clickedRect = P.clickedRect; P.filledName = P.filledName; peerSaved = peerSaved + 1;

            end
        end
    end
end
end
