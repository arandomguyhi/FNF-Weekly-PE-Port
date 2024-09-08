luaDebugMode = true
function onCreate()
    makeLuaSprite('bg', 'stages/w2/skullkid/BG', 0, 0)
    setProperty('bg.antialiasing', true)
    addLuaSprite('bg')

    setProperty('skipCountdown', true)
end

function onCreatePost()
    snapCamFollowToPos(790, 509, true);
    for i = 0,7 do
	scaleObject('strumLineNotes.members['.. i..']', 3, 3, false)
	setPropertyFromGroup('opponentStrums', i-4, 'x', _G['defaultPlayerStrumX'..i%4]+35)
	setPropertyFromGroup('playerStrums', i-4, 'x', _G['defaultOpponentStrumX'..i%4]+35)
	setPropertyFromGroup('opponentStrums', i-4, 'y', _G['defaultPlayerStrumY'..i%4]+35)
	setPropertyFromGroup('playerStrums', i-4, 'y', _G['defaultOpponentStrumY'..i%4]+35)
    end
end

function onSpawnNote()
    for i = 0, getProperty('notes.length')-1 do
	setPropertyFromGroup('notes', i, 'scale.x', 3)
	setPropertyFromGroup('notes', i, 'scale.y', 3)

	setPropertyFromGroup('notes', i, 'noteSplashData.disabled', true)
    end
end

local s = 1
local skY = 225
function onUpdate(elapsed)
    s = s + elapsed
    setProperty('dad.y', lerp(getProperty('dad.y'), skY + (math.cos(s) * 65), boundTo(1, 0, elapsed * 4)))
end

function lerp(a,b,ratio)
    return a + ((b-a)*ratio)
end

function boundTo(value, min, max)
    return math.max(min, math.min(max, value))
end