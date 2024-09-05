-- awesome script fr
function onCreate()
    addHaxeLibrary('FlxBar', 'flixel.ui');
    addHaxeLibrary('FlxBarFillDirection', 'flixel.ui.FlxBar');
    addHaxeLibrary('FlxColor', 'flixel.util');

    runHaxeCode([[
	var barbg:FlxSprite = new FlxSprite(510, 218);
	barbg.loadGraphic(Paths.image("stages/w7/pico/alucardHP_box"));
	barbg.antialiasing = ClientPrefs.data.antialiasing;
	barbg.cameras = [game.camHUD];
	addBehindDad(barbg);
   
	var newBar = new FlxBar(515, 236, FlxBarFillDirection.RIGHT_TO_LEFT, barbg.width - 10, barbg.height / 2 - 3, game, 'songPercent', 0, 1, false);
	newBar.createImageBar(Paths.image('stages/w7/pico/hpbar'), Paths.image('stages/w7/pico/hpbar') );
	newBar.createFilledBar(FlxColor.LIME, FlxColor.RED, true, null);
 	newBar.cameras = [game.camHUD];
	newBar.antialiasing = ClientPrefs.data.antialiasing;
	addBehindDad(newBar);
    ]]);
end