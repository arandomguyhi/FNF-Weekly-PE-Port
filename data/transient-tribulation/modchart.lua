local counter = -1
function onStepHit()
    if curStep >= 656 and curStep < 916 then
	if curStep % 4 == 0 then
	    counter = counter * -1

	    for i = 0,7 do
		local name = i > 3 and "defaultPlayerStrum" or "defaultOpponentStrum"
		local note = (i % 4)

		if i == 0 or i == 2 or i == 4 or i == 6 then noteTweenY('wewekjkv'..i, i, _G[name..'Y'..note] - 15 * counter, (stepCrochet/1000), 'quadInOut')end
		if i == 1 or i == 3 or i == 5 or i == 7 then noteTweenY('wewekjre'..i, i, _G[name..'Y'..note] + 15 * counter, (stepCrochet/1000), 'quadInOut')end
	    end
	end
    end

    if curStep == 916 then
	for i = 0,7 do
	    local name = i > 3 and "defaultPlayerStrum" or "defaultOpponentStrum"
	    local note = (i % 4)
	    noteTweenY('defaultY'..i, i, _G[name..'Y'..note], (stepCrochet/1000), 'quadInOut')
	end
    end
end