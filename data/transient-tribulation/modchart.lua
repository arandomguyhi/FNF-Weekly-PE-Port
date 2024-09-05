
function onStepHit()
    if curStep == 916 then
	for i = 0,3 do
	    noteTweenY('wewekjkb'..i, i, _G['defaultOpponentStrumX'..i], (stepCrochet/1000), 'quadInOut')
	end
    end
end