luaDebugMode = true
function onEvent(name, value1, value2)
    if name == 'Camera Zoom' then
	local val1 = tonumber(value1)

	local targetZoom = getProperty('defaultCamZoom') * val1
	if value2 ~= '' then
	    local split = stringSplit(value2, ',')
	    local duration = 0
	    local leEase = 'linear'
	    if split[1] ~= nil then duration = tonumber(math.floor(split[1] / 10)) end
	    if split[2] ~= nil then leEase = split[2] end

	    if duration > 0 then
		runHaxeCode("FlxTween.tween(FlxG.camera, {zoom = ]]..targetZoom..[[}, ]]..duration..[[, {ease: FlxEase.circOut});")
		--startTween('camTween', 'game', {defaultCamZoom = targetZoom, ['camGame.zoom'] = targetZoom}, duration, {ease = 'circOut'})
	    else
		setProperty('defaultCamZoom', targetZoom)
	    end
	end
	setProperty('defaultCamZoom', targetZoom)
    end

    if name == 'HUD Fade' then
	local leAlpha = tonumber(value1)
	local duration = tonumber(value2)

	if duration > 0 then
	    startTween('camHUDAlphaTween', 'camHUD', {alpha = leAlpha}, duration, {ease = 'linear'})
	else
	    setProperty('camHUD.alpha', leAlpha)
	end
     end
end