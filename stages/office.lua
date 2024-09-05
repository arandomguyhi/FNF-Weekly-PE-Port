local prefix = 'stages/w9/aggretsuko/'
local boppersShocked = false

luaDebugMode = true
function onCreate()
    makeLuaSprite('sky', nil, 330)
    makeGraphic('sky', 1375, screenHeight, 'E7F3F7')
    addLuaSprite('sky')

    makeLuaSprite('him', prefix..'boss3', 650, -1000)
    scaleObject('him', 0.5, 0.5, false)
    setScrollFactor('him', 0.85, 0.85)
    setProperty('him.antialiasing', true)
    addLuaSprite('him')

    makeLuaSprite('office', prefix..'office', -500, -300)
    scaleObject('office', 0.5, 0.5, false)
    setProperty('office.antialiasing', true)
    addLuaSprite('office')

    makeLuaSprite('overlay', prefix..'overlay')
    setScrollFactor('overlay', 0, 0)
    setProperty('overlay.antialiasing', true)
    runHaxeCode("game.getLuaObject('overlay').blend = 0;")
    screenCenter('overlay', 'XY')
    addLuaSprite('overlay', true)

    makeLuaSprite('blackScreen', nil)
    makeGraphic('blackScreen', 1, 1, '000000')
    scaleObject('blackScreen', screenWidth * 2, screenHeight * 2)
    setScrollFactor('blackScreen', 0, 0)
    screenCenter('blackScreen', 'XY')
    setObjectCamera('blackScreen', 'camOther')
    setProperty('blackScreen.visible', false)
    addLuaSprite('blackScreen')
end

function onCreatePost()
    setProperty('camGame.scroll.x', 1000 - (screenWidth / 2))
    setProperty('camGame.scroll.y', 575 - (screenHeight / 2))

    createInstance('fenneko', 'objects.Character', {getProperty('gf.x') + 175, getProperty('gf.y') - 20, 'fenneko'})
    setProperty('fenneko.danceEveryNumBeats', 2)
    addInstance('fenneko')

    createInstance('haida', 'objects.Character', {getProperty('gf.x') - 125, getProperty('gf.y') - 130, 'haida'})
    setProperty('haida.danceEveryNumBeats', 2)
    addInstance('haida')

    setScrollFactor('gf', 1, 1)
end

function onUpdate()
    setProperty('dad.stunned', true)
end

function onStartCountdown()
    runTimer('fakestartTimer', (crochet / 1000), 5)
end

function onEvent(name, v1, v2)
    if name == 'Busy Work Events' then
	if v1 == 'boss' then
	    doTweenY('hiboss', 'him', -2100, 2)
	elseif v1 == 'angry' then
	    playAnim('gf', 'shocked', true)
	    setProperty('gf.specialAnim', true)
	    playAnim('fenneko', 'shocked', true)
	    setProperty('fenneko.specialAnim', true)
	    playAnim('haida', 'shocked', true)
	    setProperty('haida.specialAnim', true)
	    setProperty('defaultCamZoom', 1)
	    setProperty('camFollow.y', 550)
	    boppersShocked = true
	elseif v1 == 'boppers normal' then
	    playAnim('gf', 'shockedend', true)
	    setProperty('gf.specialAnim', true)
	    playAnim('fenneko', 'shockedend', true)
	    setProperty('fenneko.specialAnim', true)
	    playAnim('haida', 'shockedend', true)
	    setProperty('haida.specialAnim', true)
	    boppersShocked = false
	elseif v1 == 'camera move' then
	    setProperty('isCameraOnForcedPos', true)
	    startTween('cameraMoveTween', 'camFollow', {x = 980, y = 575}, 1.75, {ease = 'smoothStepInOut'})
	elseif v1 == 'camera release' then
	    setProperty('isCameraOnForcedPos', false)
	    setProperty('defaultCamZoom', 1.2)
	elseif v1 == 'end cam' then
	    setProperty('isCameraOnForcedPos', true)
	    setProperty('defaultCamZoom', 1)
	    setProperty('camFollow.x', 1000)
	    setProperty('camFollow.y', 550)
	elseif v1 == 'black screen' then
	    if v2 == 'on' then
		setProperty('blackScreen.visible', true)
		setProperty('camHUD.visible', false)
	    elseif v2 == 'off' then
		setProperty('blackScreen.visible', false)
		setProperty('camHUD.visible', true)
	    end
	end
    end
end

function onBeatHit()
    if curBeat % math.round(getProperty('gfSpeed') * getProperty('fenneko.danceEveryNumBeats')) == 0 and getProperty('fenneko.animation.curAnim') ~= nil and not boppersShocked then
	callMethod('fenneko.dance', {''})
    end
    if curBeat % math.round(getProperty('gfSpeed') * getProperty('haida.danceEveryNumBeats')) == 0 and getProperty('haida.animation.curAnim') ~= nil and not boppersShocked then
	callMethod('haida.dance', {''})
    end
    if boppersShocked then
	playAnim('gf', 'shocked', true)
	setProperty('gf.specialAnim', true)
	playAnim('fenneko', 'shocked', true)
	setProperty('fenneko.specialAnim', true)
	playAnim('haida', 'shocked', true)
	setProperty('haida.specialAnim', true)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'fakestartTimer' then
	if loopsLeft % math.round(getProperty('gfSpeed') * getProperty('fenneko.danceEveryNumBeats')) == 0 and getProperty('fenneko.animation.curAnim') ~= nil then
	    callMethod('fenneko.dance', {''})
	end
	if loopsLeft % math.round(getProperty('gfSpeed') * getProperty('haida.danceEveryNumBeats')) == 0 and getProperty('haida.animation.curAnim') ~= nil then
	    callMethod('haida.dance', {''})
	end
    end
end

function math.round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end