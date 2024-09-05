local popupsallowed = false;
local isScary = false;
local popuptimer = false;

luaDebugMode = true;

function onCreate()
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', true);

    addCharacterToList('kinto-3d', 'dad');
    makeLuaSprite('desktopscary', 'stages/w666/kinito/myanalogsauce');
    setProperty('desktopscary.antialiasing', true);
    setProperty('desktopscary.visible', false);
    addLuaSprite('desktopscary');

    makeLuaSprite('desktopbg', 'stages/w666/kinito/backgroundstretch');
    setProperty('desktopbg.antialiasing', true);
    addLuaSprite('desktopbg');

    makeLuaSprite('desktopicons', 'stages/w666/kinito/icons_and_shit');
    setProperty('desktopicons.antialiasing', true);
    addLuaSprite('desktopicons');

    makeLuaSprite('taskbar', 'stages/w666/kinito/taskbar');
    setProperty('taskbar.antialiasing', true);
    addLuaSprite('taskbar', true);

    makeLuaSprite('blackScreen', nil);
    makeGraphic('blackScreen', 1, 1, '000000');
    scaleObject('blackScreen', screenWidth * 2, screenHeight * 2);
    setScrollFactor('blackScreen', 0, 0);
    screenCenter('blackScreen', 'XY');
    setObjectCamera('blackScreen', 'camOther');
    setProperty('blackScreen.visible', false);
    addLuaSprite('blackScreen');

    makeLuaSprite('kinitoscare', 'stages/w666/kinito/kinito_scare', 470, 300);
    scaleObject('kinitoscare', 2, 2);
    setProperty('kinitoscare.antialiasing', true);
    setProperty('kinitoscare.visible', false);
    addLuaSprite('kinitoscare');
end

function onCreatePost()
    setProperty('camGame.scroll.x', 1280 / 2 - 1 - (screenWidth / 2))
    setProperty('camGame.scroll.y', 720 / 2 - 1 - (screenHeight / 2))
    setProperty('camFollow.x', 1280 / 2 - 1)
    setProperty('camFollow.y', 720 / 2 - 1)
    setProperty('isCameraOnForcedPos', true)

    setProperty('boyfriend.alpha', 0.001);
    scaleObject('boyfriend', 0.95, 0.95, false);
    setProperty('timeBar.y', -1000);
    setProperty('timeBar.bg.y', getProperty('timeBar.y'));
    setProperty('timeTxt.y', -1000);

    for i = 0, 3 do
	setPropertyFromGroup('playerStrums', i, 'x', 417 + (112 * (i % 4)))
	setPropertyFromGroup('opponentStrums', i, 'visible', false)
    end
end

function onSpawnNote()
    for i = 0, getProperty('notes.length')-1 do
	if not getPropertyFromGroup('notes', i, 'mustPress') then
	    setPropertyFromGroup('notes', i, 'visible', false);
	end
    end
end

local winNum = 0;
function onUpdate(elapsed)
    if getRandomBool(1) and popupsallowed and isScary and not popuptimer then
	winNum = getRandomInt(1, 6);
	triggerEvent('Spawn Popup Window', winNum, '');
	popuptimer = true;
	runTimer('notPopTime', 2.5);
    end
end

function onUpdatePost()
    setProperty('camZooming', false);
end

function onSectionHit()
    if isScary then
	if mustHitSection then
	    popupsallowed = false;
	else
	    popupsallowed = true;
	end
    end
end

function onEvent(eventName, value1, value2)
    if eventName == 'Kinito Phase' then
	if value1 == 'normal' then
	    setProperty('desktopscary.visible', false);
	    setProperty('desktopbg.visible', true);
	    setProperty('dad.visible', true);
	    setProperty('kinitoscare.visible', false);
	    popupsallowed = false;
	    isScary = false;
	    setObjectOrder('boyfriendGroup', getObjectOrder('dadGroup')+1);
	elseif value1 == 'scary' then
	    setProperty('desktopscary.visible', true);
	    setProperty('desktopbg.visible', false);
	    popupsallowed = true;
	    isScary = true;
	elseif value1 == 'tsf7' then
	    setProperty('boyfriend.visible', true);
	    setProperty('dad.visible', false);
	    doTweenAlpha('bfTween', 'boyfriend', 1, 0.1);
	    startTween('bfScaleTween', 'boyfriend.scale', {x = 1, y = 1}, 0.1, {});
	elseif value1 == 'move tweakfan' then
	    doTweenX('bfGroupX', 'boyfriendGroup', 682, 2.5, 'expoOut');
	    setProperty('kinitoscare.visible', true);
	    setProperty('dad.visible', false);
	elseif value1 == 'lights out' then
	    local removes = {'desktopscary', 'desktopbg', 'kinitoscare', 'taskbar', 'desktopicons', 'dad', 'healthBar.bg', 'healthBar', 'iconP1', 'iconP2', 'timeBar', 'timeTxt', 'scoreTxt'};
	    for _,obj in pairs(removes) do setProperty(obj..'.visible', false); end
	elseif value1 == 'bye' then
	    doTweenAlpha('bfTwee2n', 'boyfriend', 0.001, 0.1);
	    startTween('bfScaleT2een', 'boyfriend.scale', {x = 0.95, y = 0.95}, 0.1, {});
	end
    elseif eventName == 'Black' then
	if value1 == 'on' then
	    setProperty('blackScreen.visible', true);
	elseif value1 == 'off' then
	    setProperty('blackScreen.visible', false);
	end
    	if value2 == 'camgame' then
	    setObjectCamera('blackScreen', 'camGame');
	elseif value2 == 'camother' then
	    setObjectCamera('blackScreen', 'camOther');
	end
    end
end

function onTimerCompleted(tag)
    if tag == 'notPopTime' then
	popuptimer = false;
    end
end

function onDestroy()
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', false);
end