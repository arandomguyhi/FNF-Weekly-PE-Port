local healthdrain = false

luaDebugMode = true
function onCreate()
    addHaxeLibrary('FlxStringUtil', 'flixel.util')

    makeLuaSprite('fg', 'stages/w2/mithrix/foreground')
    setProperty('fg.antialiasing', false)
    addLuaSprite('fg')

    makeFlxAnimateSprite('emotional', 1417, 1054, 'stages/w2/mithrix/mithrixanim')
    addAnimationBySymbol('emotional', 'itemsteal', 'itemsteal', 24, false)
    setProperty('emotional.antialiasing', false)
    setProperty('emotional.visible', false)
    addLuaSprite('emotional')

    makeLuaSprite('rorhud', 'stages/w2/mithrix/rorhud')
    setProperty('rorhud.antialiasing', false)
    setObjectCamera('rorhud', 'camHUD')
    addLuaSprite('rorhud')

    makeLuaText('scoreROR2', 'Score:', 0, 0, 0)
    setTextColor('scoreROR2', 'DBC75B')
    setProperty('scoreROR2.borderColor', getColorFromHex('7C6D1D'))
    setTextAlignment('scoreROR2', 'left')
    setTextFont('scoreROR2', 'bombardier.regular.ttf')
    setTextSize('scoreROR2', 32)
    setProperty('scoreROR2.x', 25)
    setProperty('scoreROR2.borderSize', 2)
    updateHitbox('scoreROR2')
    setProperty('scoreROR2.y', 30)
    addLuaText('scoreROR2')

    makeLuaText('accuracyROR2', 'Accuracy:', 0, 0, 0)
    setTextColor('accuracyROR2', 'B7C9D9')
    setProperty('accuracyROR2.borderColor', getColorFromHex('444E56'))
    setTextAlignment('accuracyROR2', 'left')
    setTextFont('accuracyROR2', 'bombardier.regular.ttf')
    setTextSize('accuracyROR2', 32)
    setProperty('accuracyROR2.x', 25)
    setProperty('accuracyROR2.borderSize', 2)
    updateHitbox('accuracyROR2')
    setProperty('accuracyROR2.y', 108)
    addLuaText('accuracyROR2')

    makeLuaText('missesROR2', 'Misses:', 0, 0, 0)
    setTextColor('missesROR2', 'EF2E2B')
    setProperty('missesROR2.borderColor', getColorFromHex('961B1B'))
    setTextAlignment('missesROR2', 'left')
    setTextFont('missesROR2', 'bombardier.regular.ttf')
    setTextSize('missesROR2', 32)
    setProperty('missesROR2.x', 25)
    setProperty('missesROR2.borderSize', 2)
    updateHitbox('missesROR2')
    setProperty('missesROR2.y', 188)
    addLuaText('missesROR2')

    makeLuaText('comboROR2', 'Combo: 0', 0, 0, 0)
    setTextColor('comboROR2', '000000')
    setProperty('comboROR2.borderColor', getColorFromHex('961B1B'))
    setTextAlignment('comboROR2', 'left')
    setTextFont('comboROR2', 'bombardier.regular.ttf')
    setTextSize('comboROR2', 48)
    setProperty('comboROR2.x', 25)
    setProperty('comboROR2.borderSize', 0)
    updateHitbox('comboROR2')
    setProperty('comboROR2.y', 560)
    addLuaText('comboROR2')

    makeLuaText('timeROR2', 'time', 0, 0, 0)
    setTextColor('timeROR2', '000000')
    setProperty('timeROR2.borderColor', getColorFromHex('961B1B'))
    setTextAlignment('timeROR2', 'left')
    setTextFont('timeROR2', 'bombardier.regular.ttf')
    setTextSize('timeROR2', 48)
    setProperty('timeROR2.x', 1075)
    setProperty('timeROR2.borderSize', 0)
    updateHitbox('timeROR2')
    setProperty('timeROR2.y', 25)
    addLuaText('timeROR2')

    makeLuaText('timeTxtROR2', '0:00', 0, 0, 0)
    setTextColor('timeTxtROR2', '000000')
    setProperty('timeTxtROR2.borderColor', getColorFromHex('961B1B'))
    setTextAlignment('timeTxtROR2', 'center')
    setTextFont('timeTxtROR2', 'bombardier.regular.ttf')
    setTextSize('timeTxtROR2', 48)
    setProperty('timeTxtROR2.x', 1075)
    setProperty('timeTxtROR2.borderSize', 0)
    updateHitbox('timeTxtROR2')
    setProperty('timeTxtROR2.y', 70)
    addLuaText('timeTxtROR2')

    setProperty('skipCountdown', true)
