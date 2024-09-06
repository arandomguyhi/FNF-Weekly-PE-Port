function onCreate()
    makeLuaSprite('sky', 'stages/w4/annie/sky', -614, -1027)
    setProperty('sky.antialiasing', true)
    setScrollFactor('sky', 0.65, 0.65)
    addLuaSprite('sky')

    makeLuaSprite('clouds', 'stages/w4/annie/sky', -336, -524)
    setProperty('clouds.antialiasing', true)
    setScrollFactor('clouds', 0.7, 0.7)
    addLuaSprite('clouds')

    makeLuaSprite('buildingsfar', 'stages/w4/annie/buildingsbg', 103, -176)
    setProperty('buildingsfar.antialiasing', true)
    setScrollFactor('buildingsfar', 0.8, 0.8)
    addLuaSprite('buildingsfar')

    makeLuaSprite('buildings', 'stages/w4/annie/buildings', -778, -304)
    setProperty('buildings.antialiasing', true)
    setScrollFactor('buildings', 0.9, 0.9)
    addLuaSprite('buildings')

    makeLuaSprite('grass', 'stages/w4/annie/grass', -574, -240)
    setProperty('grass.antialiasing', true)
    setScrollFactor('grass', 0.95, 0.95)
    addLuaSprite('grass')

    makeLuaSprite('ground', 'stages/w4/annie/road', -785, 387)
    setProperty('ground.antialiasing', true)
    addLuaSprite('ground')
end

function onCreatePost()
    snapCamFollowToPos(700, 200, false)
end