function onCreate()
    makeLuaSprite('bg', 'stages/w1/chefblast')
    setScrollFactor('bg', 0.9, 1)
    addLuaSprite('bg')

    makeLuaSprite('stageFront', 'stages/w1/chefblast/table', 10, 875)
    addLuaSprite('stageFront')
end