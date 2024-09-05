local cameras = {'camGame', 'camHUD'}
local unHud = {'healthBar.bg', 'healthBar', 'iconP1', 'iconP2', 'timeBar', 'timeTxt'}

local canMoveX = false
local canMoveY = false
local canUpdate = false
local move = 0
local moveMult = 0.5

local canLerp = false
local splitLerp = 1

--luaDebugMode = true
function onCreate()
    addHaxeLibrary('LuaUtils', 'psychlua')

    if shadersEnabled then
	initLuaShader('3D')
	initLuaShader('paranoia')

	makeLuaSprite('threedeez')
	setSpriteShader('threedeez', '3D')

	makeLuaSprite('para')
	setSpriteShader('para', 'paranoia')
	setShaderFloat('para', 'splitCount', 1)

	runHaxeCode([[
	    var filter1 = game.getLuaObject('threedeez').shader;
	    var filter2 = game.getLuaObject('para').shader;

	    game.camGame.filters = [new ShaderFilter(filter1)];
	    game.camHUD.filters = [new ShaderFilter(filter1), new ShaderFilter(filter2)];
	]])
    end
end

function onCreatePost()
    local newWidth = 960
    local newHeight = 720
    local scaledHeight = 720

    for _, camera in pairs(cameras) do
	setProperty(camera..'.width', 1280)
	if newHeight <= 720 then
	    setProperty(camera..'.height', 720 * (1280 / newHeight))
	    scaledHeight = getProperty(camera..'.height')
	end
    end

    for i = 0, 7 do
	setPropertyFromGroup('strumLineNotes', i, 'x', 417 + (112 * (i % 4)))
	setPropertyFromGroup('strumLineNotes', i, 'y', getPropertyFromGroup('strumLineNotes', i, 'y')+230)
	setPropertyFromGroup('strumLineNotes', i-4, 'downScroll', true)
    end

    for _, i in pairs(unHud) do
	setProperty(i..'.visible', false)
    end
    scaleObject('scoreTxt', 3, 3)
    updateHitbox('scoreTxt')
    screenCenter('scoreTxt', 'X')
    setProperty('scoreTxt.alpha', 0.001)
    setProperty('defaultCamZoom', 1)
    setPropertyFromClass('states.PlayState', 'stageUI', 'stages/w5/notitg')

    makeLuaSprite('blackScreen', nil)
    makeGraphic('blackScreen', 1, 1, '000000')
    setScrollFactor('blackScreen', 0, 0)
    scaleObject('blackScreen', screenWidth * 2, screenHeight * 2, false)
    updateHitbox('blackScreen')
    screenCenter('blackScreen', 'XY')
    addLuaSprite('blackScreen', true)

    makeLuaSprite('bg', 'stages/w5/LOVE_GROOVE_FINAL_BACKGROUND')
    setScrollFactor('bg', 0, 0)
    scaleObject('bg', 1.5, 1.5)
    screenCenter('bg', 'XY')
    setProperty('bg.y', getProperty('bg.y')-12.5)
    addLuaSprite('bg', true)

    setProperty('dad.visible', false) setProperty('boyfriend.visible', false) setProperty('gf.visible', false)
end

function onSongStart()
    setProperty('bg.alpha', 0.001)
    startTween('startinSong', 'bg', {alpha = 0.25}, (stepCrochet / 1000) * 16, {ease = 'quadOut'})
end

local fartbutt = 0
function onUpdate(elapsed)
    setProperty('camZooming', false)

    if canUpdate then move = move + (elapsed * moveMult) end

    if canMoveX then
	setShaderFloat('para', 'x', move)
	setVar('move', move)
    end
    if canMoveY then
	setShaderFloat('para', 'y', move)
	setVar('move', move)
    end

    if canLerp then
	farbutt = lerp(getShaderFloat('para', 'splitCount'), splitLerp, boundTo(elapsed * 2.4, 0, 1))
	setShaderFloat('para', 'splitCount', farbutt)
    end

    local currentBeat = (getSongPosition() / 1000) * (curBpm / 300)
    if curStep >= 272 and curStep <= 326 or curStep >= 333 and curStep <= 390 or curStep >= 400 and curStep <= 454 then
	for i=0,7 do
	    local name = i > 3 and "playerStrums" or "opponentStrums"
	    local note = (i % 4)
	    local notesY = getPropertyFromGroup(name, note, 'y')

	    noteTweenY('tweenY'..i, i, notesY + 0.9 * math.cos((currentBeat + i*2.55) * math.pi), 0.01)
	end
    end	
