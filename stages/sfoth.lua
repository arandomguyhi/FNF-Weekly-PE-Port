local PREFIX = 'Guest/'

luaDebugMode = true
function onCreate()
    addHaxeLibrary('CoolUtil', 'backend')
    addHaxeLibrary('FlxMath', 'flixel.math')

    makeLuaSprite('sky', 'guest/Sky', -600, -50)
    setScrollFactor('sky', 0.8, 0.8)
    addLuaSprite('sky')

    makeLuaSprite('bg', 'guest/BG', -900, -200)
    graphicSize('bg', 1280*1.7, 720*1.7)
    addLuaSprite('bg')

    makeLuaSprite('black', nil, -300, -300)
    makeGraphic('black', screenWidth * 2, screenHeight * 2, '000000')
    setScrollFactor('black', 0, 0)
    setProperty('black.alpha', 0.001)
    addLuaSprite('black')

    createInstance('v0', 'objects.Character', {50, -600, 'zero'})
    addInstance('v0')

    makeLuaSprite('loadingScreen', 'guest/LoadingScreen')
    setObjectCamera('loadingScreen', 'camOther')
    addLuaSprite('loadingScreen')

    makeLuaSprite('wheel', 'guest/Wheel', 1128, 565)
    setObjectCamera('wheel', 'camOther')
    addLuaSprite('wheel')

    makeAnimatedLuaSprite('loadingText', 'guest/LoadingText', 1150, 614)
    addAnimationByPrefix('loadingText', 'load', 'Loading', 24, true)
    setObjectCamera('loadingText', 'camOther')
    playAnim('loadingText', 'load')
    addLuaSprite('loadingText')

    makeLuaSprite('overlay', 'guest/overlay')
    setScrollFactor('overlay', 0, 0)
    graphicSize('overlay', 1280*1.25, 720*1.25)
    setProperty('overlay.alpha', 0.08)
    setBlendMode('overlay', 'add')
    addLuaSprite('overlay')

    setProperty('defaultCamZoom', 1.1)
    setProperty('camFollow.x', 700) setProperty('camFollow.y', 500)
end

function onCreatePost()
    setProperty('skipCountdown', true)
    playAnim('dad', 'scarystart', true) setProperty('dad.specialAnim', true)
    setTextFont('scoreTxt', 'Boblox.ttf')
    setTextFont('timeTxt', 'Boblox.ttf')
    setProperty('timeTxt.y', getProperty('timeTxt.y')-7)

    setProperty('camFollow.x', 700) setProperty('camFollow.y', 500)
    setProperty('isCameraOnForcedPos', true)

    for i = 0, getProperty('unspawnNotes.length')-1 do
	if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Female666' then
	    if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
		setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
	    end
	end
    end

    setObjectCamera('comboGroup', 'camGame')
    setProperty('comboGroup.x', -100) setProperty('comboGroup.y', 50)
end

local s = 1
local v0X = 0
local v0Y = 0
function onUpdate(elapsed)
    s = s + elapsed

    setProperty('v0.x', lerp(getProperty('v0.x'), getProperty('v0.x') + (math.sin(s) * -5), boundTo(1, 0, elapsed * 4)))
    setProperty('v0.y', lerp(getProperty('v0.y'), getProperty('v0.y') + (math.cos(s) * 5), boundTo(1, 0, elapsed * 4)))

    setProperty('wheel.angle', getProperty('wheel.angle')+1)
end

local canStart = false
function onStartCountdown()
    if not canStart then
	canStart = true

	runTimer('startie', 2)

	return Function_Stop
    end
    return Function_Continue
end

