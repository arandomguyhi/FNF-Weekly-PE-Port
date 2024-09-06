function onCreate()
    makeLuaSprite('sky', 'stages/w4/minus/sky', -600, -300)
    setProperty('sky.antialiasing', true)
    setScrollFactor('sky', 0.5, 0.5)
    addLuaSprite('sky')

    makeLuaSprite('back', 'stages/w4/minus/back', -700, -100)
    setProperty('back.antialiasing', true)
    setScrollFactor('back', 0.8, 0.8)
    addLuaSprite('back')

    makeAnimatedLuaSprite('crowd', 'stages/w4/minus/crowd', -650, 480)
    setProperty('crowd.antialiasing', true)
    addAnimationByPrefix('crowd', 'idle', 'crowd', 24, false)
    setScrollFactor('crowd', 0.9, 0.9)
    addLuaSprite('crowd')

    makeLuaSprite('front', 'stages/w4/minus/front', -900, 100)
    setProperty('front.antialiasing', true)
    addLuaSprite('front')
end

function onBeatHit()
    if curBeat % 2 == 0 then
	playAnim('crowd', 'idle', true)
    end
end

function onSongStart()
    playAnim('crowd', 'idle', true)
end

function onCountdownTick(counter)
    if counter % 2 == 0 then playAnim('crowd', 'idle', true) end
end