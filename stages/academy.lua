local walkDown = false;
local bgCanMove = false;
local cameoString = {'aoi', 'toko', 'leonn', 'nagito'};
local cameoIsActive = false;

luaDebugMode = true;
function onCreate()
    addHaxeLibrary('FlxEase', 'flixel.tweens');

    for _, cameos in pairs(cameoString) do
	precacheImage('stages/w666/box24/cameos/'..cameos);
    end

    makeLuaSprite('bgtile1', 'stages/w666/box24/ronpa_tile', -75, -450);
    setProperty('bgtile1.antialiasing', true);
    scaleObject('bgtile1', 0.75, 0.75);
    addLuaSprite('bgtile1');

    makeLuaSprite('bgtile2', 'stages/w666/box24/ronpa_tile', getProperty('bgtile1.width') - 75, -450);
    setProperty('bgtile2.antialiasing', true);
    scaleObject('bgtile2', 0.75, 0.75);
    addLuaSprite('bgtile2');

    makeLuaSprite('bgtile3', 'stages/w666/box24/ronpa_tile', 2136 + 75, -450);
    setProperty('bgtile3.antialiasing', true);
    scaleObject('bgtile3', 0.75, 0.75);
    addLuaSprite('bgtile3');

    makeLuaSprite('cameo', 'stages/w666/box24/cameos/toko', 1500, 265);
    setProperty('cameo.antialiasing', true);
    addLuaSprite('cameo');

    makeLuaSprite('blackScreen', nil);
    makeGraphic('blackScreen', 1, 1, '000000');
    scaleObject('blackScreen', screenWidth * 2, screenHeight * 2);
    setScrollFactor('blackScreen', 0, 0);
    screenCenter('blackScreen', 'XY');
    setObjectCamera('blackScreen', 'camOther');
    addLuaSprite('blackScreen');

    makeLuaSprite('cg1', 'stages/w666/box24/danganweeklycg1');
    setProperty('cg1.antialiasing', true);
    setObjectCamera('cg1', 'camOther');
    setProperty('cg1.alpha', 0.001);
    addLuaSprite('cg1');

    makeLuaSprite('cg2', 'stages/w666/box24/danganweeklycg2');
    setProperty('cg2.antialiasing', true);
    setObjectCamera('cg2', 'camOther');
    setProperty('cg2.alpha', 0.001);
    addLuaSprite('cg2');

    setProperty('skipCountdown', true);
end

function onCreatePost()
    setProperty('camGame.scroll.x', 1280 / 2 - 1 - (screenWidth / 2));
    setProperty('camGame.scroll.y', 720 / 2 - 1 - 200 - (screenHeight / 2));
    setProperty('camFollow.x', 1280 / 2 - 1);
    setProperty('camFollow.y', 720 / 2 - 1 - 200);
    setProperty('isCameraOnForcedPos', true);

    makeLuaSprite('barTop', nil);
    makeGraphic('barTop', screenWidth * 2, 68, '000000');
    screenCenter('barTop', 'X');
    setObjectCamera('barTop', 'camHUD');

    makeLuaSprite('barBottom', nil);
    makeGraphic('barBottom', screenWidth * 2, 68, '000000');
    screenCenter('barBottom', 'X');
    setObjectCamera('barBottom', 'camHUD');
    setProperty('barBottom.y', 652);

    addLuaSprite('barTop');
    addLuaSprite('barBottom');

    setTextFont('scoreTxt', 'goodbyeDespair.ttf');
    setTextFont('timeTxt', 'goodbyeDespair.ttf');
end

function onUpdate(elapsed)
    if bgCanMove then
	setProperty('bgtile1.x', getProperty('bgtile1.x') - elapsed * 100);
	setProperty('bgtile2.x', getProperty('bgtile2.x') - elapsed * 100);
	setProperty('bgtile3.x', getProperty('bgtile3.x') - elapsed * 100);

	if getProperty('bgtile1.x') < -1400 then setProperty('bgtile1.x', getProperty('bgtile1.x') + getProperty('bgtile1.width') * 3); end
	if getProperty('bgtile2.x') < -1400 then setProperty('bgtile2.x', getProperty('bgtile2.x') + getProperty('bgtile2.width') * 3); end
	if getProperty('bgtile3.x') < -1400 then setProperty('bgtile3.x', getProperty('bgtile3.x') + getProperty('bgtile3.width') * 3); end

	if cameoIsActive then
	    setProperty('cameo.x', getProperty('cameo.x') - elapsed * 100);

	    if getProperty('cameo.x') < -1400 then
		deactivateCameo();
	    end
	end
    end
