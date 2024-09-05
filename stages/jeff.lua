local phrases = {"it's really dark in here", "i better turn on the lightswi-", 'aaaaaaaah jeff the killer'};
local played = 'chiller';
local coolSection = false;

luaDebugMode = true;
function onCreate()
    addHaxeLibrary('FlxFlicker', 'flixel.effects');

    setProperty('skipCountdown', true);

    makeLuaSprite('bg', 'stages/w666/jeff/my nam jef! youve seen the meme before right', -100, -150);
    scaleObject('bg', 2, 2, false);
    addLuaSprite('bg');
    if flashingLights then played = 'killer'; end

    makeLuaSprite('shower', nil, -100, -100);
    makeGraphic('shower', screenWidth * 2, screenHeight * 2, '000000');
    setObjectCamera('shower', 'camOther');
    addLuaSprite('shower');

    makeLuaText('helpText', phrases[1], -1, 290, screenHeight - 100);
    setTextFont('helpText', 'vcr.ttf');
    setTextSize('helpText', 24);
    setTextAlignment('helpText', 'CENTER');
    changeCaption(1);

    setObjectCamera('helpText', 'camOther');
    addLuaText('helpText');
end

function changeCaption(blah)
    setTextString('helpText', phrases[blah]);
    setProperty('helpText.x', (screenWidth / 2) - (getProperty('helpText.width') / 2));
end

local canStart = false;
function onStartCountdown()
    if not canStart then
	canStart = true;

	setProperty('inCutscene', true);
	setProperty('camHUD.visible', false);
	playSound('jeff');

	-- Cutscene timers
	runTimer('yea_its_better', 2.68);
	runTimer('surprise', 3.92);
	runTimer('start_song', 5.88);

	return Function_Stop;
    end
    return Function_Continue;
end

function onCreatePost()
    setProperty('boyfriend.color', getColorFromHex('AAAAAA'));
    setProperty('dad.color', getColorFromHex('AAAAAA'));
    setProperty('camGame.scroll.x', 350 - (screenWidth / 2));
    setProperty('camGame.scroll.y', 225 - (screenHeight / 2));
end

function onBeatHit()
    if curBeat % 4 == 0 then
	if flashingLights then
	    runHaxeCode("FlxFlicker.flicker(game.getLuaObject('shower'), 0.6, 0.1, false);");
	end
    end

    if getProperty('camZooming') and coolSection then
	setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.015 * getProperty('camZoomingMult'));
	setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.03 * getProperty('camZoomingMult'));
    end
end

function onEvent(name, value1, value2)
    if name == 'Beat Bop' then
	if value1 == 'on' then
	    coolSection = true;
	elseif value1 == 'off' then
	    coolSection = false;
	end
    end
end

function onTimerCompleted(tag)
    if tag == 'yea_its_better' then
	changeCaption(2);
    elseif tag == 'surprise' then
	setProperty('helpText.visible', false);
	setProperty('camHUD.visible', true);
	setProperty('shower.alpha', 0.05);
	playAnim('dad', 'hey');
	playAnim('boyfriend', 'check');
    elseif tag == 'start_song' then
	setProperty('inCutscene', false);
	startCountdown();
    end
end