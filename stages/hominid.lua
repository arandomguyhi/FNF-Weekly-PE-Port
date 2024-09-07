local prefix = 'stages/w3/hominid/'

local daScale = 1.75
local holicameo
local helitrigger

function onCreate()
    makeLuaSprite('sky', prefix..'sky', 0, -300)
    setScrollFactor('sky', 0.5, 0.5)
    scaleObject('sky', daScale, daScale, false)
    setProperty('sky.active', false)
    addLuaSprite('sky')

    makeLuaSprite('backbuildings', prefix..'distand_buildings', 100, -350)
    setScrollFactor('backbuildings', 0.8, 0.8)
    scaleObject('backbuildings', daScale, daScale, false)
    setProperty('backbuildings.active', false)
    addLuaSprite('backbuildings')

    makeAnimatedLuaSprite('helicopter', prefix..'helicopters', -725, -100)
    setProperty('helicopter.antialiasing', true)
    addAnimationByPrefix('helicopter', '1', 'helicopter_tweak', 24, true)
    addAnimationByPrefix('helicopter', '2', 'helicopter_funny', 24, true)
    addAnimationByPrefix('helicopter', '3', 'helicopter_badguy', 24, true)
    setScrollFactor('helicopter', 0.85, 0.85)
    addLuaSprite('helicopter')

    makeLuaSprite('building1', prefix..'side_building_1', -500, -250)
    setScrollFactor('building1', 0.9, 0.9)
    scaleObject('building1', daScale, daScale, false)
    setProperty('building1.active', false)
    addLuaSprite('building1')

    makeLuaSprite('building2', prefix..'side_building_2', 1500, -250)
    setScrollFactor('building2', 0.9, 0.9)
    scaleObject('building2', daScale, daScale, false)
    setProperty('building2.active', false)
    addLuaSprite('building2')

    makeLuaSprite('rooftop', prefix..'rooftop', 50, 700)
    scaleObject('rooftop', daScale, daScale, false)
    setProperty('rooftop.active', false)
    addLuaSprite('rooftop')

    helicameo = getRandomInt(1, 3)
    helitrigger = getRandomInt(100, 251)
end

function onCreatePost() 
    snapCamFollowToPos(675, 375, false)
end

function onBeatHit()
    if curBeat == helitrigger then
        triggerEvent('Hominid Events', 'heli cameo', '')
    end
end

function onEvent(name, v1, v2)
    if name == 'Hominid Events' then
	if v1 == 'snap hominid' then
	    snapCamFollowToPos(getMidpointX('dad'), getMidpointY('dad'), true)
	elseif v1 == 'snap pico' then
	    snapCamFollowToPos(getMidpointX('boyfriend') - 150, getMidpointY('boyfriend') - 50, true)
	elseif v1 == 'end snap' then
	    setProperty('isCameraOnForcedPos', false)
	elseif v1 == 'heli cameo' then
	    doTweenX('heliX', 'helicopter', 1475, 5)
	    playAnim('helicopter', helicameo)
	end
    end
end