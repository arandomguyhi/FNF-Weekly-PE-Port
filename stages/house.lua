luaDebugMode = true
function onCreate()
    isMiddlescroll = getPropertyFromClass('backend.ClientPrefs', 'data.middleScroll')

    makeLuaSprite('BG', 'oni/hallway')
    scaleObject('BG', 3, 3)
    updateHitbox('BG')
    setProperty('BG.antialiasing', false)
    addLuaSprite('BG')

    makeLuaSprite('blackScreen', nil)
    makeGraphic('blackScreen', 1, 1, '000000')
    scaleObject('blackScreen', getProperty('BG.width'), getProperty('BG.height'))
    updateHitbox('blackScreen')
    addLuaSprite('blackScreen', true)

    makeLuaSprite('house', 'oni/house')
    setScrollFactor('house', 0, 0)
    screenCenter('house', 'xy')
    setProperty('house.antialiasing', true)
    setObjectCamera('house', 'camOther')
    addLuaSprite('house')

    setPropertyFromClass('backend.ClientPrefs', 'data.middleScroll', true)

    setProperty('camHUD.alpha', 0.001)
    setProperty('skipCountdown', true)
end

function onCreatePost()
    setProperty('camFollow.x', 185) setProperty('camFollow.y', 478)
    setProperty('isCameraOnForcedPos', true)
    for i = 0, 3 do
	setProperty('opponentStrums.members['..i..'].visible', false)
    end
    setProperty('iconP1.visible', false)
    setProperty('iconP2.visible', false)

    setObjectCamera('comboGroup', 'camGame')
    setProperty('comboGroup.x', 50) setProperty('comboGroup.y', 100)
end

function onEvent(name, value1, value2)
    if name == 'Ao Oni' then
	if value1 == 'fadein' then
	    startTween('houseTween', 'house', {alpha = 0.001}, 3, {startDelay = 3})
	elseif value1 == 'start' then
	    setProperty('blackScreen.alpha', 0.5)
	    doTweenAlpha('hudTween', 'camHUD', 1, 0.5, 'linear')
	elseif value1 == 'going dark' then
	    doTweenAlpha('itsDark', 'blackScreen', 1, 0.5, 'linear')
	elseif value1 == 'suddenly back' then
	    setProperty('blackScreen.alpha', 0.5)
	end
    end
end

function onSpawnNote()
    for i = 0, getProperty('notes.length')-1 do
	if not getPropertyFromGroup('notes', i, 'mustPress') then
	    setPropertyFromGroup('notes', i, 'visible', false)
	end
    end
end

function onDestroy()
    setPropertyFromClass('backend.ClientPrefs', 'data.middleScroll', isMiddlescroll)
end