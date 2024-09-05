local walkDown = false

luaDebugMode = true
function onCreate()
    makeLuaSprite('bgtile1', 'stages/w9/bocchibg', 1000, -450)
    setProperty('bgtile1.antialiasing', true)
    scaleObject('bgtile1', 0.75, 0.75)
    updateHitbox('bgtile1')
    addLuaSprite('bgtile1')

    makeLuaSprite('bgtile2', 'stages/w9/bocchibg', getProperty('bgtile1.x') - 1810, -450)
    setProperty('bgtile2.antialiasing', true)
    scaleObject('bgtile2', 0.75, 0.75)
    updateHitbox('bgtile2')
    addLuaSprite('bgtile2')

    makeLuaSprite('bgtile3', 'stages/w9/bocchibg', getProperty('bgtile2.x') - 1810, -450)
    setProperty('bgtile3.antialiasing', true)
    scaleObject('bgtile3', 0.75, 0.75)
    updateHitbox('bgtile3')
    addLuaSprite('bgtile3')
end

function onCreatePost()
    setProperty('camFollow.x', 1200) setProperty('camFollow.y', 130)
    setProperty('isCameraOnForcedPos', true)

    setObjectCamera('comboGroup', 'camGame')

    makeLuaSprite('barTop', nil)
    makeGraphic('barTop', screenWidth * 2, 68, '000000')
    screenCenter('barTop', 'X')
    setObjectCamera('barTop', 'camHUD')

    makeLuaSprite('barBottom', nil)
    makeGraphic('barBottom', screenWidth * 2, 68, '000000')
    screenCenter('barBottom', 'X')
    setObjectCamera('barBottom', 'camHUD')
    setProperty('barBottom.y', 652)

    addLuaSprite('barTop')
    addLuaSprite('barBottom')

    setProperty('skipCountdown', true)
end

function onUpdate(elapsed)
    setProperty('bgtile1.x', getProperty('bgtile1.x') + elapsed * 100)
    setProperty('bgtile2.x', getProperty('bgtile2.x') + elapsed * 100)
    setProperty('bgtile3.x', getProperty('bgtile3.x') + elapsed * 100)

    if getProperty('bgtile1.x') > 2810 then setProperty('bgtile1.x', -2620) end
    if getProperty('bgtile2.x') > 2810 then setProperty('bgtile2.x', -2620) end
    if getProperty('bgtile3.x') > 2810 then setProperty('bgtile3.x', -2620) end
end

function onBeatHit()
    if curBeat % 2 == 0 then
	walkDown = not walkDown

	if walkDown then
	    setProperty('boyfriendGroup.y', -65)
	    setProperty('dadGroup.y', -185)
	else
	    setProperty('boyfriendGroup.y', -85)
	    setProperty('dadGroup.y', -200)
	end
    end
end