local coolSection = false

luaDebugMod = true
function onCreate()
    makeLuaSprite('mainBG', 'fakepizze/wall', -100, -150)
    addLuaSprite('mainBG')

    makeLuaSprite('floor', 'fakepizze/floor', -100, -150)
    addLuaSprite('floor')

    makeLuaSprite('thelight', 'fakepizze/light', -100, -150)
    runHaxeCode("game.getLuaObject('thelight').blend = 8;")
    addLuaSprite('thelight', true)

    makeLuaSprite('thedark', 'fakepizze/shade', -100, -150)
    runHaxeCode("game.getLuaObject('thedark').blend = 9;")
    addLuaSprite('thedark', true)

    makeLuaSprite('border', 'fakepizze/border', -100, -150)
    addLuaSprite('border', true)
end

function onCreatePost()
    setProperty('healthBar.flipX', true) setProperty('healthBar.leftBar.flipX', true) setProperty('healthBar.rightBar.flipX', true)
    for i = 1,2 do setProperty('iconP'..i..'.flipX', not getProperty('iconP'..i..'.flipX'))end
    setProperty('camFollow.x', 1900) setProperty('camFollow.y', 775)
    setProperty('camZooming', true)

    for i = 0, 3 do
	setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i])
	setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i])
    end

    setObjectCamera('comboGroup', 'camGame')
    setProperty('comboGroup.x', 1400) setProperty('comboGroup.y', 750)
end

function onBeatHit()
    if getProperty('camZooming') and coolSection then
	setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.015 * getProperty('camZoomingMult'))
	setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.03 * getProperty('camZoomingMult'))
    end
end

function onEvent(name, value1, value2)
    if name == 'Beat Bop' then
	if value1 == 'on' then
	    coolSection = true
	elseif value1 == 'off' then
	    coolSection = false
	end
    elseif name == 'Middle' then
	if value1 == 'on' then
	    setProperty('camFollow.x', 1900) setProperty('camFollow.y', 1200)
	    setProperty('isCameraOnForcedPos', true)
	elseif value1 == 'off' then
	    setProperty('isCameraOnForcedPos', false)
	end
     end
end

function onUpdatePost()
    local P1Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)
    local P2Mult = getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)
    setProperty('iconP1.origin.x', 240) setProperty('iconP1.x', P1Mult - 95)
    setProperty('iconP2.origin.x', -100) setProperty('iconP2.x', P2Mult + 100)
end