local coolSection = false;

luaDebugMode = true;
function onCreate()
    makeLuaSprite('farbg', 'stages/w5/gd/backwall', -325, -1575);
    setProperty('farbg.antialiasing', true);
    setScrollFactor('farbg', 0.5, 0.5);
    addLuaSprite('farbg');

    makeLuaSprite('farbg2', 'stages/w5/gd/backwall', getProperty('farbg.width') - 325, -1575);
    setProperty('farbg2.antialiasing', true);
    setScrollFactor('farbg2', 0.5, 0.5);
    addLuaSprite('farbg2');

    makeLuaSprite('stage', 'stages/w5/gd/stereo', -50, -295);
    setProperty('stage.antialiasing', false);
    setScrollFactor('stage', 0.55, 0.55);
    addLuaSprite('stage');

    makeLuaSprite('stage2', 'stages/w5/gd/stereo', getProperty('stage.width') - 50, -295);
    setProperty('stage2.antialiasing', false);
    setScrollFactor('stage2', 0.55, 0.55);
    addLuaSprite('stage2');

    makeLuaSprite('bg', 'stages/w5/gd/background', 0, -180);
    setProperty('bg.antialiasing', true);
    setScrollFactor('bg', 0.8, 0.8);
    addLuaSprite('bg');

    makeLuaSprite('ground', 'stages/w5/gd/ground');
    setProperty('ground.antialiasing', true);
    addLuaSprite('ground');
end

function onCreatePost()
    setProperty('camGame.scroll.x', 1720 - (screenWidth / 2));
    setProperty('camGame.scroll.y', -300 - (screenHeight / 2));

    makeLuaSprite('achievement', 'stages/w5/gd/achievement', 0, -200);
    setProperty('achievement.antialiasing', true);
    setObjectCamera('achievement', 'camHUD');
    scaleObject('achievement', 0.5, 0.5);
    screenCenter('achievement', 'X');
    setObjectOrder('achievement', getObjectOrder('botplayTxt'));
    addLuaSprite('achievement', true);
end

local noAnimationSection = false;
function onUpdate(elapsed)
    setProperty('stage.x', getProperty('stage.x') - elapsed * 100);
    setProperty('stage2.x', getProperty('stage2.x') - elapsed * 100);

    if getProperty('stage.x') < -5500 then setProperty('stage.x', getProperty('stage.x') + getProperty('stage.width') * 2); end
    if getProperty('stage2.x') < -5500 then setProperty('stage2.x', getProperty('stage2.x') + getProperty('stage2.width') * 2); end

    setProperty('farbg.x', getProperty('farbg.x') - elapsed * 25);
    setProperty('farbg2.x', getProperty('farbg2.x') - elapsed * 25);

    if getProperty('farbg.x') < -5000 then setProperty('farbg.x', getProperty('farbg.x') + getProperty('farbg.width') * 2); end
    if getProperty('farbg2.x') < -5000 then setProperty('farbg2.x', getProperty('farbg2.x') + getProperty('farbg2.width') * 2); end
end

function onBeatHit()
    if getProperty('camZooming') and coolSection then
	setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.015 * getProperty('camZoomingMult'));
	setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.03 * getProperty('camZoomingMult'));
    end
end

function onEvent(name, value1, value2)
    if name == 'Achievement' then
	startTween('ahcuhwud', 'achievement', {y = 0}, 1.5, {ease = 'expoOut', onComplete = 'achieFunc'})
	function achieFunc()
	    startTween('ahcuhwfd', 'achievement', {y = -200}, 1.5, {ease = 'expoOut', startDelay = 1.5})
	end
    elseif name == 'Duet' then
	if value1 == 'on' then
	    setProperty('camFollow.x', 1730);
	    setProperty('camFollow.y', -210);
	    setProperty('isCameraOnForcedPos', true);
	elseif value1 == 'off' then
	    setProperty('isCameraOnForcedPos', false);
	end
    elseif name == 'Beat Bop' then
	if value1 == 'on' then coolSection = true;
	elseif value1 == 'off' then coolSection = false; end
    end
end