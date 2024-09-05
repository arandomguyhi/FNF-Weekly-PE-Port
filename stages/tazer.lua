local Bud = false
local watchingCutscene = false
local hasWatchedCutscene = false
local pac = true
local mike = false
local tazer = false
local gold = false

luaDebugMode = true
function onCreate()
    --addCharacterToList('herocam', 'boyfriend')

    makeLuaSprite('bg', 'stages/w7/Legend/BG')
    setProperty('bg.antialiasing', true)
    addLuaSprite('bg')

    makeLuaSprite('bgcam', 'stages/w7/Legend/BG2')
    setProperty('bgcam.antialiasing', true)
    setProperty('bgcam.visible', false)
    addLuaSprite('bgcam')

    makeLuaSprite('overlay', 'stages/w7/Legend/overlay')
    setProperty('overlay.antialiasing', true)
    setProperty('overlay.visible', false)
    addLuaSprite('overlay')

    makeLuaSprite('blueoverlay', nil)
    makeGraphic('blueoverlay', 1280, 720, '30B3FF')
    setObjectCamera('blueoverlay', 'camOther')
    setProperty('blueoverlay.visible', false)
    setProperty('blueoverlay.alpha', 0.14)
    addLuaSprite('blueoverlay')

    makeLuaSprite('friends', 'stages/w7/Legend/FG', 130, 590)
    setProperty('friends.antialiasing', true)
    addLuaSprite('friends', true)

    initLuaShader('meme')
    setProperty('defaultCamZoom', 1.8)
end

function onCreatePost()
    setProperty('skipCountdown', true)
    setProperty('camGame.scroll.x', 1280 / 2 - 1 - (screenWidth / 2)) -- it snaps x camera pos
    setProperty('camGame.scroll.y', 720 / 2 - 1 - (screenHeight / 2)) -- it snaps y camera pos
    setProperty('camFollow.x', 1280 / 2 - 1)
    setProperty('camFollow.y', 720 / 2 - 1)
    setProperty('isCameraOnForcedPos', true)
end

function onSpawnNote()
    for i = 0, getProperty('notes.length')-1 do
	if not getPropertyFromGroup('notes', i, 'mustPress') then
	    setPropertyFromGroup('notes', i, 'visible', false)
	end
	--if gold then
	--end
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if noteType == 'GF Sing' then
	if not mike then
	    callMethod('iconP1.changeIcon', {'mike'});
	    mike = true;
	end
	pac = false;
        tazer = false;
    elseif noteType == 'Duet' then
	playAnim('gf', getProperty('singAnimations')[noteData+1], true);
	setProperty('gf.holdTimer', 0);
	if not tazer then
	    callMethod('iconP1.changeIcon', {'tazercraft'});
	    tazer = true;
	end
        mike = false;
        pac = false;
    else
	if not pac then
	    callMethod('iconP1.changeIcon', {'pac'});
	    pac = true;
	end
	mike = false;
        tazer = false;
    end
end

function onEvent(name, value1, value2)
    if name == 'Hero' then
	if value1 == 'main' then
	    Bud = false;
	    setProperty('bg.visible', true);
	    setProperty('bgcam.visible', false);
	    setProperty('boyfriend.visible', true);
	    setProperty('gf.visible', true);
	    setProperty('friends.visible', true);
	    setProperty('overlay.visible', false);
	    setProperty('blueoverlay.visible', false);
	    for i = 0, 3 do
		setPropertyFromGroup('playerStrums', i, 'x', 417 + (112 * (i % 4)));
	    end
	    runHaxeCode("camGame.filters = [];");
	elseif value1 == 'cam' then
	    Bud = true;
	    setProperty('bg.visible', false);
	    setProperty('bgcam.visible', true);
	    setProperty('boyfriend.visible', false);
	    setProperty('gf.visible', false);
	    setProperty('friends.visible', false);
	    setProperty('overlay.visible', true);
	    setProperty('blueoverlay.visible', true);
	    for i = 0, 3 do
		setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i]);
	    end
	    runHaxeCode([[
		local memeShader = game.createRuntimeShader('meme');
		camGame.filters = [new ShaderFilter(memeShader)];
	    ]]);
	elseif value1 == 'gold' then
	    gold = true;
	end
    end
end

local s = 1
local skY = 170
function onUpdate(elapsed)
    setProperty('defaultCamZoom', 1)
    s = s + elapsed
    if not Bud then
	setProperty('dad.y', lerp(getProperty('dad.y'), skY + (math.cos(s) * 10), boundTo(1, 0, elapsed * 2)))
    end
end

function onStartCountdown()
    if not watchingCutscene then
	watchingCutscene = true

	startVideo('tazerintro')
	--setProperty('inCutscene', true)

	return Function_Stop
    end

    return Function_Continue
end

function onSongStart()
    for i = 0, 3 do
	setPropertyFromGroup('playerStrums', i, 'x', 417 + (112 * (i % 4)))
	setPropertyFromGroup('opponentStrums', i, 'visible', false)
    end
end

function lerp(a,b,ratio)
    return a + ((b-a)*ratio)
end

function boundTo(value, min, max)
    return math.max(min, math.min(max, value))
end