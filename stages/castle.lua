function onCreate()
    makeLuaSprite('bg', 'stages/w2/bowser/bg', -155, -250)
    scaleObject('bg', 1.2, 1.2)
    setScrollFactor('bg', 0.8, 0.8)
    addLuaSprite('bg')

    makeLuaSprite('walls', 'stages/w2/bowser/walls', -185, 650)
    setScrollFactor('walls', 0.9, 0.9)
    addLuaSprite('walls')

    createInstance('jr', 'objects.Character', {-800, 1200, 'bowserjr'})
    scaleObject('jr', 0.125, 0.125)
    addInstance('jr')

    makeLuaSprite('floor', 'stages/w2/bowser/main_flopor', 0, 375)
    addLuaSprite('floor')
end

function onCreatePost()
    snapCamFollowToPos(2000, 1000, false)
end
function onStepHit() if curStep == 896 then jrIntro() end end

local allowedToZ = true
function onMoveCamera(turn)
    if allowedToZ then
	setProperty('defaultCamZoom', turn == 'dad' and 0.55 or 0.75)
    end
    setVar('turn', turn)
end

local s = 1
setVar('jrX', -400)
setVar('jrY', 0)
function onUpdate(elapsed)
    s = s + elapsed
    setProperty('jr.x', lerp(getProperty('jr.x'), getVar('jrX') + (math.sin(s) * -100), boundTo(1, 0, elapsed * 4)))
    setProperty('jr.y', lerp(getProperty('jr.y'), getVar('jrY') + (math.cos(s) * 100), boundTo(1, 0, elapsed * 4)))

    if getProperty('jr.animation.curAnim.finished') and getProperty('jr.animation.curAnim.name')..'-loop' ~= nil then
	playAnim('jr', getProperty('jr.animation.curAnim.name')..'-loop', true)
    end
end

function onSongStart() playAnim('jr', 'idle', true) end

function jrIntro()
    allowedToZ = false
    setProperty('defaultCamZoom', 0.5)
    setProperty('isCameraOnForcedPos', true)
    setProperty('camFollow.x', 1700) setProperty('camFollow.y', 700)
    startTween('jrScale', 'jr.scale', {x = 1, y = 1}, 2, {startDelay = 0.5, ease = 'quadOut'})
    runHaxeCode([[
	FlxTween.num(getVar('jrX'), 1500, 3, {ease: FlxEase.backOut}, function(t){ setVar('jrX', t); });
	FlxTween.num(getVar('jrY'), 400, 3, {ease: FlxEase.backOut}, function(t){ setVar('jrY', t); });
    ]])
end

function onBeatHit()
    if curBeat % 2 == 0 and not stringStartsWith(getProperty('jr.animation.name'), 'sing') then
	playAnim('jr', 'idle', true)
    end
end

function onSpawnNote()
    for i = 0, getProperty('notes.length')-1 do
	if getPropertyFromGroup('notes', i, 'noteType') == 'JR Note' and not getPropertyFromGroup('notes', i, 'mustPress') then
	    setPropertyFromGroup('notes', i, 'noAnimation', true)
	end
    end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if noteType == 'JR Note' or noteType == 'Duet' then
	playAnim('jr', getProperty('singAnimations')[noteData+1], true)
	setProperty('jr.holdTimer', 0)
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if noteType == 'Duet' then
	playAnim('gf', getProperty('singAnimations')[noteData+1], true)
	setProperty('gf.holdTimer', 0)
    end
end

function onEvent(eventName, v1, v2)
    if eventName == 'Bowser Triggers' then
	if v1 == 'JR Section' then
	    callMethod('iconP2.changeIcon', {'bowserjr'})
	    allowedToZ = false
	    setProperty('defaultCamZoom', 0.65)
	    setProperty('isCameraOnForcedPos', true)
	    setProperty('camFollow.x', 1700) setProperty('camFollow.y', 700)
	elseif v1 == 'End JR' then
	    setProperty('isCameraOnForcedPos', false)
	    allowedToZ = true
	elseif v1 == 'Duet' then
	    setProperty('isCameraOnForcedPos', true)
	    setProperty('camFollow.x', 1865) setProperty('camFollow.y', 900)
	    setProperty('defaultCamZoom', 0.5)
	elseif v1 == 'Duet Off' then
	    setProperty('isCameraOnForcedPos', false)
	elseif v1 == 'Bowser Duet Icons' then
	    callMethod('iconP2.changeIcon', {'koopa-duet'})
	elseif v1 == 'Bowser Icon' then
	    callMethod('iconP2.changeIcon', {getProperty('dad.healthIcon')})
	end
    end
end

function lerp(a,b,ratio)
    return a + ((b-a)*ratio)
end

function boundTo(value, min, max)
    return math.max(min, math.min(max, value))
end