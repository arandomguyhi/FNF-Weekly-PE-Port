function onCreatePost()
    makeLuaText('text', '', 0, 0, 0)
    setTextFont('text', 'deltarune.ttf')
    setTextSize('text', 37)
    setTextAlignment('text', 'center')
    setProperty('text.antialiasing', false)
    screenCenter('text', 'X')
    setProperty('text.borderSize', 2)
    updateHitbox('text')
    setProperty('text.y', 500)
    addLuaText('text')
end

function onEvent(eventName, value1, value2)
    if eventName == 'subtitle' then
	setTextString('text', value1)
        updateHitbox('text')
        screenCenter('text', 'X')
        --setProperty('text.y', getProperty('healthBar.bg.y') - (getProperty('text.height') * 2))
    end
end