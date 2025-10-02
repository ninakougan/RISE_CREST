% this script restricts keypresses to the spacebar,
% waits for the spacebar to be pressed,
% and then re-enables all keys

% restrict keys to spacebar only
RestrictKeysForKbCheck(KbName([P.key.space]))
	
% wait for a keystroke (of the spacebar)
KbStrokeWait;

% re-enable all keys
RestrictKeysForKbCheck([])
