local loaded = false
local p = 0
local poppedPegs = false
local redPegs = 25

luaDebugMode = true
function onCreate()
    setProperty('skipCountdown', true)

    makeLuaSprite('b', 'stages/w1/peggle/katiscrackedbro')
    addLuaSprite('b')

    makeLuaSprite('bg', 'stages/w1/peggle/susPegle')
    addLuaSprite('bg', true)

    makeLuaSprite('ba', 'stages/w1/peggle/basket', 0, 562)
    scaleObject('ba', 1.2, 1.2)
    addLuaSprite('ba', true)

    makeLuaSprite('ttt', 'stages/w1/peggle/title', 249, 300)
    setScrollFactor('ttt', 0, 0)
    setObjectCamera('ttt', 'camOther')
    setProperty('ttt.alpha', 0.001)
    addLuaSprite('ttt', true)

    makeLuaSprite('shower', nil, -100, -100)
    makeGraphic('shower', screenWidth*2, screenHeight*2, '000000')

    local pegCount = 70;
    for i = 1, pegCount do
	local pegp = 'blue';
	if redPegs > 0 then pegp = 'red'; redPegs = redPegs - 1; end
        makeLuaSprite('peg', 'stages/w1/peggle/'..pegp..'Peg', getRandomInt(100,700), getRandomInt(200,500))
	setProperty('peg.ID', i)
	addLuaSprite('peg')
    end

    makeLuaSprite('ball', 'stages/w1/peggle/ball', 500, 500)
    addLuaSprite('ball')

    makeLuaText('ga', 'whwer', -1, 300, 3)
    setTextSize('ga', 16)
    setTextColor('ga', '65F5F9')
    setObjectCamera('ga', 'camGame') setScrollFactor('ga', 1, 1)
    addLuaText('ga', true)

    makeLuaText('ha', 'whener', -1, 700, 13)
    setTextSize('ha', 16)
    setTextColor('ha', '65F5F9')
    setObjectCamera('ha', 'camGame') setScrollFactor('ha', 1, 1)
    addLuaText('ha', true)

    addLuaSprite('shower', true)
end

function onCreatePost()
    setProperty('healthBar.alpha', 0.001)
    setProperty('healthBar.bg.alpha', 0.001)

    setProperty('healthBar.angle', 90)
    callMethod('healthBar.setPosition', {-80, 400})
    runHaxeCode("game.healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);")
    setProperty('timeBar.y', -999)
    for _, i in pairs({'dad', 'iconP1', 'iconP2', 'scoreTxt', 'timeTxt'}) do
	setProperty(i..'.visible', false)
    end

    for i = 0, 3 do
	setProperty('opponentStrums.members['..i..'].alpha', 0.001)
	setPropertyFromGroup('notes', i, 'copyAlpha', true)
    end
end

function opponentNoteHit()
    setProperty('health', getProperty('health') + 0.03)
end

function onUpdate(elapsed)
    setProperty('camZooming', false)
    setTextString('ha', getProperty('songScore'))
    setProperty('ha.x', 670 - getProperty('ha.width'))

    setTextString('ga', math.round(getProperty('ratingPercent') * 100)..'%\n'..getProperty('songMisses'))
    setProperty('ga.x', 300 - getProperty('ga.width'))

    p = p + 1
    setProperty('ba.x', 300 + (math.sin(p/50 / (getPropertyFromClass('flixel.FlxG', 'updateFramerate') / 60)) * 180))
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if isSustainNote then return end
    local n = getProperty('boyfriend.animation.curAnim.name')
    if n == 'singLEFT' and getProperty('boyfriend.scale.x') == -1 then
	playAnim('boyfriend', 'turn', true)
	setProperty('boyfriend.specialAnim')
	setProperty('boyfriend.scale.x', 1)
	updateHitbox('boyfriend')
    end
    if n == 'singRIGHT' and getProperty('boyfriend.scale.x') == 1 then
	setProperty('boyfriend.scale.x', -1)
	updateHitbox('boyfriend')
	playAnim('boyfriend', 'turn', true)
	setProperty('boyfriend.specialAnim', true)
    end
end

function onBeatHit()
    if curBeat == 1 then
	triggerEvent('Camera Follow Pos', 395, 300)
	doTweenAlpha('bzl', 'healthBar', 1, 1)
	doTweenAlpha('bzl2', 'healthBar.bg', 1, 1)
	doTweenAlpha('bzl3', 'shower', 0.001, 1)
	doTweenAlpha('bzl4', 'ttt', 1, 1)
    elseif curBeat == 4 then
	doTweenAlpha('bzl4', 'ttt', 0.001, 1)
    end
end

function math.round(x, n)
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end