end

function onSpawnNote()
    for i = 0, getProperty('notes.length')-1 do
	if getPropertyFromGroup('notes', i, 'mustPress') then
	    setPropertyFromGroup('notes', i, 'noteSplashData.disabled', true)
	end
    end
end

local poop = 0
local shit = 0
local bump = 1

function onStepHit()
    if curStep == 40 then
	for i = 0,3 do
	    noteTweenX('opX'..i, i, _G['defaultOpponentStrumX'..i], (stepCrochet / 1000) * 4, 'backOut')
	    noteTweenX('plX'..i, i+4, _G['defaultPlayerStrumX'..i], (stepCrochet / 1000) * 4, 'backOut')
	end
    end

    if curStep == 72 then
	for i = 0,3 do
	    noteTweenY('opY'..i, i, _G['defaultOpponentStrumY'..i]+510, (stepCrochet / 1000) * 4, 'backInOut')
	    noteTweenY('plY'..i, i+4, _G['defaultPlayerStrumY'..i], (stepCrochet / 1000) * 4, 'backInOut')
	end
    end

    if curStep == 104 then
	for i = 0,3 do
	    setPropertyFromGroup('strumLineNotes', i, 'downScroll', false)

	    noteTweenY('notesY'..i, i, _G['defaultOpponentStrumY'..i], (stepCrochet / 1000) * 4, 'backInOut')
	    noteTweenX('notesX'..i, i, 417 + (112 * (i % 4)), (stepCrochet / 1000) * 4, 'backInOut')

	    noteTweenY('notePlY'..i, i+4, _G['defaultPlayerStrumY'..i], (stepCrochet / 1000) * 4, 'backInOut')
	    noteTweenX('notePlX'..i, i+4, 417 + (112 * (i % 4)), (stepCrochet / 1000) * 4, 'backInOut')
	end
    end

    if curStep == 128 then
	for i = 0,3 do
	    noteTweenX('opX'..i, i, _G['defaultOpponentStrumX'..i], (stepCrochet / 1000) * 8, 'quadOut')
	    noteTweenX('plX'..i, i+4, _G['defaultPlayerStrumX'..i], (stepCrochet / 1000) * 8, 'quadOut')
	end
    end

    if curStep == 327 then
	for i = 0,7 do
	    setPropertyFromGroup('strumLineNotes', 2, 'downScroll', true) setPropertyFromGroup('strumLineNotes', 3, 'downScroll', true)
	    setPropertyFromGroup('strumLineNotes', 6, 'downScroll', true) setPropertyFromGroup('strumLineNotes', 7, 'downScroll', true)
	    noteTweenY('centered'..i, i, getPropertyFromGroup('strumLineNotes', i, 'y')+230, (stepCrochet / 1000) * 2, 'quadOut')
	end
    end

    if curStep == 331 then
	for i = 0,1 do noteTweenY('upOp'..i, i, getPropertyFromGroup('strumLineNotes', i, 'y')-230, (stepCrochet / 1000) * 2, 'quadOut')end
	for i = 4,5 do noteTweenY('upPl'..i, i, getPropertyFromGroup('strumLineNotes', i, 'y')-230, (stepCrochet / 1000) * 2, 'quadOut')end

	for i = 2,3 do noteTweenY('downOp'..i, i, getPropertyFromGroup('strumLineNotes', i, 'y')+280, (stepCrochet / 1000) * 2, 'quadOut')end
	for i = 6,7 do noteTweenY('downPl'..i, i, getPropertyFromGroup('strumLineNotes', i, 'y')+280, (stepCrochet / 1000) * 2, 'quadOut')end
    end

    if curStep == 391 then
	for i = 0,7 do
	    setPropertyFromGroup('strumLineNotes', i, 'downScroll', true)

	    noteTweenX('centered'..i, i, 417 + (112 * (i % 4)), (stepCrochet / 1000) * 2, 'quadOut')

	    local name = i > 3 and "defaultPlayerStrum" or "defaultOpponentStrum"
	    local note = (i % 4)
	    noteTweenY('upper'..i, i, _G[name..'Y'..note], (stepCrochet / 1000) * 2, 'quadOut')
	end
    end

    if curStep == 395 then
	for i = 0,7 do
	    local name = i > 3 and "defaultPlayerStrum" or "defaultOpponentStrum"
	    local note = (i % 4)
	    noteTweenX('defX'..i, i, _G[name..'X'..note], (stepCrochet / 1000) * 2, 'quadOut')
	    noteTweenY('downLol'..i, i, _G[name..'Y'..note]+510, (stepCrochet / 1000) * 2, 'quadOut')
	end
    end

    if curStep == 455 then
	for i = 0,7 do
	    local name = i > 3 and "defaultPlayerStrum" or "defaultOpponentStrum"
	    local note = (i % 4)
	    noteTweenY('centerY'..i, i, _G[name..'Y'..note]+230, (stepCrochet / 1000) * 2, 'quadOut')
	end
    end

    if curStep == 459 then
	for i = 0, 7 do
	    setPropertyFromGroup('strumLineNotes', i, 'downScroll', i > 3 and false or true)

	    local name = i > 3 and "defaultPlayerStrum" or "defaultOpponentStrum"
	    local note = (i % 4)
	    noteTweenX('centerX'..i, i, 417 + (112 * (i % 4)), (stepCrochet / 1000) * 2, 'quadOut')
	end
    end

    if curStep == 496 then
	for i = 0,7 do
	    setPropertyFromGroup('strumLineNotes', i, 'downScroll', false)

	    local name = i > 3 and "defaultPlayerStrum" or "defaultOpponentStrum"
	    local note = (i % 4)
	    noteTweenY('normalY'..i, i, _G[name..'Y'..note], (stepCrochet / 1000) * 16, 'quadOut')
	end
    end

    if curStep >= 912 and curStep <= 1040 then
	if curStep % 4 == 0 then
	    bump = bump * -1
	    for i = 0,7 do
		local xis = 417 + (112 * (i % 4))
		local defaultName = i > 3 and "Player" or "Opponent"
		local ipisolon = _G['default'..defaultName..'StrumY'..i%4]

		noteTweenX('bumpX'..i, i, xis + 50 * bump, (stepCrochet / 1000) * 2, 'backOut')

		if i == 0 or i == 1 or i == 4 or i == 5 then
		    noteTweenY('transformY'..i, i, ipisolon + 25 * bump, (stepCrochet / 1000) * 2, 'backOut')
		elseif i == 2 or i == 3 or i == 6 or i == 7 then
		    noteTweenY('transformY'..i, i, ipisolon - 25 * bump, (stepCrochet / 1000) * 2, 'backOut')
		end
	    end
	end
    end

    if curStep == 1040 then
	for i = 0,7 do
	    local defaultName = i > 3 and "Player" or "Opponent"
	    noteTweenX('defaultX'..i, i, 417 + (112 * (i % 4)), (stepCrochet / 1000) * 16, 'quadOut')
	    noteTweenY('defaultY'..i, i, _G['default'..defaultName..'StrumY'..i%4], (stepCrochet / 1000) * 16, 'quadOut')
	end
    end

    if curStep == 1056 then
	for i = 0,3 do
	    noteTweenX('transformX'..i, i, 92+i*57, (stepCrochet / 1000) * 4, 'quadOut')end
	    for i = 4,7 do noteTweenX('transformXPL'..i, i, 204+i*57, (stepCrochet / 1000) * 4, 'quadOut')
	end
    end

    ------ SHADER SHIT -----
    if curStep == 136 then
	canMoveX = true
	--doTweenNumber('moveXTween', 0, 7, (stepCrochet / 1000) * 124, 'quadOut')
	runHaxeCode([[
	    FlxTween.num(0, 7, (Conductor.stepCrochet / 1000) * 124, {ease: FlxEase.quadOut}, function(twn:Float) {
		game.callOnLuas('setValue', [twn]);
	    });
	]])
    end

    if curStep == 512 then
	runHaxeCode([[
	    FlxTween.num(1, 4, (Conductor.stepCrochet / 1000) * 14, {ease: FlxEase.quadInOut}, function(toown:Float) {
		game.callOnLuas('shaderTween', ['para', 'splitCount', toown]);
	    });
	]])
    end

    if curStep == 528 then setShaderFloat('para', 'splitCount', 1)
    elseif curStep == 536 then setShaderFloat('para', 'splitCount', 2)
    elseif curStep == 544 then setShaderFloat('para', 'splitCount', 1)
    elseif curStep == 552 then setShaderFloat('para', 'splitCount', 2)
    elseif curStep == 560 then
	move = 0
	canMoveX = true
	runHaxeCode([[
	    FlxTween.num(0, 1, (Conductor.stepCrochet / 1000) * 24, {ease: FlxEase.quadOut}, function(twn:Float) {
		game.callOnLuas('setValue', [twn]);
	    });
	]])
	runTimer('moveValue1', (stepCrochet / 1000) * 24)
    elseif curStep == 592 then canMoveX = false;
    end

    if curStep == 592 then setShaderFloat('para', 'splitCount', 1)
    elseif curStep == 600 then setShaderFloat('para', 'splitCount', 2)
    elseif curStep == 608 then setShaderFloat('para', 'splitCount', 1)
    elseif curStep == 616 then setShaderFloat('para', 'splitCount', 2)
    elseif curStep == 624 then
	move = 0
	canMoveY = true
	runHaxeCode([[
	    FlxTween.num(0, 1, (Conductor.stepCrochet / 1000) * 24, {ease: FlxEase.quadOut}, function(twn:Float) {
		game.callOnLuas('setValue', [twn]);
	    });
	]])
	runTimer('moveValue2', (stepCrochet / 1000) * 24)
    elseif curStep == 656 then canMoveY = false
    end

    if curStep == 656 then setShaderFloat('para', 'splitCount', 1)
    elseif curStep == 664 then setShaderFloat('para', 'splitCount', 2)
    elseif curStep == 672 then setShaderFloat('para', 'splitCount', 1)
    elseif curStep == 680 then setShaderFloat('para', 'splitCount', 2)
    elseif curStep == 688 then
	move = 0
	canMoveX = true
	canMoveY = true
	runHaxeCode([[
	    FlxTween.num(0, 1, (Conductor.stepCrochet / 1000) * 24, {ease: FlxEase.quadOut}, function(twn:Float) {
		game.callOnLuas('setValue', [twn]);
	    });
	]])
	runTimer('moveValue3', (stepCrochet / 1000) * 24)
    elseif curStep == 720 then canMoveX = false canMoveY = false
    end

    if curStep == 720 then setShaderFloat('para', 'splitCount', 1)
    elseif curStep == 728 then setShaderFloat('para', 'splitCount', 2)
    elseif curStep == 736 then setShaderFloat('para', 'splitCount', 1)
    elseif curStep == 744 then setShaderFloat('para', 'splitCount', 2)
    elseif curStep == 752 then
	move = 0
	canMoveX = true
	canMoveY = true
	runHaxeCode([[
	    FlxTween.num(0, 1, (Conductor.stepCrochet / 1000) * 24, {ease: FlxEase.quadOut}, function(twn:Float) {
		game.callOnLuas('setValue', [twn]);
	    });
	    FlxTween.num(2, 1, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadOut}, function(toown:Float) {
		game.callOnLuas('shaderTween', ['para', 'splitCount', toown]);
	    });
	]])
	runTimer('moveValue4', (stepCrochet / 1000) * 24)
    elseif curStep == 784 then canMoveX = false canMoveY = false
    end

    if curStep >= 786 and curStep <= 799 then
	if curStep % 2 == 0 then poop = poop + 45 end
	setShaderFloat('threedeez', 'zrot', poop)
	setShaderFloat('threedeez', 'zpos', 0.5)
    end
    if curStep == 800 then
	runHaxeCode([[
	    FlxTween.num(0, 0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, function(twn) {
		game.callOnLuas('shaderTween', ['threedeez', 'zrot', twn]);
	    });
	]])
	setShaderFloat('threedeez', 'zpos', 0)
    end

    if curStep >= 818 and curStep <= 831 then
	if curStep % 2 == 0 then shit = shit + 22.5 end

	setShaderFloat('threedeez', 'xrot', shit)
	setShaderFloat('threedeez', 'zpos', 0.5)
    end
    if curStep == 832 then
	runHaxeCode([[
	    FlxTween.num(0, 0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, function(twn) {
		game.callOnLuas('shaderTween', ['threedeez', 'xrot', twn]);
	    });
	]])
	setShaderFloat('threedeez', 'zpos', 0)
	shit = 0
    end

    if curStep >= 850 and curStep <= 863 then
	if curStep % 2 == 0 then shit = shit + 22.5 end

	setShaderFloat('threedeez', 'yrot', shit)
	setShaderFloat('threedeez', 'zpos', 0.5)
    end
    if curStep == 864 then
	runHaxeCode([[
	    FlxTween.num(0, 0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, function(twn) {
		game.callOnLuas('shaderTween', ['threedeez', 'yrot', twn]);
	    });
	]])
	setShaderFloat('threedeez', 'zpos', 0)
	poop = 0
    end

    if curStep >= 882 and curStep <= 895 then
	if curStep % 2 == 0 then poop = poop + 45 end
	setShaderFloat('threedeez', 'zrot', poop)
	setShaderFloat('threedeez', 'zpos', 0.5)
    end
    if curStep == 896 then
	runHaxeCode([[
	    FlxTween.num(0, 0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, function(twn) {
		game.callOnLuas('shaderTween', ['threedeez', 'zrot', twn]);
	    });
	]])
    end

    if curStep == 912 then
	runHaxeCode([[
	    FlxTween.num(0.5, 0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, function(twn) {
		game.callOnLuas('shaderTween', ['threedeez', 'zpos', twn]);
	    });
	]])
	runTimer('zposValue1', (stepCrochet/1000)*4)
    end

    if curStep == 1576 then canLerp = true splitLerp = 2 canUpdate = true canMoveX = true end
    if curStep == 1584 then splitLerp = 1 end
    if curStep == 1592 then splitLerp = 2 end
    if curStep == 1600 then splitLerp = 1
	runHaxeCode([[
	    FlxTween.num(]]..move..[[, Std.int(]]..move..[[), (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, function(twn) {
		game.callOnLuas('setValue', [twn]);
	    });
	]])
    end

    if curStep == 1640 then splitLerp = 2 moveMult = moveMult * -1 end
    if curStep == 1648 then splitLerp = 1 end
    if curStep == 1656 then splitLerp = 2 end
    if curStep == 1664 then splitLerp = 1
	runHaxeCode([[
	    FlxTween.num(]]..move..[[, Std.int(]]..move..[[), (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, function(twn) {
		game.callOnLuas('setValue', [twn]);
	    });
	]])
    end

    if curStep == 1704 then splitLerp = 2 canMoveX = true canMoveY = false end
    if curStep == 1712 then splitLerp = 3 end
    if curStep == 1720 then splitLerp = 2 end
    if curStep == 1728 then splitLerp = 3 end
    if curStep == 1736 then splitLerp = 1 moveMult = moveMult * -1 end

    if curStep == 1768 then splitLerp = 2 canMoveY = false moveMult = moveMult * -1 end
    if curStep == 1776 then moveMult = moveMult * -1 end
    if curStep == 1784 then moveMult = moveMult * -1 end
    if curStep == 1792 then moveMult = moveMult * -1 end
    if curStep == 1800 then canMoveY = true end

    if curStep == 1816 then canMoveY = false canMoveX = false canUpdate = false splitLerp = 1
	runHaxeCode([[
	    FlxTween.num(]]..move..[[, Std.int(]]..move..[[), (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadOut}, function(twn) {
		game.callOnLuas('setValue', [twn]);
		game.callOnLuas('shaderTween', ['para', 'x', ]]..move..[[]);
		game.callOnLuas('shaderTween', ['para', 'y', ]]..move..[[]);
	    });
	]])
    end

    if curStep == 2072 then
	runHaxeCode([[
	    FlxTween.num(0, 0.5, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadInOut}, function(twn) {
		game.callOnLuas('shaderTween', ['threedeez', 'zpos', twn]);
	    });
	]])
	poop = 0
    end

    if curStep >= 2090 and curStep <= 2103 then
	if curStep % 2 == 0 then poop = poop + 45 end
	setShaderFloat('threedeez', 'zrot', poop)
	setShaderFloat('threedeez', 'zpos', 0.5)
    end
    if curStep == 2104 then
	runHaxeCode([[
	    FlxTween.num(0.5, 0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, function(twn) {
		game.callOnLuas('shaderTween', ['threedeez', 'zpos', twn]);
	    });
	]])
	setShaderFloat('threedeez', 'zrot', 0)
	poop = 0
    end

    if curStep >= 2122 and curStep <= 2135 then
	if curStep % 2 == 0 then poop = poop + 45 end
	setShaderFloat('threedeez', 'yrot', poop)
	setShaderFloat('threedeez', 'zpos', 0.5)
    end
    if curStep == 2136 then
	runHaxeCode([[
	    FlxTween.num(0.5, 0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, function(twn) {
		game.callOnLuas('shaderTween', ['threedeez', 'zpos', twn]);
	    });
	]])
	setShaderFloat('threedeez', 'yrot', 0)
	poop = 0
    end

    if curStep >= 2154 and curStep <= 2167 then
	if curStep % 2 == 0 then poop = poop + 45 end
	setShaderFloat('threedeez', 'xrot', poop)
	setShaderFloat('threedeez', 'zpos', 0.5)
    end
    if curStep == 2168 then
	setShaderFloat('threedeez', 'xrot', 0)
	poop = 0
    end
    if curStep == 2180 then
	runHaxeCode([[
	    FlxTween.num(0.5, 0, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, function(twn) {
		game.callOnLuas('shaderTween', ['threedeez', 'zpos', twn]);
	    });
	]])
    end
    ------------------------

    if curStep == 2400 then
	startTween('finalTweenFinllay', 'bg', {alpha = 1}, 1, {ease = 'quadIn', onComplete = 'showResults'})
	function showResults()
	    setTextString('scoreTxt', 'Score: '..getProperty('songScore')..'\nMisses: '..getProperty('songMisses'));
	    startTween('scoreAlpha', 'scoreTxt', {alpha = 1}, 1, {ease = 'quadIn'})
	end
    end
end

function onTimerCompleted(tag)
    for i = 1,4 do
	if tag == 'moveValue'..i then
	    move = 0
	end
    end
    if tag == 'zposValue1' then
	setShaderFloat('threedeez', 'zpos', 0)
    end
end

local anglu = true
function onEvent(eventName, value1, value2)
    if eventName == 'Love Groove' then
	if value1 == 'angleTween' then
	    anglu = not anglu
	    for i = 0, 7 do
		setPropertyFromGroup('strumLineNotes', i, 'scale.y', 1)
		strumAngleTween('lolaAng'..i, i, anglu and 45 or -45, 0, 0.5, 'quadOut')
		strumScaleTween('lolaScale'..i, i, 0.7, 0.7, 0.5, 'quadOut')
	    end
	end
    end
end

-- FlxTween functions
function strumAngleTween(tag, id, from, to, time, ease)
    runHaxeCode([[
        var tag = ']]..tag..[[';
        var id = ]]..id..[[;
        var fr = ]]..from..[[;
        var tog = ]]..to..[[;
        var time = ]]..time..[[;
        var ease = ']]..ease..[[';

        if(game.modchartTweens.exists(tag)) {
            game.modchartTweens.get(tag).cancel();
            game.modchartTweens.get(tag).destroy();
            game.modchartTweens.remove(tag);
        }

        game.modchartTweens.set(tag,
        FlxTween.angle(game.strumLineNotes.members[id], fr, tog, time, {ease: LuaUtils.getTweenEaseByString(ease)} )
        );
    ]])
end

function strumScaleTween(tag, id, x, y, time, ease)
    runHaxeCode([[
        var tag = ']]..tag..[[';
        var id = ]]..id..[[;
        var x = ]]..x..[[;
        var y = ]]..y..[[;
        var time = ]]..time..[[;
        var ease = ']]..ease..[[';

        if(game.modchartTweens.exists(tag)) {
            game.modchartTweens.get(tag).cancel();
            game.modchartTweens.get(tag).destroy();
            game.modchartTweens.remove(tag);
        }

        game.modchartTweens.set(tag,
        FlxTween.tween(game.strumLineNotes.members[id].scale, {x: x, y: y}, time, {ease: LuaUtils.getTweenEaseByString(ease)} )
        );
    ]])
end

function setValue(value)
    move = value
end

function shaderTween(n, f, v)
    setShaderFloat(n, f, v)
end

-- Math things
function lerp(a,b,ratio)
    return a + ((b-a)*ratio)
end

function boundTo(value, min, max)
    return math.max(min, math.min(max, value))
end