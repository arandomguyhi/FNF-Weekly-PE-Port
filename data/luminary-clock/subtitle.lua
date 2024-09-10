function onCreate()
    makeLuaText('text', '', 0, 0, 0)
    setTextFont('text', 'bombardier.regular.ttf')
    setTextSize('text', 48)
    setTextColor('text', 'e0e0e0')
    setProperty('text.borderColor', getColorFromHex('575757'))
    setProperty('text.antialiasing', true)
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
    end
end