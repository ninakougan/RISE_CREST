% This script displays the selected peers for the chza.m task. The
% selection comes from chza_selectPeerImages.m function.

% All images are still displayed on top of the screen, the selected peers
% are shown on right lower corner of the screen (up to 5 of them)

% Importantly, the selected images' should have a red circle appear on their
% top-of-the-screen display, while the unselected ones appear with a blue
% circle.

% Code by Busra Tanriverdi
% Last updated July 18th, 2022
% Contact: busra.tanriverdi@temple.edu

%% Display all peers together with the selection list based on the click
if peerSaved <= 5
    countText = char(num2str(peerSaved)); % selected peer count

elseif peerSaved > 5
    countText = char(num2str(peerSaved-1)); 

end

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
DrawFormattedText(w, genderText, 'center', 'center', P.screen.black, [],[],[],[],[], [(P.genderTextCenter(1)-50), (P.genderTextCenter(2)-40), P.genderTextCenter(1), P.genderTextCenter(2)]); 
Screen('DrawLine', w, [0, 0, 255], 0, (P.screen.yCenter-5), P.screen.width, (P.screen.yCenter-5), 5);
Screen('DrawLine', w, [0, 0, 255], (P.screen.xCenter-5), (P.screen.yCenter-5), (P.screen.xCenter-5), P.screen.height, 5);

if isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 1
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 1
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]); 
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 1
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 1
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 1
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 1
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 1
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 1
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 1
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 1
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 1
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 1
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 1
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 1
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 1
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 1
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 1 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 1 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 1 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 1 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

elseif isempty(P.filledName{1,1}) == 0 && isempty(P.filledName{1,2}) == 0 && isempty(P.filledName{1,3}) == 0 && isempty(P.filledName{1,4}) == 0 && isempty(P.filledName{1,5}) == 0
    Screen('DrawTexture', w, P.filledImgTexture(1), [], P.filledPos(1,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(1,3)-20), P.clickedRect(1,2), P.clickedRect(1,3), (P.clickedRect(1,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(2), [], P.filledPos(2,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(2,3)-20), P.clickedRect(2,2), P.clickedRect(2,3), (P.clickedRect(2,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(3), [], P.filledPos(3,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(3,3)-20), P.clickedRect(3,2), P.clickedRect(3,3), (P.clickedRect(3,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(4), [], P.filledPos(4,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(4,3)-20), P.clickedRect(4,2), P.clickedRect(4,3), (P.clickedRect(4,2)+20)]);
    Screen('DrawTexture', w, P.filledImgTexture(5), [], P.filledPos(5,:)); Screen('FillOval', w, [255 0 0], [(P.clickedRect(5,3)-20), P.clickedRect(5,2), P.clickedRect(5,3), (P.clickedRect(5,2)+20)]);
    DrawFormattedText(w, countText, (P.genderTextCenter(1)-50), (P.genderTextCenter(2)+20), P.screen.black);  Screen('Flip', w);

end

