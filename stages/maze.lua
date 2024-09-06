function onCreate()
    makeLuaSprite('sky', 'stages/w4/zardy/sky', -650, -650)
    setProperty('sky.antialiasing', false)
    setScrollFactor('sky', 0.5, 0.5)
    addLuaSprite('sky')

    makeLuaSprite('moon', 'stages/w4/zardy/moon', -650, -650)
    setProperty('moon.antialiasing', false)
    setScrollFactor('moon', 0.5, 0.5)
    addLuaSprite('moon')

    makeLuaSprite('farBackplants', 'stages/w4/zardy/backbackPlants', -50, -50)
    setScrollFactor('farBackplants', 0.9, 0.9)
    addLuaSprite('farBackplants')

    makeLuaSprite('backplants', 'stages/w4/zardy/backPlants')
    setProperty('backplants.antialiasing', false)
    setScrollFactor('backplants', 0.95, 0.95)
    addLuaSprite('backplants')

    makeAnimatedLuaSprite('cablecrow', 'stages/w4/zardy/cablecrow', 615, 1150)
    addAnimationByPrefix('cablecrow', 'idle', 'cablecrow', 24, true)
    playAnim('cablecrow', 'idle')
    setProperty('cablecrow.antialiasing', true)
    addLuaSprite('cablecrow')

    makeLuaSprite('ground', 'stages/w4/zardy/ground')
    setProperty('ground.antialiasing', false)
    addLuaSprite('ground')

    makeLuaSprite('fgfence', 'stages/w4/zardy/frontFence')
    setProperty('fgfence.antialiasing', true)
    addLuaSprite('fgfence', true)

    makeLuaSprite('fgplants', 'stages/w4/zardy/frontPlants', 50, 100)
    setProperty('fgplants.antialiasing', true)
    setScrollFactor('fgplants', 1.1, 1.1)
    addLuaSprite('fgplants', true)

    makeLuaSprite('gradient', 'stages/w4/zardy/gradientMULTIPLY')
    setProperty('gradient.antialiasing', true)
    runHaxeCode("game.getLuaObject('gradient').blend = 9;")
    addLuaSprite('gradient', true)

    makeLuaSprite('moonlight', 'stages/w4/zardy/moonlightSCREEN', -650, -650)
    setProperty('moonlight.antialiasing', true)
    setScrollFactor('moonlight', 0.5, 0.5)
    runHaxeCode("game.getLuaObject('moonlight').blend = 12;")
    addLuaSprite('moonlight', true)

    makeLuaSprite('blackScreen', nil)
    makeGraphic('blackScreen', 1, 1, '000000')
    scaleObject('blackScreen', screenWidth * 2, screenHeight * 2)
    setScrollFactor('blackScreen', 0, 0)
    screenCenter('blackScreen', 'XY')
    setObjectCamera('blackScreen', 'camOther')
    addLuaSprite('blackScreen')

    setProperty('skipCountdown', true)
end

function onCreatePost()
    snapCamFollowToPos(1525, 1400, false)
end

function onEvent(eventName, value1, value2)
    if eventName == 'zardyevents' then
	if value1 == 'intro' then
	    doTweenAlpha('introAlpha', 'blackScreen', 0.001, 20, 'expoOut')
	elseif value1 == 'zardyfadein' then
	    doTweenAlpha('dadAlpha', 'dad', 1, 2.5, 'expoOut')
	    for i = 0,3 do startTween('opStrumAlpha'..i, 'opponentStrums.members['..i..']', {alpha = 1}, 2.5, {ease = 'expoOut'})end
	    doTweenAlpha('iconalpha', 'iconP2', 1, 2.5, 'expoOut')
	elseif value1 == 'coolthing' then
	    doTweenAlpha('coolPart', 'dad', 0.5, 2.5, 'expoOut')
	end
    end
end