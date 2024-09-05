luaDebugMode = true
function onCreate()
    makeAnimatedLuaSprite('skyScary', 'celeste/emotional', -3400, -230)
    addAnimationByPrefix('skyScary', 'loop', 'emotional', 24, true)
    playAnim('skyScary', 'loop')
    setScrollFactor('skyScary', 0.8, 0.8)
    addLuaSprite('skyScary')

    makeFlxAnimateSprite('tentacle', 500, -400, 'celeste/hair')
    addAnimationBySymbol('tentacle', 'loop', 'loop', 24, true)
    setProperty('tentacle.antialiasing', true)
    addLuaSprite('tentacle')

    makeLuaSprite('sky', 'celeste/sky', -570, -230)
    setScrollFactor('sky', 0.8, 0.8)
    addLuaSprite('sky')

    makeLuaSprite('floor', 'celeste/floor', -600, -50)
    setGraphicSize('floor', 2077*1.3, 1151*1.3, false)
    addLuaSprite('floor')

    makeLuaSprite('overlay', 'celeste/overlay')
    setScrollFactor('overlay', 0, 0)
    setGraphicSize('overlay', 1280*1.25, 720*1.25, false)
    setProperty('overlay.alpha', 0.5)
    setBlendMode('overlay', 'add')
    addLuaSprite('overlay', true)
end

function onCreatePost()
    setObjectCamera('comboGroup', 'camGame')
    setProperty('comboGroup.x', -200) setProperty('comboGroup.y', 150)

    setProperty('healthBar.flipX', true) setProperty('healthBar.leftBar.flipX', true) setProperty('healthBar.rightBar.flipX', true)
    for i = 1,2 do setProperty('iconP'..i..'.flipX', not getProperty('iconP'..i..'.flipX'))end
    setTextFont('scoreTxt', 'Renogare.ttf')
    setTextFont('timeTxt', 'Renogare.ttf')
    setProperty('timeTxt.y', getProperty('timeTxt.y')+4)

    setProperty('camFollow.x', 350) setProperty('camFollow.y', 400) setProperty('cameraSpeed', 1000)

    for i = 0, 3 do
	setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i])
	setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i])
    end
end

function onSongStart() setProperty('cameraSpeed', 1)end

function onStepHit() if curStep == 1 then cameraSetTarget('boyfriend') end end
local s = 1
function onUpdatePost(elapsed)
    s = s + elapsed
    setProperty('dad.x', lerp(getProperty('dad.x'), getProperty('dad.x') + (math.sin(s) * -7), boundTo(1, 0, elapsed * 4)))
    setProperty('dad.y', lerp(getProperty('dad.y'), getProperty('dad.y') + (math.cos(s) * 7), boundTo(1, 0, elapsed * 4)))

    local P1Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)
    local P2Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)
    setProperty('iconP1.origin.x', 240) setProperty('iconP1.x', P1Mult - 115)
    setProperty('iconP2.origin.x', -100) setProperty('iconP2.x', P2Mult + 100)
end

function onEvent(name, value1, value2)
    if name == 'Pink' then
	if value1 == 'dash' then
	    runTimer('scaryTimer', 0.6)
	end
    end
end

function onTimerCompleted(tag)
    if tag == 'scaryTimer' then
	doTweenAlpha('skyTween', 'sky', 0.001, 1.3, 'expoOut')
	doTweenAlpha('overlayAlpha', 'overlay', 0.001, 1.3, 'expoOut')
	playAnim('tentacle', 'loop')
    end
end

function lerp(a,b,ratio)
    return a + ((b-a)*ratio)
end

function boundTo(value, min, max)
    return math.max(min, math.min(max, value))
end