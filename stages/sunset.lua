local cameras = {'camGame', 'camHUD', 'camOther'}
local supersonic = false;

luaDebugMode = true;
function onCreate()
    addHaxeLibrary('FlxBar', 'flixel.ui');
    addHaxeLibrary('FlxBarFillDirection', 'flixel.ui.FlxBar');
    addHaxeLibrary('FlxColor', 'flixel.util');

    addCharacterToList('supersonic', 'boyfriend');

    makeAnimatedLuaSprite('bg', 'stages/w7/ffsonic/bg', -50, -100);
    setProperty('bg.antialiasing', true);
    addAnimationByPrefix('bg', 'idle', 'bg', 24, true);
    playAnim('bg', 'idle');
    scaleObject('bg', 5, 5);
    setScrollFactor('bg', 0, 0);
    addLuaSprite('bg');

    makeLuaSprite('trees', 'stages/w7/ffsonic/trees', 0, -125);
    setProperty('trees.antialiasing', true);
    scaleObject('trees', 5, 5);
    setScrollFactor('trees', 0.1, 0.1);
    addLuaSprite('trees');

    makeLuaSprite('fg', 'stages/w7/ffsonic/fg', -300, 700);
    setProperty('fg.antialiasing', false);
    scaleObject('fg', 4, 4);
    addLuaSprite('fg');

    makeLuaSprite('blackScreen', nil);
    makeGraphic('blackScreen', 1, 1, '000000');
    scaleObject('blackScreen', screenWidth * 2, screenHeight * 2);
    setScrollFactor('blackScreen', 0, 0);
    screenCenter('blackScreen', 'XY');
    setObjectCamera('blackScreen', 'camOther');
    addLuaSprite('blackScreen');
end

function onCreatePost()
    local newWidth = 1100;
    local newHeight = 800;

    -- i had to do this or it would be very ugly for mobile :sob:
    for _, cams in pairs(cameras) do
	setProperty(cams..'.width', newWidth);
	setProperty(cams..'.x', getProperty(cams..'.x') + 95);

	setProperty(cams..'.height', newHeight);
	setProperty(cams..'.y', getProperty(cams..'.y') - (cams == 'camOther' and 0 or 70));
    end

    makeLuaSprite('bars', 'stages/w7/ffsonic/ui/baroverlay', 0, downscroll and 65 or 0);
    setProperty('bars.antialiasing', false);
    setObjectCamera('bars', 'camHUD');
    scaleObject('bars', 2, 2);
    addLuaSprite('bars');

    local removes = {'healthBar', 'healthBar.bg', 'iconP1', 'iconP2'}
    for _, obj in pairs(removes) do
	setProperty(obj..'.visible', false);
    end

    runHaxeCode([[
	var actualBar = new FlxBar(0, ClientPrefs.data.downScroll ? 90 : 740, null, 908, 18);
	actualBar.cameras = [game.camHUD];
	actualBar.createGradientBar([0xFFFFFFFF, 0xFFFF0000], [0xFF48FF48, 0xFFFFFFFF], 1, 0);
	actualBar.updateBar();
	actualBar.screenCenter(0x01);
	actualBar.x -= 90;
	addBehindGF(actualBar);

        setVar('actualBar', actualBar);
    ]]);

    makeLuaSprite('barbg', 'stages/w7/ffsonic/ui/healthBar_BG', getProperty('actualBar.x') - 4, getProperty('actualBar.y') - 4);
    setProperty('barbg.antialiasing', false);
    setObjectCamera('barbg', 'camHUD');
    scaleObject('barbg', 2, 2);
    addLuaSprite('barbg');

    makeLuaSprite('sonic_icon', 'stages/w7/ffsonic/ui/sonic_icon', 6, downscroll and 73 or 654);
    setProperty('sonic_icon.antialiasing', true);
    setObjectCamera('sonic_icon', 'camHUD');
    scaleObject('sonic_icon', 2, 2);
    addLuaSprite('sonic_icon');

    makeLuaSprite('aeon_icon', 'stages/w7/ffsonic/ui/aeon_icon', 966, downscroll and 73 or 654);
    setProperty('aeon_icon.antialiasing', true);
    setObjectCamera('aeon_icon', 'camHUD');
    scaleObject('aeon_icon', 2, 2);
    addLuaSprite('aeon_icon');

    setProperty('scoreTxt.x', getProperty('scoreTxt.x')-90);
    setTextFont('scoreTxt', 'maverick.ttf');
    setProperty('scoreTxt.antialiasing', false);
    setProperty('scoreTxt.borderSize', 0);
    setProperty('timeBar.y', -999);
    setProperty('timeTxt.y', -999);
    setProperty('comboGroup.visible', false);

    setProperty('camGame.scroll.x', 1100 / 2 - 1 - (screenWidth / 2));
    setProperty('camGame.scroll.y', 800 / 2 - 1 - (screenHeight / 2));
    setProperty('camFollow.x', 1100 / 2 - 1);
    setProperty('camFollow.y', 800 / 2 - 1);

    for i = 0, 3 do
	setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i]-30);
	setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i]-130);
	setPropertyFromGroup('strumLineNotes', i, 'y', getPropertyFromGroup('strumLineNotes', i, 'y') + (downscroll and 70 or 50));
	setPropertyFromGroup('strumLineNotes', i+4, 'y', getPropertyFromGroup('strumLineNotes', i+4, 'y') + (downscroll and 70 or 50));
    end

    setProperty('skipCountdown', true);
end

local s = 1;
function onUpdate(elapsed)
    setProperty('actualBar.percent', (getHealth() / 2) * 100);
    setProperty('camZooming', false);
    s = s + elapsed;
    if supersonic then
	setProperty('boyfriendGroup.y', lerp(getProperty('boyfriendGroup.y'), -180 + (math.cos(s) * 35), boundTo(1, 0, elapsed * 4)));
    end
end

function onEvent(name, value1, value2)
    if name == 'Sonic Events' then
	if value1 == 'transform' then
	    playAnim('boyfriend', 'transform', true);
	    setProperty('boyfriend.specialAnim', true);
	    doTweenY('transformTween', 'boyfriend', getProperty('boyfriend.y') - 90, 0.35, 'quartOut');
	elseif value1 == 'super sonic' then
	    cameraFlash('camGame', 'ffffff', 1);
	    triggerEvent('Change Character', 'BF', 'supersonic');
	    supersonic = true;
	elseif value1 == 'blackscreen fade' then
	    doTweenAlpha('blackFade', 'blackScreen', 0.001, 10);
	elseif value1 == 'blackscreen in' then
	    setProperty('camGame.alpha', 0.001);
	elseif value1 == 'blackscreen out' then
	    setProperty('camGame.alpha', 1);
	elseif value1 == 'black' then
	    setProperty('blackScreen.alpha', 1);
	elseif value1 == 'middle' then
	    if value2 == 'on' then
		setProperty('camFollow.x', 675);
		setProperty('camFollow.y', 450);
		setProperty('isCameraOnForcedPos', true);
	    elseif value2 == 'off' then
		setProperty('isCameraOnForcedPos', false);
	    end
	end
    end
end

function onUpdatePost()
    setTextString('scoreTxt', getProperty('scoreTxt.text'):upper());
end

function lerp(a,b,ratio)
    return a + ((b-a)*ratio)
end

function boundTo(value, min, max)
    return math.max(min, math.min(max, value))
end