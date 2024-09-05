local isLooking = false;

luaDebugMode = true;
function onCreate()
    addCharacterToList('disabled-looking', 'dad');
    setProperty('skipCountdown', true);

    makeLuaText('lyrics', '', 0, 0, 0);
    setTextFont('lyrics', 'vcr.ttf');
    setTextSize('lyrics', 32);
    setTextAlignment('lyrics', 'CENTER');
    setProperty('lyrics.antialiasing', true);
    setProperty('lyrics.borderSize', 2);

    screenCenter('lyrics', 'XY');
    setProperty('lyrics.y', getProperty('lyrics.y') + (downscroll and -200 or 200));
    updateHitbox('lyrics');

    makeLuaSprite('fade', nil);
    makeGraphic('fade', screenWidth, screenHeight, '000000');
    setObjectCamera('fade', 'camOther');
    addLuaSprite('fade');
end

function onCreatePost()
    addLuaText('lyrics');

    setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', {200, 300, 250, 420});

    setProperty('timeTxt.visible', false); setProperty('timeBar.visible', false);
    if downscroll then setProperty('scoreTxt.y', getProperty('scoreTxt.y') + 10); end

    setScrollFactor('dad', 0.7, 0.7);
    setProperty('dad.visible', false);
    setProperty('iconP2.alpha', 0.001);
end

function onEvent(eventName, value1, value2)
    if eventName == 'Lyrics' then
	setTextString('lyrics', value1);
	screenCenter('lyrics', 'X');
	updateHitbox('lyrics');

	setTextColor('lyrics', value2);
    elseif eventName == 'Pokepasta Events' then
	if value1 == 'Toggle Black' then
	    setProperty('fade.visible', not getProperty('fade.visible'));
	elseif value1 == 'hey there friend' then
	    playAnim('dad', 'intro');
	    setProperty('dad.visible', true);
	    --setProperty('dad.animTimer', 0.6);

	    doTweenAlpha('iconP2Alpha', 'iconP2', 1, 0.6);
	elseif value1 == 'sad gold' then
	    playAnim('dad', 'tweak');
	    --setProperty('dad.animTimer', 999);
	elseif value1 == 'No More' then
	    --setProperty('dad.animTimer', 0);
	    playAnim('dad', 'no more');
	   -- setProperty('dad.animTimer', 999);
	elseif value1 == 'reset to idle' then
	    --setProperty('dad.animTimer', 0);
	    characterDance('dad');
	elseif value1 == 'Look Up' then
	    triggerEvent('Change Character', 'bf', 'disabled-looking');
	    playAnim('boyfriend', 'look');
	   -- setProperty('boyfriend.animTimer', 1.25);
	end
    end
end

function onMoveCamera(target)
    setProperty('defaultCamZoom', target == 'dad' and 1.3 or 1);
end