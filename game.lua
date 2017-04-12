
function tick()
	if #keyBuffer ~= 0 then key = table.remove(keyBuffer, 1) end
	
	if screen == "playing" then
		pelletTimer = pelletTimer - 1
		if pelletTimer == 0 then addPellet() end
	end
end

function loseGame()
	screen = "lost"
	gameIsLost = true
	return gameIsLost
end