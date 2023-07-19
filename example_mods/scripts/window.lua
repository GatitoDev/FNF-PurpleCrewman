function onCreatePost()
	setPropertyFromClass("openfl.Lib", "application.window.title", "Friday Night Funkin\': Vs. Purple Crewman");
	bitlestring = getPropertyFromClass("openfl.Lib", "application.window.title");
end

function onUpdatePost()
	local titlestring = bitlestring..' - '..songName..' ';
	setPropertyFromClass("openfl.Lib", "application.window.title", titlestring);
end

function onDestroy()
	setPropertyFromClass("openfl.Lib", "application.window.title", "Friday Night Funkin\': Vs. Purple Crewman");
end