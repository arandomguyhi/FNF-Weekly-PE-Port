addHaxeLibrary('FlxBar', 'flixel.ui');
addHaxeLibrary('FlxBarFillDirection', 'flixel.ui.FlxBar');
addHaxeLibrary('FlxColor', 'flixel.util');

local prefix = 'stages/w5/doctor/'

local heartRad = 0;
local rainIntensity = 0.1;
local isRaining = false;
local coolSection = false;

luaDebugMode = true;
function onCreate()
    makeLuaSprite('dayBG', prefix..'Stadium_day');
    setGraphicSize('dayBG', screenWidth + 2, screenHeight + 2, false);
    addLuaSprite('dayBG');

    makeLuaSprite('nightBG', prefix..'Stadium_night');
    setGraphicSize('nightBG', screenWidth + 2, screenHeight + 2, false);
    addLuaSprite('nightBG');

    makeAnimatedLuaSprite('sign', prefix..'text', 623, 167);
    addAnimationByPrefix('sign', 'texts', 'text0', 1, true);
    addLuaSprite('sign');
    playAnim('sign', 'texts', false);

    makeAnimatedLuaSprite('signPibby', prefix..'textglitch', 623, 115);
    addAnimationByPrefix('signPibby', 'texts', 'textglitch0', 24, true);
    setProperty('signPibby.visible', false);
    addLuaSprite('signPibby');
    playAnim('signPibby', 'texts', false);

    runHaxeCode([[
	var bar = new FlxBar(155, 340, null, 948, 10, game, 'health', 0, 2, false);
	bar.createImageBar(Paths.image('stages/w5/doctor/rdhealthBar'), Paths.image('stages/w5/doctor/rdhealthBar') );
	bar.createFilledBar(FlxColor.YELLOW, FlxColor.LIME, false, null);
 	//bar.cameras = [game.camHUD];
	bar.antialiasing = ClientPrefs.data.antialiasing;
	addBehindGF(bar);
    ]]);

    makeLuaSprite('heart', prefix..'heart', 1050, 290);
    updateHitbox('heart');
    addLuaSprite('heart');

    makeLuaSprite('white', nil);
    makeGraphic('white', screenWidth, screenHeight, 'FFFFFF');
    setObjectCamera('white', 'camHUD');
    setProperty('white.alpha', 0.001);
    addLuaSprite('white');

    if shadersEnabled then
	initLuaShader('rain');
	runHaxeCode([[
	    var rainShader = game.createRuntimeShader('rain');
	    rainShader.setFloatArray('uScreenResolution', [FlxG.width, FlxG.height]);
	    rainShader.setFloat('uTime', 0);
	    rainShader.setFloat('uScale', FlxG.height / 200);
	    rainShader.setFloat('uIntensity', ]]..rainIntensity..[[);
	    setVar('rainShader', rainShader);
	]]);
    end
end

function onCreatePost()
    for _, i in pairs({'iconP1', 'iconP2', 'timeTxt', 'timeBar', 'healthBar', 'healthBar.bg'}) do
	setProperty(i..'.visible', false);
    end

    setProperty('scoreTxt.y', 15);

    setProperty('nightBG.alpha', 0.001);

    setProperty('camGame.scroll.x', 1280 / 2 - (screenWidth / 2));
    setProperty('camGame.scroll.y', 720 / 2 - (screenHeight / 2));
    setProperty('camFollow.x', 1280 / 2);
    setProperty('camFollow.y', 720 / 2);
    setProperty('isCameraOnForcedPos', true);
end

function onUpdatePost(elapsed)
    heartRad = heartRad + elapsed;
    setProperty('heart.angle', 20 * math.sin(heartRad * 0.5) + 10);

    local mult = lerp(0.75, getProperty('heart.scale.x'), boundTo(0.75 - (elapsed * 9), 0, 0.75));
    setProperty('heart.scale.x', mult);
    setProperty('heart.scale.y', mult);
    updateHitbox('heart');

    if isRaining then
	runHaxeCode([[
	    var rainShader = getVar('rainShader');
	    rainShader.setFloatArray('uCameraBounds', [game.camGame.scroll.x + game.camGame.viewMarginX, game.camGame.scroll.y + game.camGame.viewMarginY, game.camGame.scroll.x + game.camGame.viewMarginX + game.camGame.width, game.camGame.scroll.y + game.camGame.viewMarginY + game.camGame.height]);
	    rainShader.setFloat('uTime', ]]..heartRad..[[);
	    rainShader.setFloat('uIntensity', ]]..rainIntensity..[[);
	]]);
	rainIntensity = rainIntensity + 0.000025;
    end
end

function onBeatHit()
    if curBeat % 2 == 0 then
	setProperty('heart.scale.x', 0.9);
	setProperty('heart.scale.y', 0.9);
	if getProperty('camZooming') and coolSection then
	    setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.015 * getProperty('camZoomingMult'));
	    setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.03 * getProperty('camZoomingMult'));
	end
    end
end

function onGhostTap()
    if ghostTapping then
	playSound('pop', 0.6);
	playAnim('boyfriend', 'press', true);
    end
end

function onEvent(name, v1, v2)
    if name == 'Rhythm Doctor Events' then
	if v1 == 'Zoom On Lucky' then
	    setProperty('defaultCamZoom', 1.8);
	    setProperty('isCameraOnForcedPos', false);
	elseif v1 == 'Fade' then
	    startTween('fadeTween', 'white', {alpha = 1}, 0.3636 * 2, {onComplete = 'whiteFadeFunction'})
	    function whiteFadeFunction()
		startTween('unFadeTween', 'white', {alpha = 0.001}, 0.3636 * 2, {})
	    end
	elseif v1 == 'Night' then
	    setProperty('defaultCamZoom', 1);

	    setProperty('camGame.scroll.x', 1280 / 2 - (screenWidth / 2));
	    setProperty('camGame.scroll.y', 720 / 2 - (screenHeight / 2));
	    setProperty('camFollow.x', 1280 / 2);
	    setProperty('camFollow.y', 720 / 2);
	    setProperty('isCameraOnForcedPos', true);

	    setProperty('dayBG.alpha', 0.001);
	    setProperty('nightBG.alpha', 1);
	    setProperty('sign.alpha', 0.001);
	    setProperty('signPibby.visible', true);

	    isRaining = true;
	    if shadersEnabled then runHaxeCode("camGame.filters = [new ShaderFilter(getVar('rainShader'))];"); end
	end
    elseif name == 'Beat Bop' then
	if v1 == 'on' then coolSection = true;
	elseif v1 == 'off' then coolSection = false; end
    end
end

function lerp(a,b,ratio)
    return a + ((b-a)*ratio)
end

function boundTo(value, min, max)
    return math.max(min, math.min(max, value))
end