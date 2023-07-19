local botplayMessages = {
	'You are a cheater in song ',
	--you can add more here and the botplay text will pick one at random
}

local options = {
	['Show BOTPLAY'] = true, -- Default = true
	['Text Size'] = 30, -- Default = 30
	['Text Color'] = 'ffffff', -- Default = 'ffffff'
	['Text Font'] = 'None', -- Default = 'None' (Don't add ".ttf", script will do it automatically)
	['Static Text'] = false, -- Default = false
	['Text Transparency'] = 100, -- Default = 100 (Needs Static Text Enabled)
}

--main part of the script under here, don't change stuff unless you know what you're doing

function onCreatePost()
	chosenBotMessage = getRandomInt(1, #(botplayMessages))
	setTextString('botplayTxt', (options['Show BOTPLAY'] and 'BOTPLAY\n'..botplayMessages[chosenBotMessage])..songName or botplayMessages[chosenBotMessage])
	setTextSize('botplayTxt', options['Text Size'])
	setTextColor('botplayTxt', options['Text Color'])
	if options['Text Font'] ~= 'None' then
		setTextFont('botplayTxt', options['Text Font']..'.ttf')
	end
end
function onUpdatePost()
	if options['Static Text'] then
		setProperty('botplayTxt.alpha', options['Text Transparency']/100)
	end
end