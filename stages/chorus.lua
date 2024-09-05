local rank = 'PERFECT';
local allowEnd = false;

luaDebugMode = true;
function onCreate()
    makeLuaSprite('bg', 'stages/w5/tengoku/chorus_bg');
    setProperty('bg.antialiasing', true);
    addLuaSprite('bg');

    makeAnimatedLuaSprite('conductor', 'stages/w5/tengoku/conductor', 88, 391);
    addAnimationByPrefix('conductor', 'idle', 'lion_fuck', 24, true);
    playAnim('conductor', 'idle');
    setProperty('conductor.antialiasing', true);
    addLuaSprite('conductor', true);

    makeLuaSprite('perfectTxt', 'stages/w5/tengoku/perfect', 25);
    setProperty('perfectTxt.antialiasing', false);
    scaleObject('perfectTxt', 3, 3);
    setObjectCamera('perfectTxt', 'camHUD');
    addLuaSprite('perfectTxt');

    setProperty('skipCountdown', true);
end

function onCreatePost()
    makeLuaSprite('youTxt', 'stages/w5/tengoku/you');
    setProperty('youTxt.antialiasing', false);
    scaleObject('youTxt', 3, 3);
    setProperty('youTxt.x', getProperty('boyfriend.x') - 5);
    setProperty('youTxt.y', getProperty('boyfriend.y') + 210);
    addLuaSprite('youTxt');

    setProperty('timeBar.y', -1000);
    setProperty('timeTxt.y', -1000);

    setProperty('camGame.scroll.x', 639 - (screenWidth / 2))
    setProperty('camGame.scroll.y', 359 - (screenHeight / 2))
    setProperty('camFollow.x', 639)
    setProperty('camFollow.y', 359)
    setProperty('isCameraOnForcedPos', true)

    setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', {0, 1000, 0, 1000});
    setProperty('scoreTxt.x', -325);
    setProperty('scoreTxt.y', 676.8);

    for i = 0, 3 do
	setProperty('opponentStrums.members['..i..'].visible', false);
    end

    setProperty('healthBar.bg.visible', false);
    setProperty('healthBar.visible', false);
    setProperty('iconP1.visible', false);
    setProperty('iconP2.visible', false);
end

function onSpawnNote()
    for i = 0, getProperty('notes.length')-1 do
	if not getPropertyFromGroup('notes', i, 'mustPress') then
	    setPropertyFromGroup('notes', i, 'visible', false);
	end
    end
end

function onUpdatePost()
    setProperty('camZooming', false);
    setProperty('health', 1);
    setTextString('scoreTxt', ' - Score: '..getProperty('songScore')..' - Misses: '..getProperty('songMisses')..' - Combo: '..getProperty('combo')..' - ');
end

function noteMiss()
    setProperty('perfectTxt.visible', false);
end

function onEndSong()
    if getProperty('songMisses') == 0 then
	rank = 'PERFECT';
    elseif getProperty('songMisses') <= 20 then
	rank = 'GOOD';
    else
	rank = 'BAD';
    end

    if not allowEnd then
	allowEnd = true;
	startVideo('chorus_'..rank);
	setProperty('inCutscene', true);
	return Function_Stop;
    end
    return Function_Continue;
end