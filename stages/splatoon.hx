import objects.BGSprite;
import backend.ClientPrefs;
import flixel.util.FlxStringUtil;

var PREFIX:String = 'splatoon/';
var isMiddlescroll;

var orderlings:Array<Character> = [];

var pearlRadians:Float = 0;
var gfY:Float;
var croch:Float = 0.375; // lowkey dont know why conductor doesnt work

var wave:Int = 0;
var positions:Array<Array<Float>> = [
    [1375, 340],
    [1600, 340]
];
var dadActive:Bool = false;

var splashScreen:FlxSprite;

function onCreate()
{
    game.skipCountdown = true;

    game.addCharacterToList('four', 1);
    game.addCharacterToList('blaster', 1);
    game.addCharacterToList('roller', 1);
    game.addCharacterToList('slosher', 1);
    game.addCharacterToList('brella', 1);

    var window:BGSprite = new BGSprite(PREFIX + 'window', 200, -295, 0.5, 0.5);
    addBehindGF(window);

    var pillar:BGSprite = new BGSprite(PREFIX + 'Elavator', 1000, -375, 0.65, 0.65);
    addBehindGF(pillar);

    var mid:BGSprite = new BGSprite(PREFIX + 'mid', 600, 350, 0.9, 0.9);
    addBehindGF(mid);

    var stage:BGSprite = new BGSprite(PREFIX + 'stage', 758.7, 419.2);
    addBehindGF(stage);

    splashScreen = new FlxSprite(-2, -1);
    splashScreen.frames = Paths.getSparrowAtlas(PREFIX + 'splashdownsmokescreen');
    splashScreen.animation.addByPrefix('thing', 'inkscreen0', 24, false, 0, 0);
    splashScreen.alpha = 0.001;
    splashScreen.cameras = [game.camOther];
    add(splashScreen);

    isMiddlescroll = ClientPrefs.data.middleScroll;
    ClientPrefs.data.middleScroll = true;
}

function onCreatePost()
{
    game.comboGroup.setPosition(500, 200);

    game.camFollow.x = 1450; game.camFollow.y = -225; game.cameraSpeed = 1000;
    FlxG.camera.zoom = 1.1;
    game.isCameraOnForcedPos = true;
    game.camHUD.alpha = 0;

    game.dad.alpha = 0;
    gfY = game.gf.y;
    positions.push([game.dad.x, game.dad.y]);
}

function startDropIn(newChar:String, pos:Int, isDad:Bool)
{
    // SETUP
    var daX:Float = positions[pos][0];
    var daY:Float = positions[pos][1];

    var newGuy:Character = null;

    if (isDad) dadActive = true; 

    var flyAnim:String = 'drop';
    var fallAnim:String = 'fall';
    if (newChar == 'four') 
    {
        flyAnim = 'drop-four';
        fallAnim = 'fall-four';
    }

    var battlebus:Character = new Character(daX, daY - 400, 'dropin', false);
    battlebus.flipX = false;
    add(battlebus);

    var drone:FlxSprite = new FlxSprite(daX - 20, daY - 200);
    drone.frames = Paths.getSparrowAtlas(PREFIX + 'flyaway');
    drone.animation.addByPrefix('fly', 'fly0', 24, true);
    add(drone);
    drone.alpha = 0.001;

    if (!isDad) {
        newGuy = new Character(daX, daY, newChar, false);
        newGuy.flipX = false;
        orderlings.push(newGuy);
        game.addBehindDad(newGuy);
        newGuy.alpha = 0.001;
    }
    else {
        game.triggerEvent('Change Character', 'dad', newChar);
        game.dad.alpha = 0.01;
    }

    // TWEENSVILLE
    battlebus.playAnim(flyAnim);
    FlxTween.tween(battlebus, {y : daY - 200}, croch * 3, {ease: FlxEase.sineOut, onComplete: function(twn:FlxTween) {
        battlebus.playAnim(fallAnim);
        drone.animation.play('fly');
        drone.alpha = 1;
        FlxTween.tween(drone, {y : daY - 400}, croch * 2, {ease: FlxEase.sineOut, onComplete: function(twn:FlxTween) {
            drone.kill();
            drone.destroy();
        }});
        FlxTween.tween(battlebus, {y : daY - 15}, croch * 1.5, {ease: FlxEase.sineIn, onComplete: function(twn:FlxTween) {
            battlebus.playAnim('splash');
            if (isDad) 
            {
                game.dad.alpha = 1;
                game.dad.playAnim('rise', false);
            }
            else
            {
                newGuy.alpha = 1;
                newGuy.playAnim('rise', false);
            }
            new FlxTimer().start(croch * 1.5, ()->{
                battlebus.kill();
                battlebus.destroy();
                if (isDad) {
                    game.dad.dance();
                }
                else {
                    newGuy.dance();
                }
            });
        }});
    }});
}

