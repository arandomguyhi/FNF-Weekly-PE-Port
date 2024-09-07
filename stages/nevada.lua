local gruntTriggerAmount
local gruntTrigger1
local gruntTrigger2
local gruntTrigger3

luaDebugMode = true
function onCreate()
    addHaxeLibrary('FlxFlicker', 'flixel.effects')

    makeLuaSprite('bg', 'stages/w3/nevada/sky', -855, -825)
    setProperty('bg.antialiasing', true)
    setScrollFactor('bg', 0.85, 0.85)
    addLuaSprite('bg')

    makeLuaSprite('mountain', 'stages/w3/nevada/mountains', 284, 303)
    setProperty('mountain.antialiasing', true)
    setScrollFactor('mountain', 0.9, 0.9)
    addLuaSprite('mountain')

    makeLuaSprite('bgbuilding', 'stages/w3/nevada/buildings', -115, -411)
    setProperty('bgbuilding.antialiasing', true)
    setScrollFactor('bgbuilding', 0.95, 1)
    addLuaSprite('bgbuilding')

    makeLuaSprite('floor', 'stages/w3/nevada/floor', -811.2, -24.8)
    setProperty('floor.antialiasing', true)
    addLuaSprite('floor')

    makeFlxAnimateSprite('grunt', -225, 258, 'stages/w3/nevada/grunt')
    addAnimationBySymbol('grunt', 'gruntwalking', 'gruntwalking', 24, true)
    addAnimationBySymbol('grunt', 'grunthi', 'grunthi', 24, true)
    addAnimationBySymbol('grunt', 'gruntwalkingfast', 'gruntwalkingfast', 24, true)
    setProperty('grunt.antialiasing', true)
    addLuaSprite('grunt')

    makeLuaSprite('fgbuilding', 'stages/w3/nevada/building_hole', -844.5, -559.45)
    setProperty('fgbuilding.antialiasing', true)
    addLuaSprite('fgbuilding')

    makeLuaSprite('blackScreen', nil)
    makeGraphic('blackScreen', 1, 1, '000000')
    scaleObject('blackScreen', screenWidth * 2, screenHeight * 2)
    setScrollFactor('blackScreen', 0, 0)
    screenCenter('blackScreen', 'XY')
    setObjectCamera('blackScreen', 'camOther')
    addLuaSprite('blackScreen')

    makeLuaSprite('somewhere', 'stages/w3/nevada/somewhere')
    setProperty('somewhere.antialiasing', true)
    setObjectCamera('somewhere', 'camOther')
    screenCenter('somewhere', 'XY')
    setProperty('somewhere.alpha', 0.001)
    addLuaSprite('somewhere')

    makeLuaSprite('intropico', 'stages/w3/nevada/Intro_Pico', 1280)
    setProperty('intropico.antialiasing', true)
    setObjectCamera('intropico', 'camHUD')
    addLuaSprite('intropico')

    makeLuaSprite('introhank', 'stages/w3/nevada/Intro_Hank', -1280)
    setProperty('introhank.antialiasing', true)
    setObjectCamera('introhank', 'camHUD')
    addLuaSprite('introhank')

    makeLuaSprite('play', 'stages/w3/nevada/play')
    setProperty('play.antialiasing', true)
    setObjectCamera('play', 'camOther')
    setProperty('play.visible', false)
    addLuaSprite('play')

    setProperty('skipCountdown', true)
end

function onCreatePost()
    snapCamFollowToPos(600, -1250, true)
    setPropertyFromClass('flixel.FlxG', 'camera.zoom', 0.6)
    setProperty('camHUD.alpha', 0.001)
    gruntTriggerAmount = getRandomInt(1,3)
    gruntTrigger1 = getRandomInt(90, 125)
    gruntTrigger2 = getRandomInt(186, 213)
    gruntTrigger3 = getRandomInt(290, 326)
end

function onBeatHit()
    if curBeat == gruntTrigger1 then
	setProperty('grunt.x', -225)
	setProperty('grunt.flipX', false)
	playAnim('grunt', 'gruntwalking')
	startTween('gruntwalk', 'grunt', {x = 640}, 3.5, {onComplete = 'gruntFinishWalk'})
	function gruntFinishWalk()
	    playAnim('grunt', 'grunthi')
	    runTimer('gruntTimer', 1)
	end
    end
    if curBeat == gruntTrigger2 and gruntTriggerAmount >= 2 then
	setProperty('grunt.x', 2000)
	setProperty('grunt.flipX', true)
	playAnim('grunt', 'gruntwalkingfast')
	doTweenX('gruntrunning', 'grunt', -225, 2)
    end
    if curBeat == gruntTrigger3 and gruntTriggerAmount >= 3 then
	setProperty('grunt.x', -225)
	setProperty('grunt.flipX', false)
	playAnim('grunt', 'gruntwalking')
	startTween('gruntwalk', 'grunt', {x = 640}, 3.5, {onComplete = 'gruntFinishWalk'})
	function gruntFinishWalk()
	    playAnim('grunt', 'grunthi')
	    runTimer('gruntTimer', 1)
	end
    end
end

function onEvent(eventName, value1, value2)
    if eventName == 'crimsonfogevents' then
	if value1 == 'intro' then
	    startTween('camIntroTween', 'camFollow', {y = 200}, 5.5, {ease = 'smoothStepInOut', onComplete = 'startIntro'})
	    function startIntro()
		setProperty('isCameraOnForcedPos', false)
		doTweenAlpha('hudalpha', 'camHUD', 1, 2, 'expoOut')
		startTween('zoomTween', 'camGame', {zoom = 0.7}, 2, {ease = 'expoOut'})
	    end
	    startTween('unblack', 'blackScreen', {alpha = 0.001}, 5, {ease = 'expoOut', startDelay = 1.75})
	elseif v1 == 'text shit' then
	    debugPrint('somewhere')
	    startTween('skjj', 'somewhere', {alpha = 1}, 1, {onComplete = 'bzl'})
	    function bzl() runTimer('coiso', 6) end
	elseif v1 == 'play text' then
	    setProperty('play.visible', true)
	    runHaxeCode("FlxFlicker.flicker(game.getLuaObject('play'), 8, 1.0, false);")
	elseif v1 == 'cool part' then
	    if v2 == 'hank' then
		doTweenX('hankTween', 'introhank', 0, 1.5, 'expoOut')
	    elseif v2 == 'pico' then
		doTweenX('picoTween', 'intropico', 0, 1.5, 'expoOut')
	    elseif v2 == 'flash' then
		cameraFlash('camHUD', 'FFFFFF', 1)
		doTweenX('hankTweenOut', 'introhank', 1280, 1.5, 'expoOut')
		doTweenX('picoTweenOut', 'intropico', -1280, 1.5, 'expoOut')
	    end
	elseif v1 == 'duet' then
	    setProperty('isCameraOnForcedPos', true)
	    setProperty('camFollow.x', 675) setProperty('camFollow.y', 300)
	elseif v1 == 'duet off' then
	    setProperty('isCameraOnForcedPos', false)
	end
    end
end

function onTimerCompleted(tag)
    if tag == 'coiso' then
	doTweenAlpha('sklsa', 'somewhere', 0.001, 1)
    end

    if tag == 'gruntTimer' then
	doTweenX('grunto', 'grunt', 2000, 1.5)
	playAnim('grunt', 'gruntwalkingfast')
    end
end