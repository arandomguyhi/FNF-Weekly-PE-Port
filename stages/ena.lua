function onCreate()
    makeLuaSprite('sky', 'stages/w3/ena/sky', -685, -506)
    setProperty('sky.antialiasing', true)
    setScrollFactor('sky', 0.65, 0.65)
    addLuaSprite('sky')

    makeLuaSprite('clouds', 'stages/w3/ena/clouds', -712, -513)
    setProperty('clouds.antialiasing', true)
    setScrollFactor('clouds', 0.75, 0.75)
    addLuaSprite('clouds')

    makeLuaSprite('statues', 'stages/w3/ena/far_places', 289, -14)
    setProperty('statues.antialiasing', true)
    setScrollFactor('statues', 0.8, 0.8)
    addLuaSprite('statues')

    makeLuaSprite('hillsback', 'stages/w3/ena/more_hills', -747, 267)
    setProperty('hillsback.antialiasing', true)
    setScrollFactor('hillsback', 0.85, 0.85)
    addLuaSprite('hillsback')

    makeLuaSprite('hills', 'stages/w3/ena/hills_back', -667, 236)
    setProperty('hills.antialiasing', true)
    setScrollFactor('hills', 0.9, 0.9)
    addLuaSprite('hills')

    makeLuaSprite('hourglass', 'stages/w3/ena/hourglasses_bg', -420, 117)
    setProperty('hourglass.antialiasing', true)
    setScrollFactor('hourglass', 0.95, 0.95)
    addLuaSprite('hourglass')

    makeLuaSprite('floor', 'stages/w3/ena/hill_floor', -756, 521)
    setProperty('floor.antialiasing', true)
    addLuaSprite('floor')
end

function onCreatePost()
    snapCamFollowToPos(650, 75, false)
end

function onEvent(eventName, value1, value2)
    if eventName == 'EnaEvents' then
	if value1 == 'duet' then
	    setProperty('isCameraOnForcedPos', true)
	    startTween('duetCam', 'camFollow', {x = 650}, 0.5, {ease = 'smoothStepInOut'})
	elseif value1 == 'duet off' then
	    setProperty('isCameraOnForcedPos', false)
	end
    end
end