function onBeatHit()
{
    if (game.curBeat % 2 == 0) {
        for (orderling in orderlings) 
        {
            var anim:String = orderling.animation.curAnim.name;
            if (anim == 'idle') orderling.dance();
        }
    }
}

function onEvent(name, v1, v2)
{
    switch (name) 
    {
        case 'Splatoon Events':
            switch (v1)
            {
                case 'intro':
		game.cameraSpeed = 1;
                FlxTween.tween(game.camFollow, {y: 475}, 9, {ease: FlxEase.smootherStepInOut, 
                onComplete: function(tween:FlxTween) {
                    new FlxTimer().start(3, function(tmr:FlxTimer)
                    {
                        FlxTween.tween(game.camHUD, {alpha: 1.0}, 2.0, {ease: FlxEase.expoOut});
                        game.isCameraOnForcedPos = false;
                    });
                }});
                FlxTween.tween(FlxG.camera, {zoom: 1.3}, 9, {ease: FlxEase.smootherStepInOut});
                case 'Next Wave':
                    wave++;
                    switch (wave)
                    {
                        case 1:
                            startDropIn('blaster', 0, false);
                            startDropIn('roller', 1, false);
                        case 2:
                            startDropIn('brella', 0, false);
                            startDropIn('blaster', 1, false);
                            startDropIn('slosher', 2, true);
                        case 3:
                            startDropIn('blaster', 0, false);
                            startDropIn('roller', 1, false);
                            startDropIn('four', 2, true);
                    }
                
                case 'Kill':
                    for (orderling in orderlings) {
                        spawnSplat(orderling.x - 160, orderling.y - 50);

                        orderling.kill();
                        orderling.destroy();
                    }
                    if (dadActive) {
                        spawnSplat(game.dad.x - 160, game.dad.y - 50);
                    }
                    orderlings = [];
                    game.dad.alpha = 0;
                    dadActive = false;

                case 'Pop Ult':
                    game.boyfriend.visible = false;

                    new FlxTimer().start(croch, ()->{
                        splashScreen.alpha = 1;
                        splashScreen.animation.play('thing');
                    });
            }
    }
}

function spawnSplat(x:Float, y:Float)
{
    var splat:FlxSprite = new FlxSprite(x, y);
    splat.frames = Paths.getSparrowAtlas(PREFIX + 'splat');
    splat.animation.addByPrefix('splat', 'splat0', 24, false);
    splat.antialiasing = ClientPrefs.globalAntialiasing;
    add(splat);
    splat.animation.play('splat');
    new FlxTimer().start(croch * 0.75, ()->{
        splat.kill();
        splat.destroy();
    });
}

function onSpawnNotePost(note:Note)
{
    switch (note.noteType) {
        case 'Left Orderling':
            note.noAnimation = true;
        case 'Right Orderling':
            note.noAnimation = true;
    }
}

function onMoveCamera(turn)
{
    switch (turn) 
    {
        case 'dad':
            game.defaultCamZoom = 1.3;
        default:
            game.defaultCamZoom = 1.5;
    }
}

function opponentNoteHit(note:Note)
{
    switch (note.noteType) 
    {
        case 'Left Orderling':
            orderlings[0].playAnim(game.singAnimations[note.noteData % 4], true);
            orderlings[0].holdTimer = 0;
        case 'Right Orderling':
            orderlings[1].playAnim(game.singAnimations[note.noteData % 4], true);
            orderlings[1].holdTimer = 0;
    }
}

function onUpdate(elapsed) {
    var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
	if(curTime < 0) curTime = 0;
    var songCalc:Float = (game.songLength - curTime);
    var secondsTotal:Int = Math.floor(songCalc / 1000);
	if(secondsTotal < 0) secondsTotal = 0;
    game.modchartTexts.get('splatTimerTxt').text = FlxStringUtil.formatTime(secondsTotal, false);
}

function onUpdatePost(elapsed)
{
    pearlRadians += elapsed;
    game.gf.y = 25 * Math.cos(pearlRadians) + gfY;
}

function onDestroy() {
    ClientPrefs.data.middleScroll = isMiddlescroll;
}