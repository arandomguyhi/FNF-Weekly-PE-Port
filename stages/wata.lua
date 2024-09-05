local prefix = 'stages/w9/watamote/'
local skipIntro = false

local strumPosX = {}
local strumPosY = {}

luaDebugMode = true
function onCreate()
    makeLuaSprite('bg', prefix..'tomoko_bg_1')
    setScrollFactor('bg', 0.85, 0.85)
    screenCenter('bg', 'XY')
    setProperty('bg.x', getProperty('bg.x')-20)
    addLuaSprite('bg')

    makeLuaSprite('black2', nil)
    makeGraphic('black2', 600, 1000, '000000')
    setScrollFactor('black2', 0, 0)
    screenCenter('black2', 'Xy')
    addLuaSprite('black2', true)
    if skipIntro then setProperty('black2.alpha', 0) end

    makeLuaSprite('fg', prefix..'tomoko_bg_2')
    screenCenter('fg', 'XY')
    addLuaSprite('fg', true)
end

function onCreatePost()
    setProperty('skipCountdown', true)
    setProperty('dad.visible', false)

    makeLuaSprite('black', nil)
    makeGraphic('black', screenWidth, screenHeight, 'ffffff')
    setObjectCamera('black', 'camOther')
    addLuaSprite('black')
    setProperty('black.color', getColorFromHex('000000'))
    if skipIntro then setProperty('black.alpha', 0.001) end

    setProperty('camHUD.alpha', 0.001)
    setProperty('iconP2.visible', false)

    setObjectCamera('comboGroup', 'camGame')
end

function onSongStart()
    if not skipIntro then
	doTweenAlpha('unblackie', 'black', 0.001, 35, 'quadInOut')
	runHaxeCode([[
	    FlxTween.num(game.defaultCamZoom, 0.625, 35, {ease: FlxEase.quadInOut, onUpdate: (t)-> {
		game.camGame.zoom = t.value;
            }});
	]])

	startTween('unblackie2', 'black2', {alpha = 0.001}, 30, {ease = 'quadInOut', startDelay = 20})
	startTween('hudtween', 'camHUD', {alpha = 1}, 5, {ease = 'quadInOut', startDelay = 18})
    else
	setProperty('camGame.zoom', 0.625)
	setProperty('camHUD.alpha', 1)
    end

    for i = 0, 3 do
	setPropertyFromGroup('playerStrums', i, 'x', 417 + (112 * (i % 4)))
	setPropertyFromGroup('opponentStrums', i, 'visible', false)
    end
end

function onStepHit()
    if curStep == 1560 then
	setObjectCamera('black', 'camHUD')
	setProperty('black.alpha', 1)

	for i = 0,3 do
	    noteTweenX('dropTime'..i+4, i+4, _G['defaultPlayerStrumX'..i], (stepCrochet / 1000) * 4, 'quadOut')
	end
    elseif curStep == 1568 then
	setProperty('black.alpha', 0.001)
	setProperty('black2.alpha', 0.001)
	setProperty('bg.alpha', 0.001)
	setProperty('fg.alpha', 0.001)

	setProperty('camGame.zoom', 0.85)
	setScrollFactor('boyfriendGroup', 0, 0)
	setProperty('boyfriendGroup.x', getProperty('boyfriendGroup.x')-650)
	setProperty('boyfriendGroup.y', getProperty('boyfriendGroup.y')-20)

	cameraFlash('camGame', 'FFFFFF', 0.5)
    end

    if curStep == 2080 then
	local everything = {'boyfriend', 'camHUD'}
	local two = 0
	for _, item in pairs(everything) do
	    startTween('endingtween', item, {alpha = 0.001}, 10, {ease = 'quadInOut', startDelay = two})
	    two = two + 10
	end
    end
end

function math.fastCos(value)
    return runHaxeCode("FlxMath.fastCos("..value..");")
end