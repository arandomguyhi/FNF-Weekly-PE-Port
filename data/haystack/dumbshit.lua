luaDebugMode = true
function onCreatePost()
    for i = 0,3 do setProperty('opponentStrums.members['..i..'].alpha', 0.001)end
    setProperty('dad.alpha', 0.001)
    setProperty('iconP2.alpha', 0.001)
    for i = 0,7 do setPropertyFromGroup('strumLineNotes', i, 'x', 417 + (112 * (i % 4)))end
end

function onUpdate(elapsed)
    local currentBeat = (getSongPosition() / 1000) * (curBpm / 300)
    if curStep >= 1856 then
	for i=0,7 do
	    local name = i > 3 and "defaultPlayerStrum" or "defaultOpponentStrum"
	    local note = (i % 4)
	    noteTweenY('tweenY'..i, i, _G[name..'Y'..note] + 15 * math.cos((currentBeat + i*2.5) * math.pi), 0.01)
	end
    end
end

function onStepHit()
    if curStep == 112 then
	for i = 0,7 do
	    local name = i > 3 and 'defaultPlayerStrum' or 'defaultOpponentStrum'
	    noteTweenX('notesX'..i, i, _G[name..'X'..(i%4)], (stepCrochet / 1000) * 16, 'quadInOut')
	end
    end
end
