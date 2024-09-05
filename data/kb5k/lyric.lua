function onCreatePost()
    makeLuaText('text', '', 0, 0, 0);
    setTextFont('text', 'maverick.ttf');
    setTextSize('text', 32);
    setTextAlignment('text', 'CENTER');
    setProperty('text.antialiasing', false);
    screenCenter('text', 'X');
    setProperty('text.borderSize', 2);
    updateHitbox('text');
    setProperty('text.y', 575);
    addLuaText('text');
end

function onEvent(name, value1, value2)
    if name == 'lyric' then
	setTextString('text', value1);
	updateHitbox('text');
	screenCenter('text', 'X');
	setProperty('text.x', getProperty('text.x')-80);
    end
end