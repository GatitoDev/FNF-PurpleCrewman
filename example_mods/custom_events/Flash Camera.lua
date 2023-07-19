color = 'ffffff'

function onEvent(name,value1,value2)

	if name == 'Flash Camera' then

	   	makeLuaSprite('flash', '', 0, 0);
    	makeGraphic('flash', 1280, 720, color)
	    addLuaSprite('flash', true);
	    setLuaSpriteScrollFactor('flash', 0, 0)
	    setProperty('flash.scale.x', 2)
	    setProperty('flash.scale.y', 2)
	    setProperty('flash.alpha', 0)
		setProperty('flash.alpha', 1)
		doTweenAlpha('flTw','flash', 0, value1, 'linear')

	end

end