luaDebugMode = true
function onCreate()
    addHaxeLibrary('FlxBar', 'flixel.ui');
    addHaxeLibrary('FlxBarFillDirection', 'flixel.ui.FlxBar');
    addHaxeLibrary('FlxColor', 'flixel.util');

    runHaxeCode([[
	var newBar = new FlxBar(1006, 125, null, 238, 43, game, 'songPercent', 0, 1, false);
	newBar.createImageBar(Paths.image('stages/w2/mithrix/rortimebar'), Paths.image('stages/w2/mithrix/rortimebar') );
	newBar.createFilledBar(FlxColor.fromRGB(255, 255, 255), FlxColor.fromRGB(0, 0, 0), false, null);
 	newBar.cameras = [game.camHUD];
	addBehindDad(newBar);
	setVar('newBar', newBar);
    ]])

    makeLuaSprite('newBarBG', 'stages/w2/mithrix/rortimebarBG', 1006, 125)
    setObjectCamera('newBarBG', 'camHUD')
    setObjectOrder('newBarBG', getObjectOrder(getVar('newBar'))+1)
    addLuaSprite('newBarBG')
end