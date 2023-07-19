-- Event edit by GatitoDev :3

StartStop = 0
Speed = 0 --This is not used

function onUpdate()

    if StartStop == 1 then-- is true
        makeLuaSprite('BlackFlash', '', 0, 0);
		makeGraphic('BlackFlash', 1280, 720, '000000')
		setLuaSpriteScrollFactor('BlackFlash', 0, 0)
		--scaleObject('BlackFlash', 18, 22); --It's just unnecessary
		setProperty('BlackFlash.scale.x', 2)
	    setProperty('BlackFlash.scale.y', 2)
		addLuaSprite('BlackFlash', true)
		setProperty('BlackFlash.visible', true);
		setProperty('BlackFlash.alpha', 1)
    end

    if StartStop == 2 then-- is false
        setProperty('BlackFlash.visible', false)
    end
end

function onEvent(name, value1, value2)
	if name == 'BlackOut' then
		StartStop = tonumber(value1)
        Speed = tonumber(value2)
	end
end