local defeat = 5
local themes = {'dad', 'gang', 'salad', 'tank', 'tricky'}
local notesHit = 0

luaDebugMode = true
function onCreate()
    setProperty('skipCountdown', true)

    makeLuaText('text', '', 0, 0, 0)
    setTextFont('text', 'arialbd.ttf')
    setTextSize('text', 18)
    setTextAlignment('text', 'CENTER')
    setTextColor('text', 'ffffff')
    setProperty('text.antialiasing', true)
    setProperty('text.borderSize', 2)
    updateHitbox('text')
    setProperty('text.x', 892)
    setProperty('text.y', 568)
    addLuaText('text')

    makeLuaSprite('bgb', 'stages/w7/pico/room', 275, 141)
    addLuaSprite('bgb')

    makeLuaSprite('chairs', 'stages/w7/pico/chairs', 275, 141)
    addLuaSprite('chairs')

    makeLuaSprite('kid1', 'stages/w7/pico/kid1', 835, 400)
    addLuaSprite('kid1')

    makeLuaSprite('kid2', 'stages/w7/pico/kid2', 365, 250)
    addLuaSprite('kid2')

    makeLuaSprite('kid3', 'stages/w7/pico/kid3', 710, 265)
    addLuaSprite('kid3')

    makeLuaSprite('ui', 'stages/w7/pico/ui', 275, 139)
    loadGraphic('ui', 'stages/w7/pico/ui', 260, 464, true)
    addAnimation('ui', 'bum', {0, 1, 2, 3, 4}, 0)
    playAnim('ui', 'bum')
    setProperty('ui.animation.curAnim.curFrame', (downscroll and 0 or 1))
    setObjectCamera('ui', 'camOther')
    addLuaSprite('ui')

    makeLuaSprite('map', 'stages/w7/pico/map', 781, 139)
    loadGraphic('map', 'stages/w7/pico/map', 222, 102, true)
    addAnimation('map', 'bum', {0, 0, 1, 1}, 6, true)
    playAnim('map', 'bum')
    setObjectCamera('map', 'camOther')
    addLuaSprite('map')

    makeLuaSprite('hpBar', 'stages/w7/pico/hpSheet', 888, 569)
    loadGraphic('hpBar', 'stages/w7/pico/hpSheet', 116, 37, true)
    addAnimation('hpBar', 'bar', {0, 1, 2, 3, 4}, 0, false)
    playAnim('hpBar', 'bar')
    setProperty('hpBar.animation.curAnim.curFrame', 4)
    setObjectCamera('hpBar', 'camOther')
    addLuaSprite('hpBar')
end

function onSpawnNote()
    for i = 0, getProperty('notes.length')-1 do
	setPropertyFromGroup('notes', i, 'visible', getPropertyFromGroup('notes', i, 'mustPress'))

	if getPropertyFromGroup('notes', i, 'mustPress') then
	    setPropertyFromGroup('notes', i, 'noteSplashData.disabled', true)
	end

	setPropertyFromGroup('notes', i, 'scale.x', 0.394267515923567) -- sim
	setPropertyFromGroup('notes', i, 'scale.y', 0.394267515923567) -- sim squared
    end
end

local s = 1
function onUpdatePost(elapsed)
    s = s + elapsed
    setProperty('kid1.y', lerp(getProperty('kid1.y'), 400 - 5 + (math.cos(s) * 15), boundTo(1, 0, elapsed * 4)))
    setProperty('kid2.y', lerp(getProperty('kid2.y'), 250 - 5 + (math.cos(s) * 35), boundTo(1, 0, elapsed * 4)))
    setProperty('kid3.y', lerp(getProperty('kid3.y'), 265 - 5 + (math.cos(s) * 25), boundTo(1, 0, elapsed * 4)))
    setProperty('camZooming', false)
    if defeat <= 0 then setHealth(-2) return end
    setProperty('hpBar.animation.curAnim.curFrame', defeat - 1)
    setTextString('text', getProperty('songScore'))
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if defeat < 5 and not isSustainNote then
	notesHit = notesHit + 1
	if notesHit == 10 then
	    notesHit = 0

	    if defeat < 5 then
		defeat = defeat + 1
	    end
	end
    end
end

function noteMiss()
    defeat = defeat - 1
    notesHit = 0
end

function onCreatePost()
    makeLuaSprite('noteBG', nil, 260, 140)
    makeGraphic('noteBG', 275, 470, '000000')
    setProperty('noteBG.alpha', 0.25)
    setObjectCamera('noteBG', 'camHUD')
    addLuaSprite('noteBG')

    setProperty('healthGain', 0)
    setProperty('healthLoss', 0)

    local removes = {'iconP1', 'iconP2', 'scoreTxt', 'timeTxt', 'healthBar', 'healthBar.bg', 'timeBar'}
    for _, obj in ipairs(removes) do setProperty(obj..'.visible', false)end

    for i = 0, 3 do
	setProperty('opponentStrums.members['..i..'].visible', false)
	setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i])
    end

    setProperty('camGame.scroll.x', 1280 / 2 - 1 - (screenWidth / 2))
    setProperty('camGame.scroll.y', 720 / 2 - 1 - (screenHeight / 2))
    setProperty('camFollow.x', 1280 / 2 - 1)
    setProperty('camFollow.y', 720 / 2 - 1)
    setProperty('isCameraOnForcedPos', true)

    setProperty('comboGroup.visible', false)

    -- note scale
    for i = 0, 3 do
	local x = getPropertyFromGroup('playerStrums', i, 'scale.x')
	local y = getPropertyFromGroup('playerStrums', i, 'scale.y')

	setPropertyFromGroup('playerStrums', i, 'scale.x', x * 1 - 0.3)
	setPropertyFromGroup('playerStrums', i, 'scale.y', y * 1 - 0.3)

	setPropertyFromGroup('playerStrums', i, 'x', getPropertyFromGroup('playerStrums', i, 'x') + 165)
	setPropertyFromGroup('playerStrums', i, 'y', getPropertyFromGroup('playerStrums', i, 'y') + 102)
	setPropertyFromGroup('playerStrums', i, 'x', getPropertyFromGroup('playerStrums', 0, 'x') + i*62)
    end

    makeLuaSprite('th', 'stages/w7/pico/themes/'..themes[getRandomInt(1,5)])
    setObjectCamera('th', 'camOther')
    addLuaSprite('th')

    makeLuaSprite('bg', 'stages/w7/pico/site')
    setObjectCamera('bg', 'camOther')
    addLuaSprite('bg')
end

function lerp(a,b,ratio)
    return a + ((b-a)*ratio)
end

function boundTo(value, min, max)
    return math.max(min, math.min(max, value))
end