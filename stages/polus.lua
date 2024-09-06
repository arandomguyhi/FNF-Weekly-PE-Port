local ext = 'stages/w4/impostor/'
local reactorBeat = false
local played = 'impostor'

luaDebugMode = true
function onCreate()
    makeLuaSprite('shower', nil, -100, -100)
    makeGraphic('shower', screenWidth * 2, screenHeight * 2, '000000')
    setProperty('shower.alpha', 0.001)
    setObjectCamera('shower', 'camHUD')

    makeLuaSprite('reactor', nil, -100, -100)
    makeGraphic('reactor', screenWidth * 2, screenHeight * 2, 'FF0000')
    setProperty('reactor.alpha', 0.001)
    setObjectCamera('reactor', 'camHUD')

    makeLuaSprite('sv', ext..'stars', -485.85, 76.5)
    setScrollFactor('sv', 0, 0)
    setProperty('sv.antialiasing', true)
    addLuaSprite('sv')

    makeLuaSprite('wa', ext..'walls', 140.4, -250)
    setScrollFactor('wa', 0.9, 1)
    setProperty('wa.antialiasing', true)

    makeLuaSprite('bg', ext..'rocks', -465.85, 76.5)
    setProperty('bg.antialiasing', true)

    makeAnimatedLuaSprite('crewmate', ext..'johnson', 1530, 110)
    addAnimationByPrefix('crewmate', 'idle', '__Crew', 12, true)
    addAnimationByPrefix('crewmate', 'die', '__DIE', 12, false)
    addAnimationByPrefix('crewmate', 'walk', '__Walk', 12, true)
    playAnim('crewmate', 'walk')
    setProperty('crewmate.offset.x', -1) setProperty('crewmate.offset.y', 12)
    setProperty('crewmate.antialiasing', true)

    makeLuaSprite('polusBG', ext..'polusb', -100, -100)
    setScrollFactor('polusBG', 0.7, 1)
    setProperty('polusBG.antialiasing', true)

    makeLuaSprite('office', ext..'office', -400, -80)
    setProperty('office.antialiasing', true)

    makeLuaSprite('table', ext..'table', 50, 330)
    setProperty('table.antialiasing', true)

    makeAnimatedLuaSprite('witnesses', ext..'witnesses (and johnson i guess)', -330, 30)
    addAnimationByPrefix('witnesses', 'w', 'Symbol 4 instance 1', 12, true)
    playAnim('witnesses', 'w')
    setProperty('witnesses.antialiasing', true)

    for _, i in pairs({'polusBG', 'office', 'table', 'witnesses'}) do
	setProperty(i..'.alpha', 0.003)
    end

    for _, i in pairs({'wa', 'bg', 'polusBG', 'office'}) do
	scaleObject(i, 2, 2, false)
	addLuaSprite(i)
    end
    scaleObject('table', 2, 2, false)
    addLuaSprite('table', true)

    addLuaSprite('witnesses', true)
    addLuaSprite('crewmate')

    makeLuaSprite('over', ext..'cooloverlay')
    setProperty('over.alpha', 0.3)
    setProperty('over.color', getColorFromHex('D2FBFF'))
    setBlendMode('over', 'add')
    setObjectCamera('over', 'camHUD')
    setProperty('over.antialiasing', true)

    createInstance('sn', 'flixel.addons.display.FlxBackdrop', {nil, 0x11, -3, -3})
    loadGraphic('sn', ext..'snow')
    setProperty('sn.x', -200)
    scaleObject('sn', 4, 4, false)
    setScrollFactor('sn', 0.5, 0.5)
    setObjectCamera('sn', 'camHUD')
    setProperty('sn.antialiasing', true)
    addLuaSprite('sn')

    addLuaSprite('over')

    addLuaSprite('shower')
    addLuaSprite('reactor')
end

function onEvent(eventName, value1, value2)
    if eventName == 'impostorevents' then
	if value1 == 'killcheck' then
	    if getProperty('health') > 1 then
		playAnim('boyfriend', 'dodge', true)
		setProperty('boyfriend.specialAnim', true)
	    else
		played = 'bullet'
		setProperty('health', -2)
	    end
	elseif value1 == 'hi' then
	    startTween('crewX', 'crewmate', {x = 730}, 3, {ease = 'quadInOut', onComplete = 'crewWalkin'})
	    function crewWalkin()
		setProperty('crewmate.offset.x', 0) setProperty('crewmate.offset.y', 0)
		playAnim('crewmate', 'idle')
	    end
	elseif value1 == 'reactorOn' then
	    reactorBeat = true
	elseif value1 == 'reactorOff' then
	    reactorBeat = false
	elseif value1 == 'camthing' then
	    triggerEvent('Camera Follow Pos', '300', '100')
	elseif value1 == 'die' then
	    triggerEvent('Camera Follow Pos', '300', '100')
	    triggerEvent('Play Animation', 'shoot', 'dad')
	    playAnim('crewmate', 'die', true)
	    setProperty('crewmate.offset.x', 148) setProperty('crewmate.offset.y', 85)
	elseif value1 == 'awkward' then
	    setProperty('cameraSpeed', 0.25)
	elseif value1 == 'meetingThing' then
	    setProperty('shower.alpha', 1)
	    setProperty('cameraSpeed', 25)
	    setProperty('defaultCamZoom', 1)
	    setProperty('boyfriend.x', getProperty('boyfriend.x')+100)
	    setProperty('sn.alpha', 0.001)
	    for _, i in pairs({'bg', 'wa', 'crewmate'}) do
		setProperty(i..'.alpha', 0.0003)
	    end
	    for _, i in pairs({'polusBG', 'office', 'table', 'witnesses'}) do
	 	setProperty(i..'.alpha', 1)
	    end
	elseif value1 == 'weback' then
	    setProperty('cameraSpeed', 1)
	elseif value1 == 'inside' then
	    setProperty('shower.alpha', 0.001)
	    setProperty('cameraSpeed', 1)
	end
    end
end

function onBeatHit()
    if reactorBeat then
	if curBeat % 4 == 0 then
	    setProperty('reactor.alpha', 0.4)
	    doTweenAlpha('react', 'reactor', 0.001, 1)
	end
    end
end

function onUpdatePost(elapsed)
    setProperty('sn.x', getProperty('sn.x') - 5 * 60 * elapsed)
    setProperty('sn.y', getProperty('sn.y') + 5 * 60 * elapsed)
end

function onCreatePost()
    setProperty('scoreTxt.color', getColorFromHex('AD1919'))
    snapCamFollowToPos(100, 75, false)
end