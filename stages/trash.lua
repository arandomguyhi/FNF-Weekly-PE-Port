local prefix = 'stages/w2/spamton/'
local isRunning = false

luaDebugMode = true
function onCreate()
    addCharacterToList('bf-delta-walk', 'boyfriend')

    makeLuaSprite('white', nil)
    makeGraphic('white', screenWidth, screenHeight, 'FFFFFF')
    setObjectCamera('white', 'camHUD')
    setProperty('white.alpha', 0.001)

    makeLuaSprite('bg', prefix..'bgmain')
    makeLuaSprite('phone', prefix..'phone', 1250) setScrollFactor('phone', 0.9, 0.9)
    makeLuaSprite('garbage', prefix..'garbage', 100, 800) setScrollFactor('garbage', 1.1, 1.1)

    makeLuaSprite('scrollBG1', prefix..'bgscroll', 0, -380)
    setProperty('scrollBG1.alpha', 0.001)
    makeLuaSprite('scrollBG2', prefix..'bgscroll', getProperty('scrollBG1.width'), -380)
    setProperty('scrollBG2.alpha', 0.001)

    makeAnimatedLuaSprite('legs', prefix..'deltabf_legs')
    addAnimationByPrefix('legs', 'idle', 'fnfwalklegs0', 24, true)
    setProperty('legs.alpha', 0.001)

    addLuaSprite('white')
    addLuaSprite('scrollBG1')
    addLuaSprite('scrollBG2')
    addLuaSprite('phone')
    addLuaSprite('bg')
    addLuaSprite('legs')

    precacheSound('bepis-yoink')
    precacheSound('WindChime')
end

function onEvent(eventName, v1, v2)
    if eventName == 'Spamton Triggers' then
	if v1 == 'yoink' then
	    setProperty('defaultCamZoom', 0.75)
	    playAnim('boyfriend', 'yoink', true)
	    setProperty('boyfriend.specialAnim', true)
	    playSound('bepis-yoink')
	elseif v1 == 'angry' then
	    playAnim('dad', 'angry', true)
	    setProperty('dad.specialAnim', true)
	elseif v1 == 'start fade' then
	    doTweenAlpha('whiteFade', 'white', 1, 1)
	    playSound('WindChime', 0.6)
	elseif v1 == 'run' then
	    startRunning()
	    doTweenAlpha('whiteUnfade', 'white', 0.001, 1)
	end
    end
end

function startRunning()
    setProperty('defaultCamZoom', 0.8)

    triggerEvent('Alt Idle Animation', 'dad', '-run')
    playAnim('dad', 'idle-run', true)
    triggerEvent('Change Character', 'bf', 'bf-delta-walk')
    setProperty('boyfriend.x', getProperty('boyfriend.x') + 200)

    setProperty('legs.x', getProperty('boyfriend.x') + 93)
    setProperty('legs.y', getProperty('boyfriend.y') + 260)
    setProperty('legs.alpha', 1)

    setProperty('bg.alpha', 0.001)
    setProperty('phone.alpha', 0.001)
    setProperty('garbage.alpha', 0.001)

    setProperty('scrollBG1.alpha', 1)
    setProperty('scrollBG2.alpha', 1)

    isRunning = true
end

function onUpdatePost(elapsed)
    if isRunning then
	setProperty('scrollBG1.x', getProperty('scrollBG1.x') - elapsed * 1800)
	setProperty('scrollBG2.x', getProperty('scrollBG2.x') - elapsed * 1800)

	if getProperty('scrollBG1.x') < -4000 then setProperty('scrollBG1.x', getProperty('scrollBG1.x') + getProperty('scrollBG1.width') * 2) end
	if getProperty('scrollBG2.x') < -4000 then setProperty('scrollBG2.x', getProperty('scrollBG2.x') + getProperty('scrollBG2.width') * 2) end
    end
end

function onCreatePost()
    addLuaSprite('garbage')
end