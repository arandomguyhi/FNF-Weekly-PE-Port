local gaugePercent = 0
local gaugeFull = false

luaDebugMode = true
function onCreatePost()
    setTextFont('scoreTxt', 'BlitzMain.otf')
    setProperty('timeBar.y', -999) setProperty('timeTxt.y', -999)

    setProperty('healthBar.flipX', true) setProperty('healthBar.leftBar.flipX', true) setProperty('healthBar.rightBar.flipX', true)
    for i = 1,2 do setProperty('iconP'..i..'.flipX', not getProperty('iconP'..i..'.flipX'))end

    for i = 0, 3 do
	setProperty('opponentStrums.members['..i..'].visible', false)
    end

    makeAnimatedLuaSprite('gauge', 'splatoon/gauge', 1080, 15)
    addAnimationByPrefix('gauge', 'gauge', 'gauge', 0, false)
    addAnimationByPrefix('gauge', 'specialget', 'specget', 24, false)
    addAnimationByPrefix('gauge', 'special', 'special', 24, true)
    setProperty('gauge.antialiasing', false)
    setObjectCamera('gauge', 'camHUD')
    addLuaSprite('gauge')
    playAnim('gauge', 'gauge')
    setProperty('gauge.animation.curAnim.curFrame', 0)

    makeLuaSprite('splatTimer', 'splatoon/timerbackground', 20, 20)
    setProperty('splatTimer.antialiasing', false)
    setObjectCamera('splatTimer', 'camHUD')
    addLuaSprite('splatTimer')

    makeLuaText('splatTimerTxt', '3:33', 0, 0, 0)
    setTextFont('splatTimerTxt', 'BlitzMain.otf')
    setTextSize('splatTimerTxt', 38)
    setTextAlignment('splatTimerTxt', 'CENTER')
    setObjectCamera('splatTimerTxt', 'camHUD')
    updateHitbox('splatTimerTxt')
    setProperty('splatTimerTxt.x', 45)
    setProperty('splatTimerTxt.y', 16)
    addLuaText('splatTimerTxt')

    makeFlxAnimateSprite('outroAnim', getProperty('boyfriend.x')+100, getProperty('boyfriend.y')+100, 'splatoon/eightEnd')
    addAnimationBySymbol('outroAnim', 'wow', 'splashdownending', 24, false)
    setProperty('outroAnim.alpha', 0.001)
    addLuaSprite('outroAnim')
end

function onUpdate(elapsed)
    if getProperty('gauge.animation.curAnim.name') == 'gauge' and not gaugeFull then
	setProperty('gauge.animation.curAnim.curFrame', gaugePercent)
    elseif getProperty('gauge.animation.curAnim.name') == 'specialget' and getProperty('gauge.animation.finished') and gaugeFull then
	playAnim('gauge', 'special')
	setProperty('gauge.offset.x', 0) setProperty('gauge.offset.y', 0)
    end
end

function onBeatHit()
    if curBeat % 20 == 0 and gaugePercent < 22 and getProperty('gauge.animation.curAnim.name') == 'gauge' and not gaugeFull then
	gaugePercent = gaugePercent + 1
    end
end

function onEvent(name, v1, v2)
    if name == 'Splatoon Events' then
	if v1 == 'Gauge Full' then
	    gaugeFull = true
	    playAnim('gauge', 'specialget')
	    setProperty('gauge.offset.x', 49) setProperty('gauge.offset.y', 49)
	elseif v1 == 'Pop Ult' then
	    setProperty('outroAnim.alpha', 1)
	    playAnim('outroAnim', 'wow')
	end
    end
end

function onUpdatePost()
    local P1Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)
    local P2Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)
    setProperty('iconP1.origin.x', 240) setProperty('iconP1.x', P1Mult - 95)
    setProperty('iconP2.origin.x', -100) setProperty('iconP2.x', P2Mult + 100)
end

function onSpawnNote()
    for i = 0, getProperty('notes.length')-1 do
	if not getPropertyFromGroup('notes', i, 'mustPress') then
	    setPropertyFromGroup('notes', i, 'visible', false)
	end
    end
end