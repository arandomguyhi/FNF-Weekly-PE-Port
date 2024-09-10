luaDebugMode = true
function onCreate()
    addHaxeLibrary('FlxBar', 'flixel.ui');
    addHaxeLibrary('FlxBarFillDirection', 'flixel.ui.FlxBar');
    addHaxeLibrary('FlxColor', 'flixel.util');

    for _, obj in pairs({'healthBar', 'healthBar.bg', 'iconP1', 'iconP2'}) do
	setProperty(obj..'.visible', false)
    end

    runHaxeCode([[
	var newBar = new FlxBar(0, ClientPrefs.data.downScroll ? 25 : 625, null, 75, 13, game, 'health', 0, 2, false);
	newBar.createImageBar(Paths.image('stages/w2/skullkid/majora_healthbar'), Paths.image('stages/w2/skullkid/majora_healthbar') );
	newBar.createFilledBar(FlxColor.fromRGB(198, 39, 39), FlxColor.fromRGB(88, 196, 0), false, null);
 	newBar.cameras = [game.camHUD];
	newBar.scale.set(3, 3);
	newBar.updateHitbox();
	newBar.screenCenter(0x01);
	addBehindDad(newBar);
	setVar('newBar', newBar);
    ]])

    makeLuaSprite('newBarBG', 'stages/w2/skullkid/majora_healthbarbg', 0, downscroll and 25 or 625)
    setObjectCamera('newBarBG', 'camHUD')
    scaleObject('newBarBG', 3, 3)
    screenCenter('newBarBG', 'X')
    setObjectOrder('newBarBG', getObjectOrder(getVar('newBar'))+1)
    addLuaSprite('newBarBG')

    setProperty('timeBar.y', -999)
    setProperty('timeTxt.y', -999)
    setProperty('scoreTxt.y', getProperty('newBarBG.y') + 50)
    setTextFont('scoreTxt', 'FOT-ChiaroStd-B.otf')
end