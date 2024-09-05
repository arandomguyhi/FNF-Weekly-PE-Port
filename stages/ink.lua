local coolSection = false;

luaDebugMode = true;
function onCreate()
    makeLuaSprite('bg', 'stages/w666/bend/bg');
    addLuaSprite('bg');
end

function onCreatePost()
    setProperty('camGame.scroll.x', 1400 - (screenWidth / 2));
    setProperty('camGame.scroll.y', 900 - (screenHeight / 2));
end

function onBeatHit()
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
    elseif name == 'Middle' then
	if value1 == 'on' then
	    setProperty('camFollow.x', 1575);
	    setProperty('camFollow.y', 800);
	    setProperty('isCameraOnForcedPos', true);
	elseif value1 == 'off' then
	    setProperty('isCameraOnForcedPos', false);
	end
    end
end