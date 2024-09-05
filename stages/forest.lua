local prefix = 'stages/w666/7OF8/'
local part1 = {};
local part2 = {};
local part3 = {};

luaDebugMode = true;
function onCreate()
    setProperty('camGame.alpha', 0.001);

    makeLuaSprite('white', nil);
    makeGraphic('white', screenWidth * 2, screenHeight * 2, 'FFFFFF');
    setScrollFactor('white', 0, 0);
    screenCenter('white', 'XY');
    addLuaSprite('white', true);
    setProperty('white.alpha', 0.001);

    makeLuaSprite('treeDsp', prefix..'tree1');
    setProperty('treeDsp.antialiasing', true);
    addLuaSprite('treeDsp');

    makeAnimatedLuaSprite('treePaper', prefix..'treee', 1280 / 2 -94, 720 / 2 - 130);
    scaleObject('treePaper', 0.5, 0.5);
    addAnimationByPrefix('treePaper', 'idle', 'paperbg instance ', 24, true);
    playAnim('treePaper', 'idle');
    setProperty('treePaper.antialiasing', true);
    setProperty('treePaper.alpha', 0.001);
    addLuaSprite('treePaper');

    makeLuaSprite('mainBG', prefix..'forest');
    setProperty('mainBG.antialiasing', true);
    setProperty('mainBG.alpha', 0.001);
    addLuaSprite('mainBG');

    makeAnimatedLuaSprite('dropBG', prefix..'static');
    addAnimationByPrefix('dropBG', 'idle', 'static', 24, true);
    playAnim('dropBG', 'idle');
    setProperty('dropBG.antialiasing', true);
    setProperty('dropBG.alpha', 0.001);
    addLuaSprite('dropBG');

    makeLuaSprite('fogBack', prefix..'fogBack');
    setProperty('fogBack.antialiasing', true);
    setProperty('fogBack.alpha', 0.001);
    addLuaSprite('fogBack');

    makeLuaSprite('chrSdhw', prefix..'character_shadow');
    addLuaSprite('chrSdhw');

    makeLuaSprite('blackbox', nil);
    makeGraphic('blackbox', getProperty('mainBG.width'), getProperty('mainBG.height'), '000000');
    setProperty('blackbox.alpha', 0.001);
    addLuaSprite('blackbox', true);

    makeLuaSprite('fogFront', prefix..'fogFront');
    setProperty('fogFront.antialiasing', true);
    setProperty('fogFront.alpha', 0.001);
    addLuaSprite('fogFront', true);

    makeLuaSprite('shadow', prefix..'shadow');
    addLuaSprite('shadow', true);

    makeLuaSprite('vign', prefix..'hudVignette');
    setObjectCamera('vign', 'camOther');
    setProperty('vign.alpha', 0.001);
    addLuaSprite('vign');

    runTimer('timer', 0.40, 4);

    part1 = {'treeDsp', 'treePaper'};
    part2 = {'mainBG', 'chrShdw', 'shadow', 'fogBack', 'fogFront', 'vign'};
    part3 = {'dropBG'};
end

function onCreatePost()
    setProperty('skipCountdown', true);

    setProperty('camGame.scroll.x', 1280 / 2 - 1 - (screenWidth / 2));
    setProperty('camGame.scroll.y', 720 / 2 - 1 - (screenHeight / 2));
    setProperty('camFollow.x', 1280 / 2 - 1);
    setProperty('camFollow.y', 720 / 2 - 1);
    setProperty('isCameraOnForcedPos', true);

    setProperty('boyfriend.alpha', 0.001);
    setProperty('dad.alpha', 0.001);
    setProperty('gf.alpha', 0.001);

    setProperty('gf.x', (1270 / 2 - 120));
    setProperty('gf.y', (720 / 2 - 165));
end

