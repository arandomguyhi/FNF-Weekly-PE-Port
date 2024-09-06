local dadPos = {}
local ringPos = {}

luaDebugMode = true
function onCreate()
    local list = {'BG', 'Ass1', 'Ass2', 'Ring1'}
    for i = 1, #list do
	makeLuaSprite('s'..i, 'stages/w4/shaggy/'..list[i])
	scaleObject('s'..i, 2.5, 2.5)
	if list[i] == 'Ring1' then scaleObject('s'..i, 3, 3) setProperty('s'..i..'.x', getProperty('s'..i..'.x') + 200) end
	screenCenter('s'..i, 'XY')
	if list[i] == 'Ass2' then setProperty('s'..i..'.x', getProperty('s'..i..'.x') - 100) end
	setProperty('s'..i..'.antialiasing', true)
	if list[i] ~= 'Ring1' then setScrollFactor('s'..i, 0.2 + (i * 0.2), 0.2 + (i * 0.2)) end
	addLuaSprite('s'..i)
    end

    makeLuaSprite('ring', 'stages/w4/shaggy/Ring2')
    scaleObject('ring', 3, 3)
    screenCenter('ring', 'XY')
    setProperty('ring.antialiasing', true)
    setProperty('ring.x', getProperty('ring.x') - 200)
    addLuaSprite('ring')
end

function onCreatePost()
    dadPos = {getProperty('dad.x'), getProperty('dad.y')}
    ringPos = {getProperty('ring.x'), getProperty('ring.y') + 100}

    snapCamFollowToPos(500, 200, false)
end

local speed = 0.2
local intensity = 100
local e = 0
function onUpdate(elapsed)
    e = e + 0.1
    setProperty('dad.x', dadPos[1] + math.cos(e * speed / (getPropertyFromClass('flixel.FlxG', 'updateFramerate') / 60)) * intensity)
    setProperty('ring.x', ringPos[1] + math.cos(e * speed / (getPropertyFromClass('flixel.FlxG', 'updateFramerate') / 60)) * intensity)
    setProperty('dad.y', dadPos[2] + math.sin(e * speed / (getPropertyFromClass('flixel.FlxG', 'updateFramerate') / 60)) * intensity)
    setProperty('ring.y', ringPos[2] + math.sin(e * speed / (getPropertyFromClass('flixel.FlxG', 'updateFramerate') / 60)) * intensity)
end