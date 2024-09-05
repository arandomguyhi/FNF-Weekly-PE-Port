local PREFIX = 'siiva/'

local colours = {'e64c44', 'f3ad52', 'f3f163', '4fed34', '34edd4', '61A4F0', 'ac34ed', 'ed34cb'}
local curColour = 0
local gay = false

function onCreate()
    setProperty('skipCountdown', true)

    makeLuaSprite('bg', PREFIX..'sky', -600, -300)
    setScrollFactor('bg', 0.1, 0.1)
    addLuaSprite('bg')

    makeLuaSprite('lighthouse', PREFIX..'bg', -600, 100)
    setScrollFactor('lighthouse', 0.3, 0.3)
    addLuaSprite('lighthouse')

    makeLuaSprite('lights', PREFIX..'blammed', -580, 115)
    setScrollFactor('lights', 0.3, 0.3)
    addLuaSprite('lights')

    makeLuaSprite('foreground', PREFIX..'ground', -500, 700)
    addLuaSprite('foreground')

    makeLuaSprite('fade', nil)
    makeGraphic('fade', screenWidth, screenHeight, '000000')
    setObjectCamera('fade', 'camOther')
    addLuaSprite('fade')

    makeLuaSprite('fnaf', PREFIX..'thumbnail')
    setObjectCamera('fnaf', 'camOther')
    setProperty('fnaf.alpha', 0.001)
    addLuaSprite('fnaf')
end

function onCreatePost()
    setProperty('camHUD.alpha', 0.001)

    makeLuaSprite('black', nil, -100, -100)
    makeGraphic('black', 3000, 3000, '000000')
    setProperty('black.alpha', 0.001)
    addLuaSprite('black')

    setObjectCamera('comboGroup', 'camGame')
    setProperty('comboGroup.x', 300)
    setProperty('comobGroup.y', 250)
end

function onEvent(name, v1, v2)
    if name == 'SiIva Events' then
	-- circus
	if v1 == 'hi circus' then
	    setProperty('fnaf.alpha', 1)
            setProperty('defaultCamZoom', 1.6)
	elseif v1 == 'bye circus' then
	    doTweenAlpha('circusend', 'fnaf', 0.001, 0.3)
	-- intro
	elseif v1 == 'hi friends' then
	    setProperty('isCameraOnForcedPos', true)
	    snapCamFollowToPos(800, 100)
	    doTweenAlpha('unfade', 'fade', 0.001, 1.2)
	elseif v1 == 'zoom out' then
	    local daY = 400
	    local daEase = 'quadInOut'

	    startTween('camFollowTween', 'camFollow', {y = daY}, 0.48 * 12, {ease = daEase})
	    startTween('zoomTween', 'game', {defaultCamZoom = 0.7}, 0.48 * 12, {ease = daEase})
	elseif v1 == 'hud fade in' then
	    doTweenAlpha('fadeHud', 'camHUD', 1, 0.48 * 2)
	elseif v1 == 'start gaming' then
	    setProperty('defaultCamZoom', 0.8)
	    setProperty('isCameraOnForcedPos', false)
	elseif v1 == 'Lighthouse Flash' then
	    gay = true
	elseif v1 == 'Stop Flash' then
	    gay = false
	-- fake game over
	elseif v1 == 'zoom in' then
	    setProperty('isCameraOnForcedPos', true)

	    local daX = getProperty('boyfriend.x') + 150
	    local daY = getProperty('boyfriend.y') + 350
	    local daEase = 'expoIn'

	    startTween('gameOverCamFollowPos', 'camFollow', {x = daX, y = daY}, 0.48 * 2, {ease = daEase})
	    startTween('tweenZoom', 'game', {defaultCamZoom = 0.95}, 0.48 * 2, {ease = daEase})
	elseif v1 == 'DIE DIE DIE' then
	    setProperty('isCameraOnForcedPos', true)
	    setProperty('camHUD.alpha', 0.001)
	    setProperty('black.alpha', 1)
	    playAnim('boyfriend', 'dead', true) setProperty('boyfriend.specialAnim', true)

	    setProperty('dad.alpha', 0.001)
	    setProperty('comboGroup.alpha', 0.001)
	elseif v1 == 'bye friend' then
	    doTweenAlpha('endTheSong', 'boyfriend', 0.001, 0.48 * 4)
	end
    end
end

function onBeatHit()
    if gay then
	doTweenColor('lightsColours', 'lights', colours[curColour], 0.3, 'linear')
	--curColour = getRandomInt(1, #colours)
	curColour = (curColour + 1) % table.maxn(colours)
    else
	setProperty('lights.color', 0xFFFFFF)
    end
end

function snapCamFollowToPos(posx, posy)
    setProperty('camFollow.x', posx)
    setProperty('camFollow.y', posy)
    setProperty('cameraSpeed', 1000)
    runTimer('cameraSpeed', 0.05)
end

function onTimerCompleted(tag)
    if tag == 'cameraSpeed' then
	setProperty('cameraSpeed', 1)
    end
end