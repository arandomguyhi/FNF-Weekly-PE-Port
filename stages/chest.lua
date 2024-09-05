local PREFIX = 'stages/w7/isaac/'

luaDebugMode = true
function onCreate()
    setProperty('skipCountdown', true);

    makeLuaSprite('bg', PREFIX..'bg', 480, 140);
    scaleObject('bg', 1.1, 1.1);
    addLuaSprite('bg');

    makeAnimatedLuaSprite('sketch', PREFIX..'doodle', 320, 80);
    addAnimationByPrefix('sketch', 'loop', 'doodle0', 24, true);
    setBlendMode('sketch', 'add');
    setProperty('sketch.alpha', 0.001);
    addLuaSprite('sketch');
    playAnim('sketch', 'loop', false);

    makeLuaSprite('white', nil);
    makeGraphic('white', screenWidth, screenHeight, 'ffffff');
    setObjectCamera('white', 'camHUD');
    setProperty('white.alpha', 0.001);
    addLuaSprite('white');

    makeFlxAnimateSprite('intro', 500, 190, PREFIX..'intro');
    addAnimationBySymbol('intro', 'intro', 24, true);
    setProperty('intro.alpha', 0.001);
    addLuaSprite('intro');

    precacheSound('isaacIntro');
    precacheSound('isaachurt0');
    precacheSound('isaachurt1');
    precacheSound('isaachurt2');
end

function onCreatePost()
    makeLuaSprite('floorback', PREFIX..'floorback', getProperty('dad.x') - 130, getProperty('dad.y') + 220);
    addLuaSprite('floorback');

    makeLuaSprite('floorfront', PREFIX..'floorfront', getProperty('boyfriend.x') - 190, getProperty('boyfriend.y') + 350);
    addLuaSprite('floorfront');

    setProperty('healthBar.flipX', true) setProperty('healthBar.leftBar.flipX', true) setProperty('healthBar.rightBar.flipX', true)
    for i = 1,2 do setProperty('iconP'..i..'.flipX', not getProperty('iconP'..i..'.flipX'))end
end

function onEvent(name, value1, value2)
    if name == 'Isaac Events' then -- hi guy i dunno
	if value1 == 'bye bye' then
	    setProperty('camGame.visible', false)
	elseif value1 == 'Fade In' then
	    doTweenAlpha('fadeInEvent', 'white', 1, 0.4286 * 2)
	elseif value1 == 'Fade Out' then
	    doTweenAlpha('fadeOutEvent', 'white', 0.001, 0.4286 * 2)
	    setProperty('camGame.visible', true)
	    setProperty('sketch.alpha', 1)
	end
    end
end

local startCutscene = false
function onStartCountdown()
    if not startCutscene then
	startCutscene = true

	setProperty('inCutscene', true)
	setProperty('camHUD.alpha', 0.001)
	setProperty('camGame.scroll.x', 1100 - (screenWidth / 2))
	setProperty('camGame.scroll.y', 500 - (screenHeight / 2))
	setProperty('camFollow.x', 1100)
	setProperty('camFollow.y', 500)

	playSound('isaacIntro')
	setProperty('intro.alpha', 1)
	playAnim('intro', 'intro')
	runTimer('introEnd', 3.5)

	return Function_Stop
    end
    return Function_Continue
end

function onSongStart()
    for i = 0, 3 do
	setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i])
	setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i])
    end
end

function onMoveCamera(target)
    setProperty('defaultCamZoom', target == 'dad' and 1.2 or 1.1)
end

function noteMiss()
    local thisAnim = getProperty('boyfriend.animation.curAnim.name')
    if thisAnim ~= 'miss' then
	playSound('isaachurt'..getRandomInt(0,2), 1)
    end
    playAnim('boyfriend', 'miss', false)
end

function onTimerCompleted(tag)
    if tag == 'introEnd' then
	doTweenAlpha('backHud', 'camHUD', 1, 1)
	doTweenAlpha('introAlphaOut', 'intro', 0.001, 0.5)
	startTween('baxl', 'game', {['camGame.zoom'] = 1.2}, 1, {ease = 'sineInOut'})
	setProperty('inCutscene', false)
	startCountdown()
    end
end

function onUpdatePost(elapsed)
    local P1Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)
    local P2Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)
    setProperty('iconP1.origin.x', 240) setProperty('iconP1.x', P1Mult - 115)
    setProperty('iconP2.origin.x', -100) setProperty('iconP2.x', P2Mult + 100)
end