end

function onBeatHit()
    if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
	if getProperty('boyfriendGroup.x') ~= 675 then
	    setProperty('boyfriendGroup.x', 675);
	end

	if walkDown and bgCanMove then
	    setProperty('boyfriendGroup.y', -130);
	elseif bgCanMove then
	    setProperty('boyfriendGroup.y', -140);
	end
    end

    if walkDown and bgCanMove then
	setProperty('dadGroup.y', -75);
    elseif bgCanMove then
	setProperty('dadGroup.y', -85);
    end

    walkDown = not walkDown
end

function onSectionHit()
    if not cameoIsActive and getRandomBool(35) then
	spawnCameo();
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    setVar('noteDataGood', noteData);
    setVar('noteSustain', isSustainNote);
    runHaxeCode([[
	var moveTween:FlxTween;
	if(moveTween != null)
	{
	    moveTween.cancel();
	    game.boyfriendGroup.x = 675;
	    game.boyfriendGroup.y = -140;
	}

	switch (getVar('noteDataGood')) { // i'm not crazy to rewrite this xD
	    case 0:
		game.boyfriendGroup.y = -140;
		if(!getVar('noteSustain'))
		{
		    game.boyfriendGroup.x = 625;
		    moveTween = FlxTween.tween(game.boyfriendGroup, {x: 675}, 0.3, {ease: FlxEase.expoOut});
		}
	    case 1:
		game.boyfriendGroup.x = 675;
		if(!getVar('noteSustain'))
		{
                    game.boyfriendGroup.y = -115;
                    moveTween = FlxTween.tween(game.boyfriendGroup, {y: -140}, 0.3, {ease: FlxEase.expoOut}); 
		}
	    case 2:
		game.boyfriendGroup.x = 675;
		if(!getVar('noteSustain'))
		{
                    game.boyfriendGroup.y = -190;
                    moveTween = FlxTween.tween(game.boyfriendGroup, {y: -140}, 0.3, {ease: FlxEase.expoOut}); 
		}
	    case 3:
		game.boyfriendGroup.y = -140;
		if(!getVar('noteSustain'))
		{
                    game.boyfriendGroup.x = 725;
                    moveTween = FlxTween.tween(game.boyfriendGroup, {x: 675}, 0.3, {ease: FlxEase.expoOut});
		}
	}
    ]]);
end

function onEvent(eventName, value1, value2)
    if eventName == 'Box CG' then
	if value1 == '1' then
	    doTweenAlpha('cg1alpha', 'cg1', 1, 0.5, 'expoOut');
	elseif value1 == '2' then
	    doTweenAlpha('cg2alpha', 'cg2', 1, 0.5, 'expoOut');
	elseif value1 == 'off' then
	    doTweenAlpha('unblack', 'blackScreen', 0.001, 7.5, 'expoOut');
	    startTween('cameraPos', 'camFollow', {y = 720 / 2 - 1}, 5.5, {ease = 'smoothStepInOut'});
	    setProperty('cg1.visible', false);
	    setProperty('cg2.visible', false);
	    bgCanMove = true;
	elseif value1 == 'fade' then
	    doTweenAlpha('blackfade', 'blackScreen', 1, 7.5, 'expoOut');
	end
    elseif eventName == 'Black' then
	if value1 == 'on' then
	    setProperty('blackScreen.visible', true);
	elseif value1 == 'off' then
	    setProperty('blackScreen.visible', false);
	end
    end
end

local cameoNum = 1;
function spawnCameo()
    if cameoNum > 4 then
	cameoNum = 1;
    end

    if getRandomBool(25) then
	loadGraphic('cameo', 'stages/w666/box24/cameos/'..cameoString[4]);
    else
	loadGraphic('cameo', 'stages/w666/box24/cameos/'..cameoString[cameoNum]);
    end
    cameoIsActive = true;
    cameoNum = cameoNum + 1;
end

function deactivateCameo() -- yes this is dumb
    cameoIsActive = false;
    setProperty('cameo.x', 1500);
end