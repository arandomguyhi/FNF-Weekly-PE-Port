luaDebugMode = true;
function onCreate()
    makeLuaSprite('drop', 'stages/w5/parappa/drop');
    setProperty('drop.antialiasing', true);
    addLuaSprite('drop');

    makeLuaSprite('stage1', 'stages/w5/parappa/stage', 2000);
    setProperty('stage1.antialiasing', true);
    addLuaSprite('stage1');

    makeLuaSprite('speakers', 'stages/w5/parappa/speakers', 1450, -280);
    setProperty('speakers.antialiasing', true);
    addLuaSprite('speakers');

    makeLuaSprite('crowd', 'stages/w5/parappa/crowd', 1500, 1400);
    setProperty('crowd.antialiasing', true);
    setScrollFactor('crowd', 1.1, 1.1);
    addLuaSprite('crowd', true);
end

function onCreatePost()
    setProperty('camGame.scroll.x', 3475 - (screenWidth / 2));
    setProperty('camGame.scroll.y', 1000 - (screenHeight / 2));
end

function onBeatHit()
    setProperty('crowd.y', 1500 - 25);
    startTween('crowdTween', 'crowd', {y = 1400}, 0.3, {ease = 'expoOut'});
end

function onEvent(name, value1, value2)
    if name == 'Duet' then
	if value1 == 'on' then
	    setProperty('camFollow.x', 3460);
	    setProperty('camFollow.y', 1100);
	    setProperty('isCameraOnForcedPos', true);
	elseif value1 == 'off' then
	    setProperty('isCameraOnForcedPos', false);
	end
    end
end