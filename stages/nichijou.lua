local prefix = 'stages/w9/nichijou/'

local maiIconColour = '74543B'
local mioIconColour = '8FBEF7'
local forceSection = false
local iconCanChange = true
local focusChar = nil

function onCreate()
    makeLuaSprite('BG', prefix..'bg', -400, -520)
    addLuaSprite('BG')

    makeLuaSprite('overlay', prefix..'gradient', -400, -520)
    setProperty('overlay.antialiasing', true)
    runHaxeCode("game.getLuaObject('overlay').blend = 12;")
    addLuaSprite('overlay', true)
end

function onCreatePost()
    setProperty('camGame.scroll.x', 850 - (screenWidth / 2))
    setProperty('camGame.scroll.y', 360 - (screenHeight / 2))

    createInstance('mai', 'objects.Character', {getProperty('gf.x') - 360, getProperty('gf.y') - 8, 'mai', false})
    setProperty('mai.flipX', false)
    addLuaSprite('mai')
    setScrollFactor('mai', 1, 1)

    setObjectCamera('comboGroup', 'camGame')
end

function onSpawnNote(i,d,t,s)
    if t == 'Mai Note' and not getPropertyFromGroup('notes', i, 'mustPress') then
	setPropertyFromGroup('notes', i, 'noAnimation', true)
    end
end

function opponentNoteHit(id,noteData,noteType,isSustainNote)
    if noteType == 'Mai Note' then
	playAnim('mai', getProperty('singAnimations')[noteData % 4], true)
	setProperty('mai.holdTimer', 0)
	if not isSustainNote and iconCanChange then updateIcons('mai', maiIconColour) end
    elseif noteType == 'GF Sing' then
	if not isSustainNote and iconCanChange then updateIcons('mio', maiIconColour) end
    else
	if not isSustainNote and iconCanChange then updateIcons('yuuko', callMethodFromClass('psychlua.CustomFlxColor', 'fromRGB', getProperty('boyfriend.healthColorArray'))) end
    end
end

function updateIcons(icon, colour)
    setProperty('healthBar.leftBar.color', getColorFromHex(to_hex(getProperty('dad.healthColorArray'))))
    callMethod('iconP2.changeIcon', {icon})
end

function onEvent(name, v1, v2)
    if name == 'Motivation Events' then
	if v1 == 'force section' then
	    if v2 == 'mio' then
		focusChar = 'gf'
		forceSection = true
	    elseif v2 == 'mai' then
		focusChar = 'mai'
		forceSection = true
	    else
		forceSection = false
	    end
	    fakeMoveCamera(focusChar, forceSection)
	elseif v1 == 'icons can change' then
	    if v2 == 'true' then
		iconCanChange = true
	    elseif v2 == 'false' then
		iconCanChange = false
	    end
	elseif v1 == 'middle cam' then
	    if v2 == 'true' then
		setProperty('camFollow.x', 850)
		setProperty('camFollow.y', 380)
		setProperty('isCameraOnForcedPos', true)
	    elseif v2 == 'false' then
		setProperty('isCameraOnForcedPos', false)
	    end
	end
    end
end

function onBeatHit()
    if curBeat % 2 == 0 then
	local anim = getProperty('mai.animation.curAnim.name')
	if anim == 'idle' then callMethod('mai.dance', {''}) end
    end
end

function onUpdate()
    if forceSection then
	fakeMoveCamera(focusChar, forceSection)
    end
end

function fakeMoveCamera(char, toogle)
    setProperty('isCameraOnForcedPos', toogle)
    if toogle then
	local curCharacter = char

        setProperty('camFollow.x', getMidpointX(char) + 150 + getProperty(char..'.cameraPosition[0]') + getProperty('opponentCameraOffset[0]'))
	setProperty('camFollow.y', getMidpointY(char) - 100 + getProperty(char..'.cameraPosition[1]') + getProperty('opponentCameraOffset[1]'))

	whosTurn = char
    end
end

function to_hex(rgb)
    return string.format('%x', (rgb[1] * 0x10000) + (rgb[2] * 0x100) + rgb[3])
end