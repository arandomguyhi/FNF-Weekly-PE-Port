function onCreate()
    makeLuaSprite('sky', 'stages/w7/fancy/sky', -275, -200)
    setProperty('sky.antialiasing', false)
    setScrollFactor('sky', 0.5, 0.5)
    addLuaSprite('sky')

    makeLuaSprite('grass', 'stages/w7/fancy/mountains', -100, -475)
    setProperty('grass.antialiasing', false)
    setScrollFactor('grass', 0.75, 0.75)
    addLuaSprite('grass')

    makeLuaSprite('flag', 'stages/w7/fancy/flag', 1650, 365)
    setProperty('flag.antialiasing', false)
    addLuaSprite('flag')

    makeLuaSprite('ground', 'stages/w7/fancy/platforms', 0, -475)
    setProperty('ground.antialiasing', false)
    addLuaSprite('ground')
end

function onCreatePost()
    setProperty('camGame.scroll.x', 1300 - (screenWidth / 2))
    setProperty('camGame.scroll.y', 500 - (screenHeight / 2))
end