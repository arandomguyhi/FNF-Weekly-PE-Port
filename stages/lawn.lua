local sunPressed = false
local snoutAt = {70, 17}
local isZombieAlive = true
local sunCount = 50

luaDebugMode = true
function onDestroy()
    setPropertyFromClass('flixel.FlxG', 'camera.bgColor', 0x000000)
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', false)
end

function onCreate()
    addHaxeLibrary('FlxFlicker', 'flixel.effects')

    setPropertyFromClass('flixel.FlxG', 'camera.bgColor', 0x2ACAFD)

    makeLuaSprite('bg', 'stages/w2/brains/day', -450, -200) addLuaSprite('bg')

    makeLuaSprite('lbg', 'stages/w2/brains/BIGLIGHT', -300, -200)
    scaleObject('lbg', 2, 2)
    setProperty('lbg.alpha', 0.2)
    setBlendMode('lbg', 'add')
    addLuaSprite('lbg', true)

    makeAnimatedLuaSprite('sun', 'stages/w2/brains/sun', 550, -300)
    addAnimationByPrefix('sun', 'idle', 'sunSprite', 24, true)
    addLuaSprite('sun', true)

    local dod = downscroll and screenHeight - 50 or 15
    makeLuaText('helpText', 'You', -1, 290, dod)
    makeLuaText('helpText2', 'The Zombie', -1, 230 + screenWidth / 2, dod)

    for _, i in pairs({'helpText', 'helpText2'}) do
	setTextFont(i, 'pvz.ttf')
	setTextSize(i, 32)
	setProperty(i..'.borderSize', 2)
	setTextColor(i, 'D7C26A')
	addLuaText(i)
    end
end

function noteMiss()
    playSound('chew'..getRandomInt(1,2))
end

function onEvent(eventName, value1, value2)
    if eventName == 'today zombie lost his arm' then
	playAnim('dad', 'idle-alt', true)
	setProperty('dad.specialAnim', true)
	setProperty('arm.alpha', 1)
	playAnim('arm', 'pop')
	doTweenY('sunTween', 'sun', 100, 3)
    elseif eventName == 'DIE!' then
	isZombieAlive = false
	playAnim('dad', 'die', true)
	triggerEvent('Alt Idle Animation', '-dead')
	setProperty('defaultCamZoom', 1.5)
    elseif eventName == 'peashoot' then
	playAnim('boyfriend', 'singRIGHT', true)
	setProperty('boyfriend.specialAnim', true)
	setProperty('pea.alpha', 1)
	setProperty('pea.x', getCharacterX('boyfriend') + snoutAt[1]) setProperty('pea.y', getCharacterY('boyfriend') + snoutAt[2])

	startTween('peaTween', 'pea', {x = getProperty('dad.x')}, 0.5, {ease = 'linear', onComplete = 'peaFunc'})
	function peaFunc() setProperty('health', getProperty('health')+0.03) setProperty('pea.alpha', 0.001) end
    end
end

local canflick = true
function onUpdatePost(elapsed)
    setProperty('arm.x', getProperty('dad.x') - 30)
    setTextString('scoreTxt', 'Combo: '..combo..' - Score: '..score..' - Sun: '..sunCount..(ratingFC ~= '' and (' ('..ratingFC..')') or ''))
    setProperty('scoreTxt.x', getProperty('healthBar.x') - getProperty('scoreTxt.width') - 10)

    if getPropertyFromClass('flixel.FlxG', 'mouse.overlaps', 'sun') then
	if getPropertyFromClass('flixel.FlxG', 'mouse.justPressed') and not sunPressed then
	    sunPressed = true
	    sunCount = sunCount + 25
	    playSound('sunSound')
	    doTweenAlpha('sunAlpha', 'sun', 0.001, 1)
	end
    end

    if getProperty('dad.animation.curAnim.name') == 'die' and getProperty('dad.animation.curAnim.finished') and canflick then
	canflick = false
	runHaxeCode("FlxFlicker.flicker(dad, 1, 0.1, false);")
    end

    if isZombieAlive then
	if mustHitSection and stringStartsWith(getProperty('dad.animation.name'), 'idle') then
	    setProperty('dad.x', getProperty('dad.x') - 0.25 * 60 * elapsed)
	end
    end
