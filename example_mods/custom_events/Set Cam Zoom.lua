function onEvent(name,value1,value2)

    if name == "Set Cam Zoom" then
        
        doTweenZoom('zoom','camGame',value1,value2,'sineInOut')

	end
end