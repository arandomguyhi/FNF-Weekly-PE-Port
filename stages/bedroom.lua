local prefix = 'stages/w4/sunday/'

function onCreate()
    makeLuaSprite('floor', prefix..'floor', -850, 630) addLuaSprite('floor')
    makeLuaSprite('wall', prefix..'wall', -400, -70) addLuaSprite('wall')
    makeLuaSprite('speaker', prefix..'speaker', -80, 365) addLuaSprite('speaker')
end

function onCreatePost()
    snapCamFollowToPos(710, 500, false)
end