end

function onCreatePost()
    makeAnimatedLuaSprite('arm', 'stages/w2/brains/zombiehandImSoSorryForNotTweeningThisLikeANormalPerson3', getCharacterX('dad')-100, getCharacterY('dad')+100)
    addAnimationByPrefix('arm', 'pop', 'ArmPop', 12, false)
    playAnim('arm', 'pop')
    setProperty('arm.alpha', 0.001)
    addLuaSprite('arm')

    setProperty('healthBar.angle', 180)
    setProperty('iconP1.flipX', true)
    setProperty('healthBar.leftToRight', true)

    setProperty('timeBar.y', -999)
    setProperty('timeTxt.y', -999)
    setTextFont('scoreTxt', 'pvz.ttf')
    setTextColor('scoreTxt', 'D7C26A')
    setProperty('scoreTxt.borderSize', 2)
    setTextAlignment('scoreTxt', 'right')
    setProperty('healthBar.x', getProperty('healthBar.x') + 250)

    for i = 0,3 do
	setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i])
	setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i])
    end

    local dod2 = downscroll and -10 or 10
    setProperty('healthBar.y', getProperty('healthBar.y') + dod2*3)
    setProperty('iconP1.y', getProperty('iconP1.y') + dod2*3)
    setProperty('iconP2.y', getProperty('iconP2.y') + dod2*3)
    if not downscroll then setProperty('scoreTxt.y', getProperty('scoreTxt.y') - 10) else
    setProperty('scoreTxt.y', (getProperty('healthBar.y') + dod2)) end

    playSound('pvz-siren')

    doTweenX('dadX', 'dad', 900, 2.5, 'linear')

    snapCamFollowToPos(550, 190, false)
    setPropertyFromClass('flixel.FlxG', 'camera.zoom', 2)
    setProperty('comboGroup.visible', false)

    setProperty('camHUD.alpha', 0.001)
    makeLuaText('helpText3', 'Your Front Lawn', -1, 50, 50)
    setTextFont('helpText3', 'pvz2.ttf')
    setTextSize('helpText3', 48)
    setObjectCamera('helpText3', 'camGame')
    setTextAlignment('helpText3', 'center')
    setScrollFactor('helpText3', 0, 0)
    screenCenter('helpText3', 'XY')
    setProperty('helpText3.borderSize', 2)
    setProperty('helpText3.y', getProperty('helpText3.y') + 150)
    addLuaText('helpText3')

    runTimer('startThing', 1)

    makeLuaSprite('pea', 'stages/w2/brains/pea', getCharacterX('boyfriend') + snoutAt[1], getCharacterY('boyfriend') + snoutAt[2])
    addLuaSprite('pea', true)
    setProperty('pea.alpha', 0.00001)
end

function onSongStart()
    setProperty('isCameraOnForcedPos', false)
    setProperty('cameraSpeed', 0.3)
    doTweenAlpha('start3', 'helpText3', 0.001, 1)
    doTweenAlpha('start1', 'helpText', 0.001, 1)
    doTweenAlpha('start2', 'helpText2', 0.001, 1)
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)
end

function onTimerCompleted(tag)
    if tag == 'startThing' then
	setProperty('cameraSpeed', 0.2)
	startTween('camZoom', 'camGame', {zoom = getProperty('defaultCamZoom')}, 2, {ease = 'sineOut'})
	startTween('text3', 'helpText3', {y = getProperty('helpText3.y') + 50}, 2, {ease = 'sineInOut'})
	startTween('hudalpha', 'camHUD', {alpha = 1}, 2, {ease = 'sineInOut'})
    end
end