function onEvent(name, value1, value2)
    if name == 'darkScr' then
	if value1 == 'darken' then
	    setProperty('vign.alpha', 0.001);
	    setProperty('white.alpha', 1);
	elseif value1 == 'light' then
	    setProperty('white.alpha', 0.001);
	end
    elseif name == 'tree' then
	if tonumber(value1) > 0 and tonumber(value1) < 5 then
	    if tonumber(value1) == 3 then
		setProperty('camHUD.alpha', 1);
		setProperty('gf.alpha', 1);
		setProperty('treePaper.alpha', 1);
	    elseif tonumber(value1) == 4 then
		setProperty('camHUD.alpha', 0.001);
		startTween('blackboxTween', 'blackbox', {alpha = 1}, 0.5, {ease = 'expoOut', startDelay = 0.2});
	    end
	    loadGraphic('treeDsp', prefix..'tree'..value1, false);
	   -- removeLuaSprite('treeDsp');
	    --addLuaSprite('treeDsp');
	end
    elseif name == 'zoomStuck' then
	if value1 == 's' then
	    --setProperty('isCameraOnForcedPos', false);

	    setProperty('camGame.scroll.x', 1000 - (screenWidth / 2));
	    setProperty('camGame.scroll.y', 1300 - (screenHeight / 2));
	    setProperty('camFollow.x', 1000);
	    setProperty('camFollow.y', 1300);

	    setProperty('defaultCamZoom', 1.2);
	    setProperty('isCameraOnForcedPos', true);
	elseif value1 == 'r' then
	    --setProperty('isCameraOnForcedPos', false);

	    setProperty('camGame.scroll.x', 1900 - (screenWidth / 2));
	    setProperty('camGame.scroll.y', 1300 - (screenHeight / 2));
	    setProperty('camFollow.x', 1900);
	    setProperty('camFollow.y', 1300);

	    setProperty('defaultCamZoom', 1.2);
	    setProperty('isCameraOnForcedPos', true);
	elseif value1 == 'l' then
	    setProperty('isCameraOnForcedPos', false);
	    setProperty('defaultCamZoom', 1);
	end
    elseif name == 'majorswitch' then
	if value1 == '1' then
	    setPropertyFromClass('flixel.FlxG', 'camera.zoom', 1.5);
	    startTween('zoomTween', 'game', {['camGame.zoom'] = 1.2}, 5, {ease = 'expoOut'});
	    startTween('hudTween', 'camHUD', {alpha = 1}, 0.5, {ease = 'expoOut'});
	    startTween('bkackiebox', 'blackbox', {alpha = 0.001}, 20, {ease = 'expoOut'});
	    setProperty('gf.alpha', 0.001);
	    setProperty('boyfriend.alpha', 1);
	    setProperty('dad.alpha', 1);

	    for _, thing in pairs(part2) do
		setProperty(thing..'.alpha', (thing == 'vign' and 0.6 or 1));
	    end

	    for _, thing in pairs(part1) do
		setProperty(thing..'.alpha', 0.001);
	    end
	elseif value1 == '2' then
	    setProperty('defaultCamZoom', 0.5);

	    setProperty('camGame.scroll.x', 1500 - (screenWidth / 2));
	    setProperty('camGame.scroll.y', 950 - (screenHeight / 2));
	    setProperty('camFollow.x', 1500);
	    setProperty('camFollow.y', 950);
	    setProperty('isCameraOnForcedPos', true);

	    for _, thing in pairs(part2) do
		setProperty(thing..'.alpha', 0.001);
	    end
	    for _, thing in pairs(part3) do
		setProperty(thing..'.alpha', 1);
	    end
	elseif value1 == '3' then
	    setProperty('defaultCamZoom', 1);
	    setProperty('isCameraOnForcedPos', false);

	    for _, thing in pairs(part2) do
		setProperty(thing..'.alpha', (thing == 'vign' and 0.25 or 1));
	    end
	    for _, thing in pairs(part3) do
		setProperty(thing..'.alpha', 0.001);
	    end
	elseif value1 == '4' then
	    setProperty('defaultCamZoom', 0.6);

	    setProperty('boyfriendCameraOffset[0]', 0);
	    setProperty('boyfriendCameraOffset[1]', -200);
	    setProperty('opponentCameraOffset[0]', -100);
	    setProperty('opponentCameraOffset[1]', 0);
	elseif value1 == '5' then
	    setProperty('camHUD.alpha', 0.001);
	    loadGraphic('treeDsp', prefix..'treeEND', false);
	    --removeLuaSprite('treeDsp');
	    --addLuaSprite('treeDsp');

	    setProperty('camGame.scroll.x', 1280 / 2 - 1 - (screenWidth / 2));
	    setProperty('camGame.scroll.y', 720 / 2 - 1 - (screenHeight / 2));
	    setProperty('camFollow.x', 1280 / 2 - 1);
	    setProperty('camFollow.y', 720 / 2 - 1);
	    setProperty('isCameraOnForcedPos', true);

	    setProperty('boyfriend.alpha', 0.001);
	    setProperty('dad.alpha', 0.001);
	    setProperty('gf.alpha', 0.001);

	    for _, thing in pairs(part2) do
		setProperty(thing..'.alpha', 0.001);
	    end
	    for _, thing in pairs(part1) do
		setProperty(thing..'.alpha', 1);
	    end
	    setProperty('treePaper.alpha', 0.001);
	    startTween('finalTween', 'camGame', {alpha = 0.001}, 0, {ease = 'expoOut', startDelay = 1});
	end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'timer' then
	setProperty('camGame.alpha', getProperty('camGame.alpha') + 0.25);
    end
end