end

function onCreatePost()
    makeLuaSprite('item', 'stages/w2/mithrix/hat_item', 2150, 1075)
    setProperty('item.antialiasing', true)
    setProperty('item.visible', false)
    addLuaSprite('item', true)

    for i = 0, 3 do
	setProperty('opponentStrums.members['..i..'].alpha', 0.001)
	setPropertyFromGroup('notes', i, 'copyAlpha', true)

	setPropertyFromGroup('playerStrums', i, 'x', 417 + (112 * (i % 4)))
    end

    setProperty('timeBar.y', -1000)
    setProperty('scoreTxt.y', -1000)
    setProperty('timeTxt.y', -1000)
    setProperty('healthBar.x', 25)
    setProperty('healthBar.angle', 180)
    setProperty('healthBar.y', 618)
    setProperty('healthBar.scale.x', 0.6)
    setProperty('healthBar.scale.y', 1.15)
    setProperty('healthBar.bg.scale.x', 0.6)
    setProperty('healthBar.bg.scale.y', 1.15)
    updateHitbox('healthBar')
    --updateHitbox('healthBar')
    setProperty('comboGroup.visible', false)
end

function onUpdatePost(elapsed)
    local curTime = getSongPosition() - getPropertyFromClass('backend.ClientPrefs', 'data.noteOffset')
	if curTime < 0 then curTime = 0 end
    local songCalc = (getProperty('songLength') - curTime)
    local secondsTotal = math.floor(songCalc / 1000)
	if secondsTotal < 0 then secondsTotal = 0 end

    setTextString('scoreROR2', 'Score: '..getProperty('songScore'))
    setTextString('accuracyROR2', 'Accuracy: '..(math.floor(getProperty('ratingPercent') * 100))..'%')
    setTextString('missesROR2', 'Misses: '..getProperty('songMisses'))
    setTextString('timeTxtROR2', formatTime(secondsTotal, false))
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if not isSustainNote then
	setTextString('comboROR2', 'Combo: '..getPropertyFromGroup('notes', id, 'rating')..' '..combo)
    end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if healthdrain then
	if getProperty('healthBar.percent') > 20 and not isSustainNote then
	    setProperty('health', getProperty('health')-0.007)
	end
    end
end

function noteMiss()
    setTextString('comboROR2', 'Combo: '..combo)
end

local allowedToZ = true
function onMoveCamera(target)
    if allowedToZ then
	setProperty('defaultCamZoom', target == 'dad' and 0.9 or 0.8)
    end
end

function onEvent(eventName, value1, value2)
    if eventName == 'mithrixshit' then
	if value1 == 'sillystyle' then
	    allowedToZ = false
	    setProperty('defaultCamZoom', 0.95)
	    setProperty('dad.visible', false)
	    setProperty('emotional.visible', true)
	    setProperty('camFollow.x', 1355) setProperty('camFollow.y', 1110)
	    playAnim('emotional', 'itemsteal')
	    setProperty('isCameraOnForcedPos', true)
	    triggerEvent('Alt Idle Animation', '', '-alt')
	    triggerEvent('Alt Idle Animation', 'bf', '-alt')
	    startTween('itemtween', 'item', {x = 1375, y = 800}, 1.25, {ease = 'expoOut', startDelay = 2.2, onComplete = 'enditem', onStart = 'startitem'})
	    function enditem() setProperty('item.visible', false) end
	    function startitem()
		setProperty('item.visible', true)
	 	healthdrain = true
		setProperty('healthGain', false)
	    end
	elseif value1 == 'animend' then
	    allowedToZ = true
	    setProperty('isCameraOnForcedPos', false)
	    setProperty('dad.visible', true)
	    setProperty('emotional.visible', false)
	end
    end
end

function formatTime(seconds, showMs)
    -- this is alot easier, isn't? lmao
    return runHaxeCode("FlxStringUtil.formatTime("..seconds..", "..tostring(showMs)..");")
end