function opponentNoteHit(id,noteData,noteType,isSustainNote)
    if noteType == 'Female666' or noteType == 'Duet' then
	playAnim('v0', getProperty('singAnimations')[noteData+1], true)
	setProperty('v0.holdTimer', 0)
    end

    if noteType == 'Female666' and not mustHitSection then
	setProperty('camFollow.x', getMidpointX('v0')-10)
	setProperty('camFollow.y', getMidpointY('v0')+250)
	setProperty('isCameraOnForcedPos', true)

	if noteData == 0 then
	    setProperty('camFollow.x', getMidpointX('v0')-25)
	    setProperty('camFollow.y', getMidpointY('v0')+250)
	elseif noteData == 1 then
	    setProperty('camFollow.x', getMidpointX('v0')-10)
	    setProperty('camFollow.y', getMidpointY('v0')+265)
	elseif noteData == 2 then
	    setProperty('camFollow.x', getMidpointX('v0')-10)
	    setProperty('camFollow.y', getMidpointY('v0')+235)
	elseif noteData == 3 then
	    setProperty('camFollow.x', getMidpointX('v0')+5)
	    setProperty('camFollow.y', getMidpointY('v0')+250)
	end
    else
	setProperty('isCameraOnForcedPos', false)
    end
end

function goodNoteHit(id,noteData,noteType,isSustainNote)
    if noteType == 'Duet' then
	playAnim('gf', getProperty('singAnimations')[noteData+1], true)
	setProperty('gf.holdTimer', 0)
    end

    if noteType ~= 'GF Sing' and mustHitSection then
	setProperty('isCameraOnForcedPos', false)
    end

    if noteType == 'GF Sing' and mustHitSection then
	setProperty('camFollow.x', getMidpointX('gf') - 100)
	setProperty('camFollow.y', getMidpointY('gf') + 250)
	setProperty('isCameraOnForcedPos', true)

	if noteData == 0 then
	    setProperty('camFollow.x', getMidpointX('gf') - 115)
	    setProperty('camFollow.y', getMidpointY('gf') + 250)
	elseif noteData == 1 then
	    setProperty('camFollow.x', getMidpointX('gf') - 100)
	    setProperty('camFollow.y', getMidpointY('gf') + 265)
	elseif noteData == 2 then
	    setProperty('camFollow.x', getMidpointX('gf') - 100)
	    setProperty('camFollow.y', getMidpointY('gf') + 235)
	elseif noteData == 3 then
	    setProperty('camFollow.x', getMidpointX('gf') - 85)
	    setProperty('camFollow.y', getMidpointY('gf') + 250)
	end
    end
end

function onBeatHit()
    if curBeat % 2 == 0 and not stringStartsWith(getProperty('x0.animation.name'), 'sing') then
	callMethod('x0.dance', {''})
    end
end

function onStepHit()
    if curStep == 1878 then
	setProperty('camGame.visible', false)
    end
end

function onEvent(name, value1, value2)
    if name == 'Guest' then
	if value1 == 'v0' then
	    doTweenY('sheenters', 'v0', -10, 4, 'expoOut')
	    callMethod('iconP2.changeIcon', {'doppelbloxxers'})
	elseif value1 == 'betty' then
	    startTween('vembixa', 'gf', {x = 530}, 4, {ease = 'linear', onComplete = 'onTweenCompleted'})
	elseif value1 == 'flash' then
	    doTweenAlpha('flashblack', 'black', value2, 0.4, 'expoOut')
	elseif value1 == 'unflash' then
	    doTweenAlpha('unflassh', 'black', 0.001, 0.4, 'expoOut')
	elseif value1 == 'start' then
	    setProperty('camHUD.alpha', 1)
	    setProperty('defaultCamZoom', 0.9)
	    doTweenAlpha('black1', 'black', 0.001, 0.6, 'expoOut')
	elseif value1 == 'friend' then
	    doTweenAlpha('quewe', 'black', 0.3, 1.5, 'linear')
	end
    end
end

function onTimerCompleted(tag)
    if tag == 'startie' then
	for i, load in pairs({'loadingScreen', 'wheel', 'loadingText'}) do
	    startTween('starttween'..i, load, {alpha = 0.001}, 1, {})end
	setProperty('isCameraOnForcedPos', false)
	startCountdown()
    end
end

function onTweenCompleted(tag)
    if tag == 'vembixa' then
	playAnim('gf', 'danceLeft', true)
	callMethod('iconP1.changeIcon', {'bloxxers'})
    end
end

function graphicSize(obj, x, y)
    return runHaxeCode("game.getLuaObject('"..obj.."').setGraphicSize("..x..", "..y..");")
end

function lerp(a,b,ratio)
    return a + ((b-a)*ratio)
end

function boundTo(value, min, max)
    return math.max(min, math.min(max, value))
end