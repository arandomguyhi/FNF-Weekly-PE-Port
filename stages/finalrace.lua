local isDomo = false
local isDomo1 = false

luaDebugMode = true
function onCreate()
    makeLuaSprite('galaxy', 'stages/w7/ducklife/galaxy', -900, -400)
    setProperty('galaxy.antialiasing', true)
    setScrollFactor('galaxy', 0.5, 0.5)
    addLuaSprite('galaxy')

    makeLuaSprite('stage', 'stages/w7/ducklife/stage', -300, 1050)
    setProperty('stage.antialiasing', true)
    addLuaSprite('stage')

    makeAnimatedLuaSprite('domo', 'stages/w7/ducklife/domo', 2200, 850)
    addAnimationByPrefix('domo', 'idle', 'domo', 24, false)
    playAnim('domo', 'idle')
    setProperty('domo.antialiasing', true)
    addLuaSprite('domo')

    makeAnimatedLuaSprite('domo1', 'stages/w7/ducklife/domo', 0, 850)
    addAnimationByPrefix('domo1', 'idle', 'domo', 24, false)
    playAnim('domo1', 'idle')
    setProperty('domo1.antialiasing', true)
    setProperty('domo1.flipX', true)
    addLuaSprite('domo1')

    makeAnimatedLuaSprite('domojet', 'stages/w7/ducklife/domojet', 275, -300)
    addAnimationByPrefix('domojet', 'idle', 'flyingdomo', 24, false)
    playAnim('domojet', 'idle')
    setProperty('domojet.antialiasing', true)
    addLuaSprite('domojet')

    makeAnimatedLuaSprite('domojet1', 'stages/w7/ducklife/domojet', 1850, -300)
    addAnimationByPrefix('domojet1', 'idle', 'flyingdomo', 24, false)
    playAnim('domojet1', 'idle')
    setProperty('domojet1.antialiasing', true)
    setProperty('domojet1.flipX', true)
    addLuaSprite('domojet1')
end

function onCreatePost()
    setProperty('camGame.scroll.x', 1200 - (screenWidth / 2))
    setProperty('camGame.scroll.y', 900 - (screenHeight / 2))
end

function onBeatHit()
    if curBeat % 2 == 0 then
	playAnim('domo', 'idle', true)
	playAnim('domo1', 'idle', true)
    end
end

function onSongStart()
    playAnim('domo', 'idle', true)
    playAnim('domo1', 'idle', true)
end

function onCountdownTick(swagCounter)
    if swagCounter % 2 == 0 then
	playAnim('domo', 'idle', true)
	playAnim('domo1', 'idle', true)
    end
end

function onEvent(name, v1, v2)
    if name == 'Duck Events' then
	if v1 == 'domojet' then
	    doTweenY('domoJetTween', 'domojet', 250, 1.5, 'expoOut')
	elseif v1 == 'domojet1' then
	    doTweenY('domoJet1Tween', 'domojet1', 250, 1.5, 'expoOut')
	end
    end
end

local s = 1
local skY = 280
function onUpdate(elapsed)
    s = s + elapsed
    if isDomo then
	setProperty('domojet.y', lerp(getProperty('domojet.y'), skY + (math.cos(s) * 65), boundTo(1, 0, elapsed * 4)))
    end
    if isDomo1 then
	setProperty('domojet1.y', lerp(getProperty('domojet1.y'), skY + (math.cos(s) * 65), boundTo(1, 0, elapsed * 4)))
    end
end

function onTweenCompleted(tag)
    if tag == 'domoJetTween' then
	isDomo = true
    elseif tag == 'domoJet1Tween' then
	isDomo1 = true
    end
end

function lerp(a,b,ratio)
    return a + ((b-a)*ratio)
end

function boundTo(value, min, max)
    return math.max(min, math.min(max, value))
end